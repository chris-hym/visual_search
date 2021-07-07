%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%% Skeleton code provided as part of the coursework assessment
%% This code will iterate through every image in the MSRCv2 dataset
%% and call a function 'extractRandom' to extract a descriptor from the
%% image.  Currently that function returns just a random vector so should
%% be changed as part of the coursework exercise.
%%
%% (c) John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom

close all;
clear all;

% Define the level of quantization of the RGB space (Q)
Q=4;
% Define the dimensions of grid descriptor
row=10;
col=10;
% Define a matrix to store PCA features
ALLFEAT=[];
%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'C:\Users\hym\Documents\Coursework\Computer Vision and Pattern Recognisation\cwork_basecode_2012\MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'C:\Users\hym\Documents\Coursework\Computer Vision and Pattern Recognisation\cwork_basecode_2012\cwsolution\descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER='globalRGBhisto';

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    % Using a random row representing an image descriptor
    %F=extractRandom(img);
    % Using the average RGB as a desctiptor
    %F=averageRGB(img);
    % Using the Global Colour Histogram as a descriptor
    %F=ComputeRGBHistogram(img,Q);
    % Using the Grid based image descriptor
    F=ComputeGrid(img,row,col);
    % Using PCA first store descriptor information into ALLFEAT
    ALLFEAT=[ALLFEAT ; F];
    toc
end

% Build the PCA for each image and choose the dimension to be 10
ALLFEAT=ALLFEAT';
e=Eigen_Build(ALLFEAT);
e=Eigen_Deflate(e,'keepn',10);
ALLFEATPCA=Eigen_Project(ALLFEAT,e)';


% Store the PCA information for descriptors
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./255;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    F=ALLFEATPCA(filenum,:);
    save(fout,'F');
    toc
end
