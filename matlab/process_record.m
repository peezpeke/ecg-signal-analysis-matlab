function record_dataset = process_record(record_id, verbose)

if nargin < 2
    verbose = false;
end

%% Record Header

if verbose
    fprintf('\n====================================\n');
    fprintf('Processing Record %s\n', record_id);
    fprintf('====================================\n');
end

%% 1. Load Record

file_path = fullfile( ...
    'D:\ECG_project\output', ...
    record_id + ".mat");

data = load(file_path);

signal = data.signal;
fs = double(data.fs);

annotation_samples = data.annotation_samples;
annotation_symbols = data.annotation_symbols;

%% 2. Filter Non-Heartbeat Annotations

[valid_samples, valid_symbols] = ...
    filter_annotations(annotation_samples, annotation_symbols, verbose);

%% 3. Map Heartbeats to AAMI Classes

class_labels = ...
    map_beat_classes(valid_symbols);

if verbose
    fprintf('\nOriginal AAMI Class Distribution:\n');
    tabulate(class_labels);
end

%% 4. Bandpass Filtering

filtered_signal = filter_ecg(signal, fs);

%% 5. Wavelet Denoising

denoised_signal = ...
    wavelet_denoise(filtered_signal, verbose);

%% 6. Segment Using Expert Annotations

[beats, ...
 retained_labels, ...
 retained_locations] = ...
    segment_annotated_beats( ...
        denoised_signal, ...
        valid_samples, ...
        class_labels, ...
        verbose);

%% 7. Calculate RR Intervals

retained_locations = double(retained_locations(:));

rr_intervals = diff(retained_locations) / fs;

% First beat gets same RR as second beat
if ~isempty(rr_intervals)
    rr_intervals = [rr_intervals(1); rr_intervals(:)];
end

% Remove physiologically impossible RR intervals
MIN_RR = 0.20;
MAX_RR = 5.00;

rr_intervals(rr_intervals < MIN_RR) = MAX_RR;
rr_intervals(rr_intervals > MAX_RR) = MAX_RR;

%% 8. Calculate R-Peak Amplitudes

r_peaks = denoised_signal(retained_locations,1);

%% 9. Calculate Average Heart Rate

if ~isempty(rr_intervals)

    valid_rr = rr_intervals(rr_intervals > 0);

    heart_rate = 60 / mean(valid_rr);

else

    heart_rate = NaN;

end

%% 10. Safety Check

if size(beats,1) ~= length(retained_labels)

    error('Record %s: Beat-label mismatch.', record_id);

end

%% 11. Extract Features

feature_table = ...
    extract_features( ...
        beats, ...
        rr_intervals, ...
        heart_rate, ...
        r_peaks, ...
        fs, ...
        verbose);
%% 12. Prepare Dataset

record_dataset = ...
    prepare_dataset( ...
        feature_table, ...
        retained_labels, ...
        record_id, ...
        verbose);

%% 13. Final Summary (Verbose Only)

if verbose

    fprintf('\nRecord %s Completed\n', record_id);
    fprintf('Final Beats : %d\n', height(record_dataset));

    fprintf('\nFinal Class Distribution:\n');
    tabulate(retained_labels);

end

end