function [signal, fs, t, annotation_samples, annotation_symbols, lead_names] = load_data()

    % Load ECG data
    load('D:\ECG_project\output\100.mat');

    % Convert sampling frequency to double
    fs = double(fs);

    % Create time vector
    t = (0:size(signal,1)-1) / fs;

end