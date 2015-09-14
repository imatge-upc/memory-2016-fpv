% better launch in gpu:
% srun-matlab --gres=gpu:1 -J Saliency -l ~/logs/sal.mlog mainSaliency > ~/logs/sal.log 2>&1 &
gpu = 1; % In case that there is not GPU, change the 1 to 0.

data_path = '../../../db/Petia1/Resized';
outpath = '../../../precomputed/Petia1/saliency2/';
mkdir(outpath);
extractCNNFeatures(data_path,outpath, gpu); 
load([outpath '/Saliencyfeatures.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Saliencyfeatures_n.mat'], 'features');
fprintf('done!');
