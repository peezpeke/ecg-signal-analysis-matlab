function compare_annotations(denoised_signal, r_locs, annotation_samples)

% Show first 10 seconds
samples = 10 * 360;     % We'll improve this later using fs

figure;

plot(denoised_signal(1:samples),'b');
hold on;

% Detected peaks (red circles)
detected = r_locs(r_locs <= samples);
plot(detected, denoised_signal(detected), ...
    'ro', ...
    'MarkerSize',6, ...
    'LineWidth',1.5);

% Expert annotations (green x)
annotated = annotation_samples(annotation_samples <= samples);
plot(annotated, denoised_signal(annotated), ...
    'gx', ...
    'MarkerSize',8, ...
    'LineWidth',2);

legend('ECG','Detected','MIT-BIH Annotation');

title('Detected R Peaks vs Expert Annotation');

xlabel('Samples');
ylabel('Amplitude (mV)');
grid on;

fprintf('\n');
fprintf('Detected Peaks : %d\n',length(r_locs));
fprintf('Annotated Peaks: %d\n',length(annotation_samples));

end