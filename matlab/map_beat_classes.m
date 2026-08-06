function class_labels = map_beat_classes(valid_symbols)

% Create output string array
class_labels = strings(size(valid_symbols));

for i = 1:length(valid_symbols)

    symbol = valid_symbols(i);

    switch symbol

        % ---------------------------------
        % Class N : Normal-type beats
        % ---------------------------------
        case {'N','L','R','e','j'}
            class_labels(i) = "N";

            % ---------------------------------
            % Class S : Supraventricular beats
            % ---------------------------------
        case {'A','a','J','S'}
            class_labels(i) = "S";

            % ---------------------------------
            % Class V : Ventricular beats
            % ---------------------------------
        case {'V','E'}
            class_labels(i) = "V";

            % ---------------------------------
            % Class F : Fusion beats
            % ---------------------------------
        case 'F'
            class_labels(i) = "F";

            % ---------------------------------
            % Class Q : Unknown/Paced beats
            % ---------------------------------
        case {'/','f','Q'}
            class_labels(i) = "Q";

        otherwise
            class_labels(i) = "Unknown";

    end
end

end