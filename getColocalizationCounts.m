function [numColocalized, numNonColocalized] = getColocalizationCounts(allPoints, colocalizedPoints)
    
    % Format of colocalizedPoints =
    %    Colocalization { #frames } ( #matched-points x 4-cols-with-point-info) 
    
    numColocalized = 0;
    for frameIndex = 1:size(colocalizedPoints, 2)
        numColocalized = numColocalized + size(colocalizedPoints{frameIndex}, 1) - 1;
    end
    
    numNonColocalized = size(allPoints, 1) - numColocalized;
end
