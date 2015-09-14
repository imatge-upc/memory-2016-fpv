% better launch in gpu:
% srun-matlab --gres=gpu:1 -J deepmemory -l ~/logs/cnn.mlog mainCNN > ~/logs/cnn.log 2>&1 &
gpu = 0; % In case that there is not GPU, change the 1 to 0.

data_path = '../../../db/MAngeles1/Resized';
outpath = '../../../precomputed/MAngeles1/sim';
mkdir(outpath);
extractCNNFeatures(data_path,outpath, gpu); 
load([outpath '/CN7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/CN7features_n.mat'], 'features');
fprintf('done!');

data_path = '../../../db/MAngeles2/Resized';
outpath = '../../../precomputed/MAngeles2/sim';
mkdir(outpath);
extractCNNFeatures(data_path,outpath, gpu); 
load([outpath '/CN7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/CN7features_n.mat'], 'features');
fprintf('done!');

data_path = '../../../db/MAngeles3/Resized';
outpath = '../../../precomputed/MAngeles3/sim';
mkdir(outpath);
extractCNNFeatures(data_path,outpath, gpu); 
load([outpath '/CN7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/CN7features_n.mat'], 'features');
fprintf('done!');
