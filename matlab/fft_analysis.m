function fft_analysis(signal, filtered_signal, fs)

    % Original ECG (Lead MLII)
    original = signal(:,1);

    % Remove DC offset
    original = original - mean(original);
    filtered_signal = filtered_signal - mean(filtered_signal);

    % Number of samples
    N = length(original);

    % FFT
    original_fft = abs(fft(original))/N;
    filtered_fft = abs(fft(filtered_signal))/N;

    % Positive frequencies only
    f = (0:floor(N/2)-1) * fs / N;

    figure;

    subplot(2,1,1)
    plot(f, original_fft(1:floor(N/2)), 'LineWidth', 1.2);
    title('FFT of Original ECG');
    xlabel('Frequency (Hz)');
    ylabel('Normalized Magnitude');
    xlim([0 60]);
    grid on;

    subplot(2,1,2)
    plot(f, filtered_fft(1:floor(N/2)), 'LineWidth', 1.2);
    title('FFT of Filtered ECG');
    xlabel('Frequency (Hz)');
    ylabel('Normalized Magnitude');
    xlim([0 60]);
    grid on;

end