function [scores, layers] = matcaffe_demo(im, use_gpu)
% scores = matcaffe_demo(im, use_gpu)
%
% Demo of the matlab wrapper using the ILSVRC network.
%
% input
%   im       color image as uint8 HxWx3
%   use_gpu  1 to use the GPU, 0 to use the CPU
%
% output
%   scores   1000-dimensional ILSVRC score vector
%
% You may need to do the following before you start matlab:
%  $ export LD_LIBRARY_PATH=/opt/intel/mkl/lib/intel64:/usr/local/cuda-5.5/lib64
%  $ export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
% Or the equivalent based on where things are installed on your system
%
% Usage:
%  im = imread('../../examples/images/cat.jpg');
%  scores = matcaffe_demo(im, 1);
%  [score, class] = max(scores);

% init caffe network (spews logging info)
  caffe_path = '/usr/local/opt/caffe/matlab/caffe/';
  wd = pwd;
  cd (caffe_path);
  
if caffe('is_initialized') == 0
% model_def_file = '/usr/local/opt/caffe/examples/imagenet/imagenet_deploy.prototxt';
% model_def_file = '/imatge/alidon/work/PFM/src/Affective/VictorNet/5_agree/deploy.prototxt';
  model_def_file = '/mnt/imatge-work/alidon/PFM/src/Saliency/deep/deploy.prototxt';
% model_file = '/imatge/alidon/work/PFM/src/Affective/VictorNet/5_agree/twitter_finetuned_5-agree_iter_216.caffemodel';
  model_file =  '/mnt/imatge-work/alidon/PFM/src/Saliency/deep/model.caffemodel';
  if exist(model_file, 'file') == 0
    % NOTE: you'll have to get the pre-trained ILSVRC network
    error('You need a network model file');
  end

  
  caffe('init', model_def_file, model_file);
end

% set to use GPU or CPU
if exist('use_gpu', 'var') && use_gpu
  caffe('set_mode_gpu');
else
  caffe('set_mode_cpu');
end

% put into test mode
caffe('set_phase_test');

% prepare oversampled input
%tic;
input_data = {prepare_image(im)};
%toc;

% do forward pass to get scores
%tic;
scores = caffe('forward', input_data);
%toc;

%%%%%%%%%%% EDITED %%%%%%%%%%%%%%%%%%%%%
% average output scores
%scores = reshape(scores{1}, [1000 10]);
%scores = mean(scores, 2);

% average output scores

%save('/imatge/alidon/work/PFM/src/Affective/prova.mat', 'scores');
scores = reshape(scores{1}, [2 10]);
scores = mean(scores, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% you can also get network weights by calling
layers = caffe('get_weights');

cd(wd);
% ------------------------------------------------------------------------
function images = prepare_image(im)
% ------------------------------------------------------------------------
d = load('ilsvrc_2012_mean');
IMAGE_MEAN = d.image_mean;
IMAGE_DIM = 256;
CROPPED_DIM_X = 240;
CROPPED_DIM_Y = 320;

% resize to fixed input size
im = single(im);
im = imresize(im, [IMAGE_DIM IMAGE_DIM], 'bilinear');
% permute from RGB to BGR (IMAGE_MEAN is already BGR)
im = im(:,:,[3 2 1]) - IMAGE_MEAN;

% oversample (4 corners, center, and their x-axis flips)
images = zeros(CROPPED_DIM_X, CROPPED_DIM_Y, 3, 10, 'single');
indices_x = [0 IMAGE_DIM-CROPPED_DIM_X] + 1;
indices_y = [0 IMAGE_DIM-CROPPED_DIM_Y] + 1;
curr = 1;
for i = indices_x
  for j = indices_y
    images(:, :, :, curr) = ...
        permute(im(i:i+CROPPED_DIM_X-1, j:j+CROPPED_DIM_Y-1, :), [2 1 3]);
    images(:, :, :, curr+5) = images(end:-1:1, :, :, curr);
    curr = curr + 1;
  end
end
center_x = floor(indices_x(2) / 2)+1;
center_y = floor(indices_y(2) / 2)+1;
images(:,:,:,5) = ...
    permute(im(center_x:center_x+CROPPED_DIM_X-1,center_y:center_y+CROPPED_DIM_Y-1,:), ...
        [2 1 3]);
images(:,:,:,10) = images(end:-1:1, :, :, curr);
