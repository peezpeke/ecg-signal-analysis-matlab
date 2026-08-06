clc;
clear;
close all;

%% Folder containing converted MIT-BIH .mat files

output_folder = 'D:\ECG_project\output';

%% Find all .mat ECG records

files = dir(fullfile(output_folder,'*.mat'));

fprintf('\n====================================\n');
fprintf('BUILDING COMPLETE ECG DATASET\n');
fprintf('====================================\n');
fprintf('Records Found : %d\n\n', length(files));

%% Initialize combined dataset

combined_dataset = table();

successful_records = 0;
failed_records = 0;

%% Process Every Record

for i = 1:length(files)

    % Record ID
    [~, record_id, ~] = fileparts(files(i).name);

    fprintf('[%2d/%2d] Processing Record %s ... ', ...
        i, length(files), record_id);

    try

        % Process record
        record_dataset = process_record(string(record_id));

        % Append to combined dataset
        combined_dataset = [combined_dataset; record_dataset];

        successful_records = successful_records + 1;

        fprintf('Done (%d beats)\n', height(record_dataset));

   catch ME

    failed_records = failed_records + 1;

    fprintf("FAILED\n");
    fprintf("Identifier : %s\n", ME.identifier);
    fprintf("Message    : %s\n", ME.message);

        for k = 1:length(ME.stack)
            fprintf("File : %s\n", ME.stack(k).file);
            fprintf("Function : %s\n", ME.stack(k).name);
            fprintf("Line : %d\n\n", ME.stack(k).line);
        end
    
  end

end

%% Final Summary

fprintf('\n====================================\n');
fprintf('DATASET BUILD COMPLETED\n');
fprintf('====================================\n');

fprintf('Successful Records : %d\n', successful_records);
fprintf('Failed Records     : %d\n', failed_records);
fprintf('Total Heartbeats   : %d\n', height(combined_dataset));
fprintf('Total Columns      : %d\n', width(combined_dataset));

%% Overall Class Distribution

fprintf('\nOverall AAMI Class Distribution:\n');
tabulate(combined_dataset.Label);

%% Save Dataset

save('combined_ecg_dataset.mat', ...
    'combined_dataset', ...
    '-v7.3');

writetable(combined_dataset, ...
    'combined_ecg_dataset.csv');

fprintf('\nDataset saved successfully.\n');
fprintf('MAT File : combined_ecg_dataset.mat\n');
fprintf('CSV File : combined_ecg_dataset.csv\n');