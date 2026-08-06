clc;
clear;
close all;

dataset_test = process_record("200");

fprintf('\nDataset Size:\n');
disp(size(dataset_test));

fprintf('\nFirst 8 Rows:\n');
head(dataset_test)

fprintf('\nFinal Class Distribution:\n');
tabulate(dataset_test.Label)