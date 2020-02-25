function intensities = getIntensities(colocalizedPoints, numNonColocalizedPoints)
    intensities = [];
    
    % Format of colocalizedPoints =
    %    Colocalization { #frames } ( #matched-points x 4-cols-with-point-info) 
    
    % Loop through all the frames and concatenate all the intensities
    for frameIndex = 1:size(colocalizedPoints, 2)
        intensities = [intensities; colocalizedPoints{frameIndex}(2:end, 4)];
    end
    
    % Concatenate non-colocalized points as zeros
    intensities = [ zeros(numNonColocalizedPoints, 1); intensities ];
end