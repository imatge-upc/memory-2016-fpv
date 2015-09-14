% better launch in gpu:
% srun-matlab --gres=gpu:1 -w c6 -J BolanosNet -l ~/logs/pref.mlog mainPrefiltering > ~/logs/pref.log 2>&1 &
gpu = 1; % In case that there is not GPU, change the 1 to 0.

datasets = {'Mariella', 'Marc1', 'Estefania1', 'MAngeles1', 'MAngeles2', 'Petia1', 'Petia2'};

for i = 1:  numel(datasets)
	data_path = ['../../../db/' datasets{i} '/Resized'];
	outpath = ['../../../precomputed/' datasets{i} '/Prefiltering/'];
	mkdir(outpath);
	features = extractCNNFeatures(data_path,outpath, gpu); 
	[features]=extractNF(data_path,features);
	save([outpath '/prefiltering_n.mat'], 'features');
	fprintf('done!');
end
