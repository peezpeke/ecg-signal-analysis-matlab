clc;
clear;
close all;

fprintf('\n========================================\n');
fprintf('FEATURE NORMALIZATION\n');
fprintf('========================================\n');

%% ==========================================
% Load datasets
%% ==========================================

load('train_dataset.mat','train_dataset');
load('test_dataset.mat','test_dataset');

%% ==========================================
% Feature names
%% ==========================================

featureNames = train_dataset.Properties.VariableNames;

featureNames = setdiff( ...
    featureNames,...
    {'RecordID','Label'},...
    'stable');

%% ==========================================
% Extract Features
%% ==========================================

Xtrain = train_dataset{:,featureNames};
Xtest  = test_dataset{:,featureNames};

%% ==========================================
% Compute Training Statistics
%% ==========================================

mu = mean(Xtrain,1);

sigma = std(Xtrain,0,1);

%% ==========================================
% Prevent division by zero
%% ==========================================

sigma(sigma==0)=1;

%% ==========================================
% Normalize
%% ==========================================

Xtrain_norm = (Xtrain-mu)./sigma;

Xtest_norm = (Xtest-mu)./sigma;

%% ==========================================
% Put normalized features back
%% ==========================================

train_normalized = train_dataset;
test_normalized  = test_dataset;

train_normalized{:,featureNames}=Xtrain_norm;
test_normalized{:,featureNames}=Xtest_norm;

%% ==========================================
% Save
%% ==========================================

save('train_normalized.mat','train_normalized');

save('test_normalized.mat','test_normalized');

save('normalization_parameters.mat',...
    'mu',...
    'sigma',...
    'featureNames');

%% ==========================================
% Verification
%% ==========================================

fprintf('\n========================================\n');
fprintf('VERIFICATION\n');
fprintf('========================================\n');

trainMean = mean(Xtrain_norm);

trainStd = std(Xtrain_norm);

fprintf('\nAverage absolute mean : %.6f\n', ...
    mean(abs(trainMean)));

fprintf('Average std deviation : %.6f\n', ...
    mean(trainStd));

fprintf('\nTraining Beats : %d\n',height(train_normalized));

fprintf('Testing Beats  : %d\n',height(test_normalized));

fprintf('Features       : %d\n',length(featureNames));

fprintf('\nNormalization completed successfully.\n');
fprintf('\nMinimum normalized value : %.2f\n', min(Xtrain_norm,[],'all'));
fprintf('Maximum normalized value : %.2f\n', max(Xtrain_norm,[],'all'));
%% ==========================================
% Find extreme normalized values
%% ==========================================

fprintf('\n========================================\n');
fprintf('EXTREME FEATURE VALUES\n');
fprintf('========================================\n');

for i = 1:length(featureNames)

    feature = Xtrain_norm(:,i);

    fprintf('%-20s Min = %8.2f   Max = %8.2f\n', ...
        featureNames{i}, ...
        min(feature), ...
        max(feature));

end