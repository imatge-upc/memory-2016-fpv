% better launch in gpu:
% srun-matlab --gres=gpu:1 -J deepmemory -l ~/logs/cnn.mlog mainPlaces > ~/logs/cnn.log 2>&1 &
gpu = 1; % In case that there is not GPU, change the 1 to 0.

data_path = '../../../db/Petia1/Resized';
outpath = '../../../precomputed/Petia1/Places7';
mkdir(outpath);
extractPlacesfeatures(data_path,outpath, gpu); 
load([outpath '/Places7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Places7features_n.mat'], 'features');
fprintf('done!');

%%%%%

data_path = '../../../db/Petia2/Resized';
outpath = '../../../precomputed/Petia2/Places7';
mkdir(outpath);
extractPlacesfeatures(data_path,outpath, gpu); 
load([outpath '/Places7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Places7features_n.mat'], 'features');
fprintf('done!');


data_path = '../../../db/Estefania1/Resized';
outpath = '../../../precomputed/Estefania1/Places7';
mkdir(outpath);
extractPlacesfeatures(data_path,outpath, gpu); 
load([outpath '/Places7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Places7features_n.mat'], 'features');
fprintf('done!');


data_path = '../../../db/Estefania2/Resized';
outpath = '../../../precomputed/Estefania2/Places7';
mkdir(outpath);
extractPlacesfeatures(data_path,outpath, gpu); 
load([outpath '/Places7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Places7features_n.mat'], 'features');
fprintf('done!');


data_path = '../../../db/MAngeles1/Resized';
outpath = '../../../precomputed/MAngeles1/Places7';
mkdir(outpath);
extractPlacesfeatures(data_path,outpath, gpu); 
load([outpath '/Places7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Places7features_n.mat'], 'features');
fprintf('done!');


data_path = '../../../db/MAngeles2/Resized';
outpath = '../../../precomputed/MAngeles2/Places7';
mkdir(outpath);
extractPlacesfeatures(data_path,outpath, gpu); 
load([outpath '/Places7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Places7features_n.mat'], 'features');
fprintf('done!');


data_path = '../../../db/Mariella/Resized';
outpath = '../../../precomputed/Mariella/Places7';
mkdir(outpath);
extractPlacesfeatures(data_path,outpath, gpu); 
load([outpath '/Places7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Places7features_n.mat'], 'features');
fprintf('done!');

data_path = '../../../db/Marc1/Resized';
outpath = '../../../precomputed/Marc1/Places7';
mkdir(outpath);
extractPlacesfeatures(data_path,outpath, gpu); 
load([outpath '/Places7features.mat']);
[features]=extractNF(data_path,features);
save([outpath '/Places7features_n.mat'], 'features');
fprintf('done!');
