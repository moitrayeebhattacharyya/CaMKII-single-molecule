function plotIntensities(intensities, max_intensity, bin_size)

    hist = histogram(intensities, 'Normalization','probability','BinEdges',0:bin_size:max_intensity);
    axis([0 max_intensity 0 max(hist.Values)+0.01]);
    xlabel('Intensity (a.u.)','FontSize',20);
    ylabel('Probability','FontSize',20);
    hist.DisplayStyle='stairs';
    hist.LineWidth=2;
    %h.EdgeColor = [1,0,1];
   % title(image_title);
    ax = gca;
    ax.FontSize=20;
    %ax.XTick = 0:3000:50000;
    %ax.YTick = 0:0.01:0.3;
