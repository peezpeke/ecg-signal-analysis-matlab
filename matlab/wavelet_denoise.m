function denoised_signal = wavelet_denoise(filtered_signal, verbose)

% Default: no plots
if nargin < 2
    verbose = false;
end

%% Wavelet Parameters

level = 5;
wavelet = 'db4';

%% Wavelet Decomposition

[C, L] = wavedec(filtered_signal, level, wavelet);

%% Estimate Noise Level

sigma = median(abs(detcoef(C, L, 1))) / 0.6745;

%% Universal Threshold

threshold = sigma * sqrt(2 * log(length(filtered_signal)));

%% Soft Thresholding

C_thresh = wthresh(C, 's', threshold);

%% Reconstruct Signal

denoised_signal = waverec(C_thresh, L, wavelet);

%% Visualization (Debug Mode Only)

if verbose

    plot_samples = min(3600, length(filtered_signal));

    figure('Name','Wavelet Denoising','NumberTitle','off');

    subplot(2,1,1)
    plot(filtered_signal(1:plot_samples));
    title('Bandpass Filtered ECG');
    xlabel('Samples');
    ylabel('Amplitude');
    grid on;

    subplot(2,1,2)
    plot(denoised_signal(1:plot_samples));
    title('Wavelet Denoised ECG');
    xlabel('Samples');
    ylabel('Amplitude');
    grid on;

end

end