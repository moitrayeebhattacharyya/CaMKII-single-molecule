# CaMKII-single-molecule



README for Matlab codes and analysis

1. Get all the raw image files in .tif format in a folder of your choice. Generate a pairwise composite image (488:560 channels or 488:640 channels) using virtual stack in ImageJ.

2. Use the code CAMKII_ImageJ_Pretreatment_Duplication_v2_TwoChannel_WOBlank.m to reconstruct duplicate images for tracking in the TrackMate module of ImageJ (check code comments for details). These should write out files Tirf488.tif (for 488 channel) and Tirf560.tif (for 560 channel). Note that if you have a 488:640 composite pair, the output files are still called Tirf488.tif and Tirf560.tif, where Tirf560.tif represents data for the 640 channel.

3. Individual single particles were detected by analyzing these files (Tirf488.tif and Tirf560.tif) using the single particle tracking plugin TrackMate in ImageJ (Jaqaman et al., 2008). These will generate spot and track statistics for each single particle, and is written out as .csv files. Append the channel name to these .csv (check test dataset/code in step 4 for the naming of these files).

4. These spot and track statistics .csv files are inputs to the code find_coloc_plot_intensity.m, which calculates the fraction of colocalization and plots the intensity histograms (check code comments for details).

A test dataset is provided in the sub-folder test-data- for-CaMKII-alpha.



