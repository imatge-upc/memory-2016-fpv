
%% This scripts uses the ConvolutionalNN provided by Caffe to extract features
% for the given set of images.


data_path = '/imatge/rmestre/work/Images/testImages/';
caffe_path = '/usr/local/opt/caffe/matlab/caffe/';
folders = {'Resized'};

size_features = 4096;
addpath(caffe_path);

%% Go through each folder
cd(caffe_path)
nFold = length(folders);
count_fold = 1;
for f = folders
    %images = dir([this_path '/' f{1} '/features/*.jpg']);
    images = dir([data_path '/' f{1} '/*.jpg']);
    features = zeros(length(images), size_features);
    %% For each image in this folder
    count_im = 1;
    names = {images(:).name};
    nImages = length(names);
    for i = 1:nImages
        im = names{i};
        %im = imread([this_path '/' f{1} '/features/' im]);
        im = imread([data_path '/' f{1} '/' im]);
        % Load features
        [scores, ~] = matcaffe_demo(im, 0);
        features(i, :) = scores(i)';
        % Count progress
        if(mod(count_im, 50) == 0 || count_im == nImages)
            disp(['Folder ' num2str(count_fold) '/' num2str(nFold) ': processed ' num2str(count_im) '/' num2str(nImages) ' images.']);
        end
        count_im = count_im +1;
    end
    save([data_path '/' f{1} '/CNNfeatures.mat'], 'features');
    clear features;
    count_fold = count_fold+1;
end
cd(data_path)