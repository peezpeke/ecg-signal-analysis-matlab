function [r_peaks, r_locs, heart_rate, rr_intervals] = detect_rpeaks(denoised_signal, fs)

% Detect R-peaks
[r_peaks, r_locs] = findpeaks(denoised_signal, ...
    'MinPeakHeight', 0.6, ...
    'MinPeakDistance', round(0.2 * fs));

% RR intervals (seconds)
rr_intervals = diff(r_locs) / fs;

% Average heart rate (BPM)
heart_rate = 60 / mean(rr_intervals);

% Display results
fprintf('Number of R-peaks detected : %d\n', length(r_locs));
fprintf('Estimated Heart Rate       : %.2f BPM\n', heart_rate);

% Plot first 10 seconds
figure;

samples = 10 * fs;

plot(denoised_signal(1:samples), 'b');
hold on;

% Show only peaks in first 10 seconds
idx = r_locs <= samples;

plot(r_locs(idx), r_peaks(idx), ...
    'ro', ...
    'MarkerFaceColor', 'r', ...
    'MarkerSize', 6);

title('Detected R Peaks (First 10 Seconds)');
xlabel('Samples');
ylabel('Amplitude (mV)');
grid on;

end