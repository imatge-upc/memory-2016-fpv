% srun-matlab -w c6 --gres=gpu:1 -m 40000 -J lsda -l ~/logs/lsda.mlog mainLSDA > ~/logs/lsda.log 2>&1 &    


data_path = '../../../db/Petia1/Resized';
outpath = '../../../precomputed/Petia1/LSDAf1';
mkdir(outpath);
extractLSDAFeatures(data_path,outpath, 'filter'); 
load([outpath '/LSDAfeatures.mat']);
[features]=extractNF(data_path,features);
save([outpath '/LSDAfeatures_n.mat'], 'features');
fprintf('done!');
