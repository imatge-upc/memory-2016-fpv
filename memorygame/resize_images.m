%% Script that resize all the set

cd('targets');
files=dir();
files=files(arrayfun(@(x) x.name(1)~='.', files));

mkdir('../targets_resize');

for mm=1:length(files)
    img=imread(files(mm).name);
    img=imresize(img, [400 400]);
    %name=regexp(files(mm).name, '\.', 'split');
    imwrite(img, ['../targets_resize/' files(mm).name], 'quality', 50);
end

%%
cd('../');
cd('fillers');
files=dir();
files=files(arrayfun(@(x) x.name(1)~='.', files));

mkdir('../fillers_resize');

for mm=1:length(files)
    img=imread(files(mm).name);
    img=imresize(img, [400 400]);
    %name=regexp(files(mm).name, '\.', 'split');
    imwrite(img, ['../fillers_resize/' files(mm).name], 'quality', 50);
end
