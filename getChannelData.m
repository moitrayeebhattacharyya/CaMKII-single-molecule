function [ChannelData, MaxTracksIndex] = getChannelData(pathname, spotsFileName, tracksFileName, leftx, rightx, uppery, lowery, background)

    spots_file = fullfile(pathname, spotsFileName); % create string of given pathname & filename
    tracks_file = fullfile(pathname, tracksFileName);

    [spots_data, spots_result]= readtext([spots_file], '[,\t]', '=', '[]', 'numeric-empty2zero');
    [tracks_data, tracks_result]= readtext([tracks_file], '[,\t]', '=', '[]', 'numeric-empty2zero');
    [spots_text_data, links_text_result]= readtext([spots_file], '[,\t]', '=', '[]', 'textual');
    [tracks_text_data, tracks_text_result]= readtext([tracks_file], '[,\t]', '=', '[]', 'textual');
    'Read files'
    
    %%% Find index for intensity and location
    spots_firstrow = spots_text_data(1,:);
    MAX_INTENSITY_index = find(ismember(spots_firstrow,'MAX_INTENSITY')); 

    % ismember: logical results of A found in B or iput argument
    % find: returns a vector containing the linear indices of each nonzero element in array.
    tracks_firstrow = tracks_text_data(1,:);
    TRACK_X_LOCATION_index = find(ismember(tracks_firstrow,'TRACK_X_LOCATION'));
    TRACK_Y_LOCATION_index = find(ismember(tracks_firstrow,'TRACK_Y_LOCATION'));

    %%% Find index for frame
    TRACK_START_index = find(ismember(tracks_firstrow,'TRACK_START'));

    % Collect frame,xy location, and Max intensity data
    % Data = cell((max(tracks_data(:,TRACK_START_index))+3)/repeat,1)
    Data_all = tracks_data(2:size(tracks_data,1),[TRACK_START_index,TRACK_X_LOCATION_index,TRACK_Y_LOCATION_index]);
    Data_all(:,4) = spots_data(2:2:size(spots_data,1),MAX_INTENSITY_index);
    Dataroi = leftx<=Data_all(:,2)&Data_all(:,2) <= rightx&uppery<=Data_all(:,3)&Data_all(:,3)<= lowery;
    for i=1:size(Data_all,2)
        Data_filtered=Data_all(:,i);
        Data(:,i)=Data_filtered(Dataroi);
    end
    'Processed file data'
    
    ChannelData = [Data(:,1:3) Data(:,4)-background];
    MaxTracksIndex = max(tracks_data(:,TRACK_START_index));
end