function filtered_signal = filter_ecg(signal, fs, verbose)

% Default: no plots
if nargin < 3
    verbose = false;
end

%% Design 4th-Order Butterworth Bandpass Filter

[b, a] = butter(4, [0.5 40] / (fs / 2), "bandpass");

%% Apply Zero-Phase Filtering

filtered_signal = filtfilt(b, a, signal(:,1));

%% Visualization (Debug Mode Only)

if verbose

    t = (0:length(filtered_signal)-1) / fs;

    % Display only the first 10 seconds
    plot_samples = min(round(10 * fs), length(filtered_signal));

    figure('Name','Bandpass Filtering','NumberTitle','off');

    subplot(2,1,1)
    plot(t(1:plot_samples), signal(1:plot_samples,1));
    title('Original ECG');
    xlabel('Time (s)');
    ylabel('Amplitude (mV)');
    grid on;

    subplot(2,1,2)
    plot(t(1:plot_samples), filtered_signal(1:plot_samples));
    title('Bandpass Filtered ECG');
    xlabel('Time (s)');
    ylabel('Amplitude (mV)');
    grid on;

end

end