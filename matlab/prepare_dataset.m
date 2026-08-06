function dataset = prepare_dataset(feature_table, matched_labels, record_id, verbose)

% Default: no console output
if nargin < 4
    verbose = false;
end

%% Verify Feature-Label Alignment

if height(feature_table) ~= length(matched_labels)
    error('Number of feature rows and labels do not match.');
end

%% Create Dataset

% Start with extracted features
dataset = feature_table;

% Add Record ID
dataset.RecordID = repmat(string(record_id), height(dataset), 1);

% Add AAMI Class Label
dataset.Label = string(matched_labels);

% Move RecordID to the first column
dataset = movevars(dataset, 'RecordID', 'Before', 1);

%% Summary (Debug Mode Only)

if verbose

    fprintf('\nFinal Dataset Created\n');
    fprintf('Number of Beats    : %d\n', height(dataset));
    fprintf('Number of Features : %d\n', width(feature_table));
    fprintf('Total Columns      : %d\n', width(dataset));

end

end