
function features=extractCNNFeatures(path,outpath,gpu)
%This function uses the ConvolutionalNN provided by Caffe to extract features for the given set of images.
%Input:
%   path: string containing the path of the images set to analize.
%Output:
%   features: matrix containing the features vectors of the images of the
%   specific path.
path = [pwd '/' path];
size_features = 1183;


%% Go through each folder

images = dir(strcat(path,'/*.jpg'));
features = zeros(length(images), size_features);
%% For each image in this folder
count_im = 1;

names = {images(:).name};

nImages = length(images);
for k = 1:nImages
    im = names{k};
    im = imread(strcat(path,'/',im));
    [scores, ~] = matcaffe_demo(im, gpu);
    features(k, :) = scores';
    % Count progress
    if(mod(count_im, 50) == 0 || count_im == nImages)
        disp(['Processed ' num2str(count_im) '/' num2str(nImages) ' images.']);
    end
    count_im = count_im +1;
end

save([outpath '/Places7features.mat'], 'features');
end
