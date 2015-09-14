%% AOTATE
function anotatePrefiltering
addpath('../DataBase')
addpath('../Plot')
DataPath = 'C:\Users\Aniol\Copy\MCV\PFM\db\Petia1\Resized';
gtfile = 'C:\Users\Aniol\Copy\MCV\PFM\db\gt\keyframes_Petia1.txt';
images = dir([DataPath '/*.jpg']);

fid = fopen(gtfile, 'r');
A  = textscan(fid, '%s','Delimiter','\n');
fclose(fid);
for i = 1: size(A{1})
    [~,fname,~]=fileparts(A{1}{i});
    gt(i) = str2num(fname);
end


annotations = ones(numel(images), 1);
vecBlur = zeros(numel(images), 1);
vecDark = zeros(numel(images), 1);
disp('Click or press enter for NOISY images and move arrows to follow');
i=1;
while i < numel(images)
    im = imread([ DataPath '/' images(i).name]);
    [~,imname,~]=fileparts(images(i).name);
    
    
    if ~annotations(i)
        im =  addborder(im, 10, [0 0 255], 'inner');
    end
    
    if findgt(str2double(imname), gt)
        im =  addborder(im, 5, [0 255 0], 'inner');
    end
    im = double(im)/255;
    props = size(im);
    im2 = imresize(im, props(1:2));
    blur = mean(extractBlurriness(im2, 9, [9 9]));
    dark = mean(mean(mean(im2)));
    vecBlur(i) = blur;
    vecDark(i) = dark;
    fprintf('image %s - blur(%g), dark(%g)\n', imname, blur, dark)
    if findgt(str2double(imname), gt) && 1-dark>0.86
        imshow(im);
        title('Click or press enter for NOISY images and move arrows to follow')
        [~, ~,button] = ginput(1);
        if button == 28
            i = i-1;
        else
            if  isempty(button) || button == 1
                annotations(i) = ~annotations(i);
                fprintf('image %s state (%g)\n', imname,annotations(i));
            end
            i = i+1;
        end
    else
    i = i+1;
    end
end

save('anots.mat','annotations', 'vecBlur', 'vecDark');


end

function bool = findgt(elem , list)
for i = 1: numel(list)
    if (elem==list(i))
        bool = true;
        return;
    end
end
bool= false;
end

