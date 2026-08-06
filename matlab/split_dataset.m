clc;
clear;
close all;

fprintf('\n========================================\n');
fprintf('STRATIFIED PATIENT-WISE TRAIN / TEST SPLIT\n');
fprintf('========================================\n');

%% Load dataset
load('combined_ecg_dataset.mat','combined_dataset');
dataset = combined_dataset;

classes = ["N","S","V","F","Q"];

%% Overall distribution
overallCounts = zeros(1,length(classes));

for i = 1:length(classes)
    overallCounts(i) = sum(dataset.Label == classes(i));
end

overallPercent = overallCounts/sum(overallCounts);

%% Unique records
recordIDs = unique(dataset.RecordID);

numRecords = length(recordIDs);

trainCount = round(0.8*numRecords);

bestScore = inf;

rng(42);

%% ==========================================================
% Try many random patient-wise splits
%% ==========================================================

numTrials = 1000;

for trial = 1:numTrials

    shuffled = recordIDs(randperm(numRecords));

    trainRecords = shuffled(1:trainCount);
    testRecords = shuffled(trainCount+1:end);

    trainMask = ismember(dataset.RecordID,trainRecords);
    testMask  = ismember(dataset.RecordID,testRecords);

    trainData = dataset(trainMask,:);
    testData  = dataset(testMask,:);

    trainPercent = zeros(1,length(classes));
    testPercent  = zeros(1,length(classes));

    for c = 1:length(classes)

        trainPercent(c) = sum(trainData.Label==classes(c))/height(trainData);

        testPercent(c) = sum(testData.Label==classes(c))/height(testData);

    end

    % Total distribution error

    score = sum(abs(trainPercent-overallPercent)) + ...
            sum(abs(testPercent-overallPercent));

    if score < bestScore

        bestScore = score;

        bestTrainRecords = trainRecords;
        bestTestRecords = testRecords;

        bestTrain = trainData;
        bestTest = testData;

    end

end

%% ==========================================================
% Final statistics
%% ==========================================================

fprintf("\nBest Distribution Error : %.6f\n",bestScore);

fprintf("\nTraining Records : %d\n",length(bestTrainRecords));
fprintf("Testing Records  : %d\n",length(bestTestRecords));

fprintf("\nTraining Beats : %d\n",height(bestTrain));
fprintf("Testing Beats  : %d\n",height(bestTest));

%% Verify overlap

overlap = intersect(bestTrainRecords,bestTestRecords);

if isempty(overlap)
    fprintf("\nNo overlapping records.\n");
else
    error("Overlap detected.");
end

%% Train distribution

fprintf('\n========================================\n');
fprintf('TRAIN CLASS DISTRIBUTION\n');
fprintf('========================================\n');

tabulate(bestTrain.Label)

%% Test distribution

fprintf('\n========================================\n');
fprintf('TEST CLASS DISTRIBUTION\n');
fprintf('========================================\n');

tabulate(bestTest.Label)

%% Save

train_dataset = bestTrain;
test_dataset = bestTest;

save('train_dataset.mat','train_dataset');
save('test_dataset.mat','test_dataset');

fprintf('\n========================================\n');
fprintf('FILES SAVED\n');
fprintf('========================================\n');

fprintf('train_dataset.mat\n');
fprintf('test_dataset.mat\n');