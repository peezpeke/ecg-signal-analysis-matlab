function [valid_samples, valid_symbols] = ...
    filter_annotations(annotation_samples, annotation_symbols, verbose)

% Default: no console output
if nargin < 3
    verbose = false;
end

%% Valid Heartbeat Annotations (MIT-BIH)

valid_beats = ['N','L','R','A','a','J','S','V','E','F','/','f','Q'];

%% Filter Valid Heartbeats

idx = ismember(annotation_symbols, valid_beats);

valid_samples = annotation_samples(idx);
valid_symbols = annotation_symbols(idx);

%% Summary (Debug Mode Only)

if verbose
    fprintf('\nAnnotation Filtering Completed\n');
    fprintf('Original Annotations : %d\n', length(annotation_symbols));
    fprintf('Heartbeat Annotations: %d\n', length(valid_symbols));
end

end