function wavelet_feature = wavelet_features(beat)

    % Wavelet Type
    wavelet = 'db4';

    % Three-Level Wavelet Decomposition
    [C,L] = wavedec(beat,3,wavelet);

    % Approximation Coefficients (Level 3)
    A3 = appcoef(C,L,wavelet,3);

    % Detail Coefficients
    D3 = detcoef(C,L,3);
    D2 = detcoef(C,L,2);
    D1 = detcoef(C,L,1);

    %% -----------------------------
    % Wavelet Energy Features
    %% -----------------------------

    energy_A3 = sum(A3.^2);

    energy_D3 = sum(D3.^2);

    energy_D2 = sum(D2.^2);

    energy_D1 = sum(D1.^2);

    %% -----------------------------
    % Wavelet Entropy
    %% -----------------------------

 coeff = [A3 D3 D2 D1];

coeff = coeff.^2;

coeff = coeff / sum(coeff);

wavelet_entropy = -sum(coeff .* log2(coeff + eps));

    %% Return Features

    wavelet_feature = [ ...
        energy_A3,...
        energy_D3,...
        energy_D2,...
        energy_D1,...
        wavelet_entropy];

end
