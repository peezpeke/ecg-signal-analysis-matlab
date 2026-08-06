function [matched_labels, matched_indices] = match_annotations( ...
    r_locs, valid_samples, class_labels, fs, signal_length)

% Maximum allowed distance between detected R-peak
% and expert annotation: 150 ms
tolerance = round(0.15 * fs);

% Same segmentation window used in segment_beats.m
pre_samples = 120;
post_samples = 180;

% Initialize outputs
matched_labels = strings(0,1);
matched_indices = [];

for i = 1:length(r_locs)

    % Check whether this beat would survive segmentation
    start_index = r_locs(i) - pre_samples;
    end_index   = r_locs(i) + post_samples;

    if start_index < 1 || end_index > signal_length
        continue;
    end

    % Find nearest expert heartbeat annotation
    [min_distance, annotation_index] = ...
        min(abs(valid_samples - r_locs(i)));

    % Accept only if annotation is close enough
    if min_distance <= tolerance

        matched_labels(end+1,1) = ...
            class_labels(annotation_index);

        matched_indices(end+1,1) = i;

    end

end

fprintf('\nAnnotation Matching Completed\n');
fprintf('Detected R-peaks        : %d\n', length(r_locs));
fprintf('Successfully Matched    : %d\n', length(matched_labels));
fprintf('Unmatched/Skipped Beats : %d\n', ...
    length(r_locs) - length(matched_labels));

end