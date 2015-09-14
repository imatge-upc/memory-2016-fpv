% better launch in gpu:
% srun-matlab --gres=gpu:1 -J VictorNet -l ~/logs/aff.mlog mainAffective > ~/logs/aff.log 2>&1 &
gpu = 1; % In case that there is not GPU, change the 1 to 0.

data_path = '../../db/Petia1/Resized';
outpath = '../../precomputed/Petia1/Affective/';
mkdir(outpath);
extractCNNFeatures(data_path,outpath, gpu); 
load([outpath '/Affectivefeatures.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Affectivefeatures_n.mat'], 'features');
fprintf('done!');
