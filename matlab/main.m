clc;
clear;
close all;

%% 1. Load ECG Data

[signal, fs, t, annotation_samples, annotation_symbols, lead_names] = load_data();


%% 2. Filter Non-Heartbeat Annotations

[valid_samples, valid_symbols] = filter_annotations( ...
    annotation_samples, ...
    annotation_symbols);


%% 3. Map Beat Annotations into AAMI Classes

class_labels = map_beat_classes(valid_symbols);

% Display original heartbeat distribution
fprintf('\nOriginal Heartbeat Annotations:\n');
tabulate(valid_symbols)

% Display grouped class distribution
fprintf('\nAAMI Class Distribution:\n');
tabulate(class_labels)


%% 4. Plot ECG

plot_ecg(signal, t, fs);


%% 5. Bandpass Filtering

filtered_signal = filter_ecg(signal, fs);


%% 6. FFT Analysis

fft_analysis(signal, filtered_signal, fs);


%% 7. Wavelet Denoising

denoised_signal = wavelet_denoise(filtered_signal);


%% 8. R-Peak Detection

[r_peaks, r_locs, heart_rate, rr_intervals] = ...
    detect_rpeaks(denoised_signal, fs);
%% 9. Match Detected Beats with Expert Annotations

[matched_labels, matched_indices] = match_annotations( ...
    r_locs, ...
    valid_samples, ...
    class_labels, ...
    fs, ...
    length(denoised_signal));

%% 10. Compare Detected Peaks with Expert Annotations

compare_annotations( ...
    denoised_signal, ...
    r_locs, ...
    annotation_samples);


%% 11. Keep Only Successfully Matched R-Peaks

matched_r_locs = r_locs(matched_indices);
matched_r_peaks = r_peaks(matched_indices);


%% 12. Calculate RR Intervals for Matched Beats

% Calculate time difference between consecutive matched R-peaks
matched_rr_intervals = diff(matched_r_locs) / fs;

% diff() produces one fewer value than the number of beats.
% Add one value at the beginning so every beat has an RR value.
if ~isempty(matched_rr_intervals)
    matched_rr_intervals = ...
        [matched_rr_intervals(1); matched_rr_intervals(:)];
end


%% 13. Segment Only Successfully Matched Heartbeats

beats = segment_beats( ...
    denoised_signal, ...
    matched_r_locs);


%% 14. Extract Features

feature_matrix = extract_features( ...
    beats, ...
    matched_rr_intervals, ...
    heart_rate, ...
    matched_r_peaks, ...
    fs);


%% 15. Check Feature-Label Alignment

fprintf('\nFinal Alignment Check\n');

fprintf('Feature rows : %d\n', ...
    height(feature_matrix));

fprintf('Labels       : %d\n', ...
    length(matched_labels));


tabulate(matched_labels)
%% 18. Prepare Final Labeled Dataset

dataset = prepare_dataset( ...
    feature_matrix, ...
    matched_labels, ...
    "100");


%% 19. Display Final Dataset

fprintf('\nFirst 8 Rows of Final Dataset:\n');

head(dataset)
