function [beats, retained_labels, retained_locations] = ...
    segment_annotated_beats(denoised_signal, ...
    valid_samples, ...
    class_labels, ...
    verbose)

% Default: no console output
if nargin < 4
    verbose = false;
end

%% Segmentation Parameters

pre_samples = 120;
post_samples = 180;

beat_length = pre_samples + post_samples + 1;

%% Preallocate Memory

beats = zeros(length(valid_samples), beat_length);

retained_labels = strings(length(valid_samples),1);

retained_locations = zeros(length(valid_samples),1);

count = 0;

%% Segment Each Annotated Beat

for i = 1:length(valid_samples)

    % Expert annotated R-peak location
    r_location = double(valid_samples(i));

    start_index = r_location - pre_samples;
    end_index   = r_location + post_samples;

    % Skip beats too close to signal boundaries
    if start_index < 1 || end_index > size(denoised_signal,1)
        continue;
    end

    count = count + 1;

    % Extract beat segment
    beats(count,:) = ...
        denoised_signal(start_index:end_index,1)';

    % Store corresponding class
    retained_labels(count) = class_labels(i);

    % Store R-peak location
    retained_locations(count) = r_location;

end

%% Remove Unused Rows

beats = beats(1:count,:);

retained_labels = retained_labels(1:count);

retained_locations = retained_locations(1:count);

%% Summary (Debug Mode Only)

if verbose

    fprintf('\nAnnotated Beat Segmentation Completed\n');

    fprintf('Heartbeat annotations : %d\n', ...
        length(valid_samples));

    fprintf('Retained beats        : %d\n', ...
        size(beats,1));

    fprintf('Boundary beats removed: %d\n', ...
        length(valid_samples) - size(beats,1));

end

end