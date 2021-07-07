%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%% Skeleton code provided as part of the coursework assessment
%%
%% This code will load in all descriptors pre-computed (by the
%% function cvpr_computedescriptors) from the images in the MSRCv2 dataset.
%%
%% It will pick a descriptor at random and compare all other descriptors to
%% it - by calling cvpr_compare.  In doing so it will rank the images by
%% similarity to the randomly picked descriptor.  Note that initially the
%% function cvpr_compare returns a random number - you need to code it
%% so that it returns the Euclidean distance or some other distance metric
%% between the two descriptors it is passed.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'C:\Users\hym\Documents\Coursework\Computer Vision and Pattern Recognisation\cwork_basecode_2012\MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'C:\Users\hym\Documents\Coursework\Computer Vision and Pattern Recognisation\cwork_basecode_2012\cwsolution\descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER='globalRGBhisto';


%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection
%queryimg=floor(rand()*NIMG);    % index of a random image
queryimg=240;

%% 3) Compute the distance of image to the query
dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    query=ALLFEAT(queryimg,:);
    % Returning a random number
    %thedst=cvpr_compare(query,candidate);
    % Calculating the Euclidean Distance
    %thedst=EuclideanDistance(query,candidate);
    % Calculating the Manhattan Distance
    %thedst=ManhattanDistance(query,candidate);
    % Calculating the Mahalanobis Distance
    thedst=MahalanobisDistance(query,candidate,ALLFEAT);
    dst=[dst ; [thedst i]];
end
dst=sortrows(dst,1);  % sort the results

%% 4) Evaluate the results using PR curve
%% Precision = TP / (TP + FP)
%% Recall = TP / (TP + FN)
%% Where: 
%% False Positive (FP): Predict an event when there was no event
%% True Positive (TP): Predict an event when there was an event
%% False Negative (FN): Predict no event when there was an event
%% Define the first number in the file name to be the class
%% Therefore, there are 20 classes and each class has 30 members
%% except the 20th class has 21 members

% Denfine the total number of classes
class=20;
% Find query image class using file name
queryimgname=allfiles(queryimg).name;
% Use strtok() to read the first number which is defined as the class of the
% image and change it to a double using str2double() 
queryclass=str2double(strtok(queryimgname,"_"));

% Define the number of class memmbers
if (queryclass==20)
    n_classmember=21;
else
    n_classmember=30;
end

% Set TP=0 as a default
TP=0;
% Calculate percision and recall for each result
for i=1:filenum
    candidatename=allfiles(dst(i,2)).name;
    candidateclass=str2double(strtok(candidatename,"_"));
    if (queryclass==candidateclass)
        TP=TP+1;
    end
    percision(i,1)=TP./i;
    recall(i,1)=TP./n_classmember;
end

% Plot the PR curve
figure(1);
plot(recall(:,1),percision(:,1),"bx-");
title('Percision Recall Curve')
xlabel('Recall');
ylabel('Percision');
axis([0 1 0 1]);


%% 5) Visualise the results
%% These may be a little hard to see using imgshow
%% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

SHOW=15; % Show top 15 results
dst=dst(1:SHOW,:);
outdisplay=[];
for i=1:size(dst,1)
   img=imread(ALLFILES{dst(i,2)});
   img=img(1:2:end,1:2:end,:); % make image a quarter size
   img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
   outdisplay=[outdisplay img];
end

% Display query image 
img=imread(ALLFILES{queryimg});
img=img(1:2:end,1:2:end,:); % make image a quarter size
img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
outdisplay=[img outdisplay];

figure(2);
imgshow(outdisplay);
axis off;
