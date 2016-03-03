%% Script that create a .txt with the images name

cd('targets');

files_list_targets=dir();
files_list_targets=files_list_targets(arrayfun(@(x) x.name(1) ~='.', files_list_targets));

cd('../fillers');
files_list_fillers=dir();
files_list_fillers=files_list_fillers(arrayfun(@(x) x.name(1)~='.', files_list_fillers));

cd('../');

fid=fopen('targets.txt','w');
for ii=1:length(files_list_targets)
    fprintf(fid, [files_list_targets(ii).name '\n']);
end
fclose(fid);

fid=fopen('fillers.txt','w');
for jj=1:length(files_list_fillers)
    fprintf(fid, [files_list_fillers(jj).name '\n']);
end
fclose(fid);

%%
cd('targets_resize');

files_list_targets=dir();
files_list_targets=files_list_targets(arrayfun(@(x) x.name(1) ~='.', files_list_targets));

cd('../fillers_resize');
files_list_fillers=dir();
files_list_fillers=files_list_fillers(arrayfun(@(x) x.name(1)~='.', files_list_fillers));

cd('../');

fid=fopen('targets_resize.txt','w');
for ii=1:length(files_list_targets)
    fprintf(fid, [files_list_targets(ii).name '\n']);
end
fclose(fid);

fid=fopen('fillers_resize.txt','w');
for jj=1:length(files_list_fillers)
    fprintf(fid, [files_list_fillers(jj).name '\n']);
end
fclose(fid);


