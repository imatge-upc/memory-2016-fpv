%MAinPrefiltering2
addpath('Test_Informative_Detector');

data_path = '../../../db/Petia1/Resized/';
outpath = '../../../precomputed/Petia1/Prefiltering/';
loadParameters;
files = dir([data_path '*.jpg']);
images = prepare_batch2([files.name]);
output = applyInfoCNN( images, InfoCNN_params);
[features]=extractNF(data_path,output);
save([outpath '/prefiltering_n.mat'], 'features');
fprintf('done!');
