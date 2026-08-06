clc;
clear;
close all;

%% =========================================================
%  1. Load Combined Dataset
% ==========================================================

fprintf('\n========================================\n');
fprintf('ECG DATASET VALIDATION\n');
fprintf('========================================\n');

load('combined_ecg_dataset.mat', 'combined_dataset');

dataset = combined_dataset;

fprintf('\nDataset loaded successfully.\n');

fprintf('Total Rows    : %d\n', height(dataset));
fprintf('Total Columns : %d\n', width(dataset));


%% =========================================================
%  2. Check Required Columns
% ==========================================================

fprintf('\n========================================\n');
fprintf('REQUIRED COLUMN CHECK\n');
fprintf('========================================\n');

required_columns = ["RecordID", "Label"];

variable_names = string(dataset.Properties.VariableNames);

for i = 1:length(required_columns)

    if ismember(required_columns(i), variable_names)

        fprintf('%s column found.\n', required_columns(i));

    else

        error('Required column %s is missing.', ...
            required_columns(i));

    end

end


%% =========================================================
%  3. Identify Feature Columns
% ==========================================================

feature_names = setdiff( ...
    variable_names, ...
    ["RecordID", "Label"], ...
    'stable');

fprintf('\nNumber of Feature Columns : %d\n', ...
    length(feature_names));

if length(feature_names) ~= 22

    warning( ...
        'Expected 22 features, but found %d.', ...
        length(feature_names));

end


%% =========================================================
%  4. Check Missing Record IDs and Labels
% ==========================================================

fprintf('\n========================================\n');
fprintf('MISSING METADATA CHECK\n');
fprintf('========================================\n');

record_ids = string(dataset.RecordID);

labels = string(dataset.Label);

missing_record_ids = sum(ismissing(record_ids));

missing_labels = sum(ismissing(labels));

fprintf('Missing Record IDs : %d\n', ...
    missing_record_ids);

fprintf('Missing Labels     : %d\n', ...
    missing_labels);


%% =========================================================
%  5. Convert Features to Numeric Matrix
% ==========================================================

X = dataset{:, cellstr(feature_names)};


%% =========================================================
%  6. Check NaN and Inf
% ==========================================================

fprintf('\n========================================\n');
fprintf('NaN / INF CHECK\n');
fprintf('========================================\n');

nan_count = sum(isnan(X), 'all');

inf_count = sum(isinf(X), 'all');

fprintf('Total NaN Values : %d\n', nan_count);
fprintf('Total Inf Values : %d\n', inf_count);


% Count NaN / Inf per feature

nan_per_feature = sum(isnan(X), 1);

inf_per_feature = sum(isinf(X), 1);

problem_found = false;

for i = 1:length(feature_names)

    if nan_per_feature(i) > 0 || ...
       inf_per_feature(i) > 0

        problem_found = true;

        fprintf( ...
            '%s -> NaN: %d | Inf: %d\n', ...
            feature_names(i), ...
            nan_per_feature(i), ...
            inf_per_feature(i));

    end

end

if ~problem_found

    fprintf('No NaN or Inf values found in features.\n');

end


%% =========================================================
%  7. Check Class Distribution
% ==========================================================

fprintf('\n========================================\n');
fprintf('CLASS DISTRIBUTION\n');
fprintf('========================================\n');

tabulate(labels);


%% =========================================================
%  8. Check Expected AAMI Classes
% ==========================================================

expected_classes = ["N","S","V","F","Q"];

actual_classes = unique(labels);

fprintf('\nClasses Found:\n');

