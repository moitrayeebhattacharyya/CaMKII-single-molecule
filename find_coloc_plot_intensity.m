% Script to analyze pairwise (488:560 or 488:640) Colocalization efficiency from 
% TrackMate tracks statistics and plot intensity histograms
%2016.06.21 Moitrayee Bhattacharyya, UC Berkeley
%2016.12.07 v4. add a feature that can define roi. by Young Kwang Lee
%2017.01.20 v4.1 add intensity cutoff for 488 channel.

% Run each section separately 

%% User Parameters
%
clc
clear all
%
threshold=2; % in pixel.
leftx=80; % position cutoff, particles outside the center area of 350 x 350 pixel2 were excluded due to heterogeneous TIRF illumination
rightx=430; % particles outside the center area of 350 x 350 pixel2 were excluded due to heterogeneous TIRF illumination
uppery=80;  % particles outside the center area of 350 x 350 pixel2 were excluded due to heterogeneous TIRF illumination
lowery=430; % particles outside the center area of 350 x 350 pixel2 were excluded due to heterogeneous TIRF illumination
roi = rightx-leftx; % particles outside the center area of 350 x 350 pixel2 were excluded due to heterogeneous TIRF illumination
background488=920; % enter 0 if background is not subtracted
background560=501; % enter 0 if background is not subtracted
Max_int=16500; % 16500 is real max for Kuriyan lab scope (16064 is the real max)
bin = 500; % bin size for histogram
parameters=[threshold roi background488 background560 Max_int bin];
count=1;
repeat=3; % Periodicity of image (typically 3. one blank+duplicated images)

%Call the csv files obtained from TrackMate
pathname= '/Users/moi/Dropbox/MB-Kuriyanlab/lab-notebook/Experiments/Cell-Based-Studies/images/programs-for-analysis/program-TD-edits/elife-suppl/test-data-figure3b-left-panel-for-alpha' % path to the .csv files for track and spot statistics
csvwrite(fullfile(pathname,'00_parameters.csv'),parameters);


%% Reads the spot and track statistics from the supplied csv files
% code getChannelData.m and readtext.m has to be in the same folder as this code for
% calling
[ChannelData488, MaxTrackIndex488] = getChannelData(pathname, 'Spots in tracks statistics488.csv', 'Track statistics488.csv', leftx, rightx, uppery, lowery, background488);
[ChannelData560, MaxTrackIndex560] = getChannelData(pathname, 'Spots in tracks statistics560.csv', 'Track statistics560.csv', leftx, rightx, uppery, lowery, background560);


%% ##################### FILTERED 488 CALCULATIONS #####################

%% Calculate filtered colocalization 
% code findColocalization.m has to be in the same folder as this code for
% calling
Upper_CutoffInt_value_488 = 2500 % mEGFP-CaMKII with 488-channel intensity greater than 2500 
FilteredChannelData488 = ChannelData488(ChannelData488(:,4) > Upper_CutoffInt_value_488,:);
[FilteredColocalization488, FilteredColocalization560] = findColocalization(threshold, MaxTrackIndex560, FilteredChannelData488, ChannelData560);


%% intensities of 560 channel for colocalized spots normalized by non-colocalized spots 
[ NumFilteredColocalized488, NumFilteredNonColocalized488] = getColocalizationCounts(FilteredChannelData488, FilteredColocalization488)
FilteredIntensities560 = getIntensities(FilteredColocalization560, NumFilteredNonColocalized488);


%% Plot intensities of 560 channel after filtering point greater than 15000 and binning at 500
for i=1:size(FilteredIntensities560)
    if FilteredIntensities560(i,1) <= 15000
        FilteredIntensities560_uppercut(count,1) = FilteredIntensities560(i,1) ;
        count=count+1;
    end
end
count=1;
hist = histogram(FilteredIntensities560_uppercut, 'Normalization','probability','BinEdges',0:500:15000);
    axis([0 Max_int 0 max(hist.Values)+0.01]);
    xlabel('Intensity (a.u.)','FontSize',20);
    ylabel('Probability','FontSize',20);
    hist.DisplayStyle='stairs';
    hist.LineWidth=2;
    h.EdgeColor = [1,0,1];
    ax = gca;
    ax.FontSize=20;
%%   
% issue a HOLD command after this section to overlay the next plot


%% Plot line plots taking the max of each bin instead of histogram for clarity
%(this is the plot reported in the paper)
hvalues=hist.Values;
bar_zero=hvalues(1);
hvalues(1)=[];
tmp = [1:hist.NumBins];
hbins = tmp * hist.BinWidth;
bin_zero=hbins(1);
hbins(1)=[];
plot (hbins,hvalues);
bar(0,bar_zero,1000,'r');
