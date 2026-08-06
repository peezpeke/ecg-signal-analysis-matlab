function beats = segment_beats(denoised_signal, r_locs)

    % Number of samples before and after the R-peak
    pre_samples = 120;
    post_samples = 180;

    % Total samples in one beat
    beat_length = pre_samples + post_samples + 1;

    % Preallocate memory
    beats = zeros(length(r_locs), beat_length);

    % Counter for valid beats
    count = 1;

    % Segment each heartbeat
    for i = 1:length(r_locs)

        start_index = r_locs(i) - pre_samples;
        end_index   = r_locs(i) + post_samples;

        % Skip beats too close to the start or end
        if start_index < 1 || end_index > length(denoised_signal)
            continue;
        end

        % Extract heartbeat
        beat = denoised_signal(start_index:end_index);

        % Store heartbeat
        beats(count,:) = beat';

        count = count + 1;

    end

    % Remove unused rows
    beats = beats(1:count-1,:);

    % Display number of segmented beats
    fprintf('\n');
    fprintf('Number of segmented beats : %d\n', size(beats,1));

    % Plot first five segmented beats
    figure;

    for i = 1:min(5,size(beats,1))

        subplot(5,1,i);

        plot(beats(i,:),'LineWidth',1.2);

        title(['Segmented Beat ', num2str(i)]);
        ylabel('Amplitude (mV)');
        grid on;

    end

    xlabel('Samples');

end