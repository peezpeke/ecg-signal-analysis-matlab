function plot_ecg(signal, t, fs)

% Entire ECG - Lead MLII
figure;
plot(t, signal(:,1));
title('ECG Record 100 - Lead MLII');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

% Entire ECG - Lead V5
figure;
plot(t, signal(:,2));
title('ECG Record 100 - Lead V5');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

% First 10 seconds - Lead MLII
figure;
plot(t(1:10*fs), signal(1:10*fs,1));
title('First 10 Seconds - Lead MLII');
xlabel('Time (s)');
ylabel('Amplitude (mV)');
grid on;

end