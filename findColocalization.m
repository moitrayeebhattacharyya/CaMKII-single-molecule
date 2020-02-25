% Finds the colocalizations of the given channel data (any number of them)
% Returns same number of colocalization data as the given channel data
% Format of each returned colocalization point data =
%    Colocalization { #frames } ( #matched-points x 4-cols-with-point-info)
%
function varargout = findColocalization(Threshold, MaxFrameIndex, varargin)
    SquareThreshold = Threshold^2;
    NumChannels = size(varargin, 2);

    % Calculate how many real frames of data will be there
    NumFrames = 0;
    for FrameIndex = 0:3:MaxFrameIndex
        NumFrames = NumFrames + 1;
    end
    
    % Initialize data structures 
    AllChannelData = cell(1);
    AllChannelColocalizations = cell(1);    
    AllChannelEfficiencies = zeros(NumChannels, NumFrames);
    
    % Populate the input data from the function arguments
    for ChannelIndex = 1:NumChannels
        AllChannelData{ChannelIndex} = varargin{ChannelIndex};
        AllChannelColocalizations{ChannelIndex} = cell(1);
    end

    RealFrameIncrement = 1;
    
    % For each frame in the input data, 
    %     For each channel, extract the frame's data
    %     Find a spot in frame that matches across all the channels
    %           When found, for each channel, record the matched spot
    %     For each channel, calculate % of spot matched wrt total spots in frame 
    for FrameIndex = 0:3:MaxFrameIndex        
        % Extract each channel data from the selected frame
        AllChannelFrameData = cell(1);
        for ChannelIndex = 1:NumChannels
            SelectedChannelData = AllChannelData{ChannelIndex};
            AllChannelColocalizations{ChannelIndex}{RealFrameIncrement}(1,1:4) = 0;
            iframe = find(ismember(SelectedChannelData(:,1),FrameIndex));
            AllChannelFrameData{ChannelIndex} = SelectedChannelData(iframe,:);
        end

        l = 2;

        % Pick a spot from the first channel. Try to find a matching spot from
        % each of the other channels. If matched spots are found in all the
        % channels, then record the matched spots in the
        % AllChannelColocalizations.
        for j = 1:size(AllChannelFrameData{1}, 1) % each spot in first channel
            MatchedSpot = cell(1);
            MatchedSpot{1} = AllChannelFrameData{1}(j,:);        
            
            for ChannelIndex = 2:NumChannels
                % For each N-1 channels, find the spot in the selected 
                % channel that matches with the first channel.
                matched = false;

                for k = 1:size(AllChannelFrameData{ChannelIndex}, 1) % each spot in the nth channel
                    ThisFrameData = AllChannelFrameData{1};
                    ThatFrameData = AllChannelFrameData{ChannelIndex};

                    SquareDist=(ThisFrameData(j,2)-ThatFrameData(k,2))^2 + (ThisFrameData(j,3)-ThatFrameData(k,3))^2;
                    if SquareDist <= SquareThreshold
                       MatchedSpot{ChannelIndex} = ThatFrameData(k, :);
                       matched = true;
                       break
                    end
                end

                % If no spot was matched this channel, then stop checking other channels
                if matched == false
                    break;
                end
            end

            % If spots were matched in all channels, then the matched spots in 
            % corresponding positions in AllChannelColocalizations.
            if size(MatchedSpot, 2) == NumChannels
                for ChannelIndex = 1:NumChannels
                    AllChannelColocalizations{ChannelIndex}{RealFrameIncrement}(l,:) = MatchedSpot{ChannelIndex};
                end
                l = l + 1;
            end
        end
        
        % Calculate efficiency (i.e. % spot of total spot matched) for each
        % channel
        for ChannelIndex = 1:NumChannels
            AllChannelEfficiencies(ChannelIndex, RealFrameIncrement) = (size(AllChannelColocalizations{ChannelIndex}{RealFrameIncrement},1)-1)/size(AllChannelFrameData{ChannelIndex},1);
        end
        
        RealFrameIncrement = RealFrameIncrement + 1;
    end
    
    % For each channel, calculate average efficiency across all frames
    for ChannelIndex = 1:NumChannels
        ChannelEfficiency = [ChannelIndex, mean(AllChannelEfficiencies(ChannelIndex, :)), std(AllChannelEfficiencies(ChannelIndex, :)) ];
        ChannelEfficiency        
    end
    
    % Set the return values with the Colocalization.
    % Format of returned Colocalization =
    %    Colocalization { #frames } ( #matched-points x 4-cols-with-point-info) 
    for k = 1:nargout
        varargout{k} = AllChannelColocalizations{k};
    end    
end

