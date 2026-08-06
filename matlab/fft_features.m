function fft_feature = fft_features(beat, fs)

    % Length of beat
    N = length(beat);

    % FFT
    Y = fft(beat);

    % Magnitude Spectrum
    magnitude = abs(Y);

    % Frequency Vector
    f = (0:N-1)*(fs/N);

    % Keep only positive frequencies
    half = floor(N/2);

    magnitude = magnitude(1:half);
    f = f(1:half);

    % Ignore DC / Baseline Wander
    valid = f >= 0.5;

    magnitude = magnitude(valid);
    f = f(valid);

    %% -------------------------------
    % Feature 1 : Dominant Frequency
    %% -------------------------------

    [~,idx] = max(magnitude);
    dominant_frequency = f(idx);

    %% -------------------------------
    % Feature 2 : Spectral Energy
    %% -------------------------------

    spectral_energy = sum(magnitude.^2);

    %% -------------------------------
    % Feature 3 : Spectral Centroid
    %% -------------------------------

    spectral_centroid = sum(f .* magnitude) / sum(magnitude);

    %% -------------------------------
    % Feature 4 : Spectral Bandwidth
    %% -------------------------------

    spectral_bandwidth = sqrt( ...
        sum(((f - spectral_centroid).^2) .* magnitude) ...
        / sum(magnitude));
    %% -------------------------------
    % Feature 5 : Band Power (0.5 - 5 Hz)
    %% -------------------------------

    low_band = (f >= 0.5) & (f < 5);
    bandpower_low = sum(magnitude(low_band).^2);

    %% -------------------------------
    % Feature 6 : Band Power (5 - 15 Hz)
    %% -------------------------------

    mid_band = (f >= 5) & (f < 15);
    bandpower_mid = sum(magnitude(mid_band).^2);

    %% -------------------------------
    % Feature 7 : Band Power (15 - 40 Hz)
    %% -------------------------------

    high_band = (f >= 15) & (f <= 40);
    bandpower_high = sum(magnitude(high_band).^2);

    %% Return Features

    fft_feature = [ ...
        dominant_frequency,...
        spectral_energy,...
        spectral_centroid,...
        spectral_bandwidth,...
        bandpower_low,...
        bandpower_mid,...
        bandpower_high];


end