disp(actual_classes');

unexpected_classes = ...
    setdiff(actual_classes, expected_classes);

missing_classes = ...
    setdiff(expected_classes, actual_classes);

if isempty(unexpected_classes)

    fprintf('No unexpected class labels found.\n');

else

    fprintf('WARNING: Unexpected classes found:\n');

    disp(unexpected_classes');

end


if isempty(missing_classes)

    fprintf('All five AAMI classes are present.\n');

else

    fprintf('WARNING: Missing AAMI classes:\n');

    disp(missing_classes');

end


%% =========================================================
%  9. Record / Patient Check
% ==========================================================

fprintf('\n========================================\n');
fprintf('RECORD DISTRIBUTION\n');
fprintf('========================================\n');

unique_records = unique(record_ids);

fprintf('Number of Unique Records : %d\n', ...
    length(unique_records));


% Count beats per record

record_counts = zeros(length(unique_records),1);

for i = 1:length(unique_records)

    record_counts(i) = ...
        sum(record_ids == unique_records(i));

end


record_summary = table( ...
    unique_records, ...
    record_counts, ...
    'VariableNames', ...
    {'RecordID','BeatCount'});


fprintf('\nFirst 10 Record Counts:\n');

disp(record_summary( ...
    1:min(10,height(record_summary)), :));


fprintf('Minimum Beats in a Record : %d\n', ...
    min(record_counts));

fprintf('Maximum Beats in a Record : %d\n', ...
    max(record_counts));


%% =========================================================
%  10. RR Interval Check
% ==========================================================

fprintf('\n========================================\n');
fprintf('RR INTERVAL CHECK\n');
fprintf('========================================\n');

rr = dataset.RRInterval;

fprintf('Minimum RR Interval : %.4f s\n', ...
    min(rr));

fprintf('Maximum RR Interval : %.4f s\n', ...
    max(rr));

fprintf('Mean RR Interval    : %.4f s\n', ...
    mean(rr));


% Flag suspicious RR intervals
% These are diagnostic thresholds, not automatic deletions.

short_rr = sum(rr < 0.20);

long_rr = sum(rr > 3.00);

fprintf('\nRR < 0.20 s : %d beats\n', ...
    short_rr);

fprintf('RR > 3.00 s : %d beats\n', ...
    long_rr);


%% =========================================================
%  11. Heart Rate Check
% ==========================================================

fprintf('\n========================================\n');
fprintf('HEART RATE CHECK\n');
fprintf('========================================\n');

hr = dataset.HeartRate;

fprintf('Minimum Heart Rate : %.2f BPM\n', ...
    min(hr));

fprintf('Maximum Heart Rate : %.2f BPM\n', ...
    max(hr));

fprintf('Mean Heart Rate    : %.2f BPM\n', ...
    mean(hr));


%% =========================================================
%  12. Feature Statistics
% ==========================================================

fprintf('\n========================================\n');
fprintf('FEATURE STATISTICS\n');
fprintf('========================================\n');

feature_min = min(X, [], 1)';
feature_max = max(X, [], 1)';
feature_mean = mean(X, 1)';
feature_std = std(X, 0, 1)';


feature_statistics = table( ...
    feature_names', ...
    feature_min, ...
    feature_max, ...
    feature_mean, ...
    feature_std, ...
    'VariableNames', ...
    { ...
    'Feature', ...
    'Minimum', ...
    'Maximum', ...
    'Mean', ...
    'StdDev' ...
    });


disp(feature_statistics);


%% =========================================================
%  13. Check Constant / Near-Constant Features
% ==========================================================

fprintf('\n========================================\n');
fprintf('CONSTANT FEATURE CHECK\n');
fprintf('========================================\n');

constant_features = ...
    feature_names(feature_std == 0);

if isempty(constant_features)

    fprintf('No constant features found.\n');

else

    fprintf('WARNING: Constant features found:\n');

    disp(constant_features');

end


% Near-constant features
near_constant = ...
    feature_names(feature_std < 1e-10);

if ~isempty(near_constant)

    fprintf('Near-constant features:\n');

    disp(near_constant');

end


%% =========================================================
%  14. Final Validation Summary
% ==========================================================

fprintf('\n========================================\n');
fprintf('VALIDATION SUMMARY\n');
fprintf('========================================\n');

fprintf('Rows             : %d\n', ...
    height(dataset));

fprintf('Features         : %d\n', ...
    length(feature_names));

fprintf('Unique Records   : %d\n', ...
    length(unique_records));

fprintf('NaN Values       : %d\n', ...
    nan_count);

fprintf('Inf Values       : %d\n', ...
    inf_count);

fprintf('Missing Labels   : %d\n', ...
    missing_labels);

fprintf('Missing RecordIDs: %d\n', ...
    missing_record_ids);

fprintf('\nValidation completed.\n');