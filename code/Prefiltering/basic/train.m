
DataPath = 'C:\Users\Aniol\Copy\MCV\PFM\db\Petia1\Resized';
images = dir([DataPath '/*.jpg']);
load('anots.mat')


 bac = 0;  bl =0; w =0; br =0;
 best_w = 0; best_bl = 0; best_br = 0;
% for w = 0.5:0.001:1
%     for bl = 0:0.001:1
        for br = 0:0.01:1
            ac = evaluate(vecBlur, vecDark,  annotations, w,bl,br);
            if ac>bac
                bac =ac;
                best_w = w;
                best_bl = bl;
                best_br = br;
            end
        end
%     end
% end

 best_w 
 best_bl
 best_br

  F1 = evaluate(vecBlur, vecDark, annotations, best_w, best_bl, best_br)



