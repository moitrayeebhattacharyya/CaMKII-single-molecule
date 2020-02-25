% script to reconstruct duplicate images for tracking in the trackmate
%2016.06.21 Young Kwang Lee, UC Berkeley

clc;
clear all;
%------Input parameters------
FileTif='/Users/moi/Dropbox/MB-Kuriyanlab/lab-notebook/Experiments/Cell-Based-Studies/images/programs-for-analysis/program-TD-edits/elife-suppl/test-data-figure3b-left-panel-for-alpha/alpha-nopptase-composite.tif' % path to the composite image
OutputFileName2 = 'Tirf560.tif'; % check the order of channels
OutputFileName1 = 'Tirf488.tif';
Groups=2;
[path,name,ext]=fileparts(FileTif);
OutputFile1 = fullfile(path,OutputFileName1);
OutputFile2 = fullfile(path,OutputFileName2);

% ----------------------------
% Load image
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
OriginalStack=zeros(nImage,mImage,NumberImages,'uint16');

for i=1:NumberImages
   OriginalStack(:,:,i)=imread(FileTif,'Index',i,'Info',InfoImage);
end

%----- Creat 560 channel image -----
Tirf560=zeros(nImage,mImage,NumberImages/Groups*3,'uint16');
% 560 data in 2,5,8... frame
for i=1:NumberImages/Groups;
    j=i*Groups-1;
    Tirf560(:,:,i*3-1)=OriginalStack(:,:,j);
end
% 560 data in 3,6,9... frame (duplicated)
for i=1:NumberImages/Groups;
    j=i*Groups-1;
    Tirf560(:,:,i*3)=OriginalStack(:,:,j);
end
% 560 blank data in 1,4,7... frame
for i=1:3:NumberImages/Groups*3;
    Tirf560(:,:,i)=0;
end

%----- Creat 488 Channel image -----
Tirf488=zeros(nImage,mImage,NumberImages/Groups*3,'uint16');
% 488 data in 2,5,8... frame
for i=1:NumberImages/Groups; %1-10
    j=i*Groups; %3,6,9...
    Tirf488(:,:,i*3-1)=OriginalStack(:,:,j);
end
% 488 data in 3,6,9... frame (duplicated)
for i=1:NumberImages/Groups; 
    j=i*Groups;
    Tirf488(:,:,i*3)=OriginalStack(:,:,j);
end
% 488 blank data in 1,4,7... frame
for i=1:3:NumberImages/Groups*3;
    Tirf488(:,:,i)=0;
end

% -----Write pretreated images-----
for i=2:size(Tirf560,3);
    imwrite(Tirf560(:,:,i),OutputFile1,'WriteMode','append','Compression','none');
end
for i=2:size(Tirf488,3);
    imwrite(Tirf488(:,:,i),OutputFile2,'WriteMode','append','Compression','none');
end


