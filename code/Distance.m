classdef Distance < matlab.System
    
    properties(Access=public)
        feature;
    end
    properties(Access=private)
        disMat;
        iDisMat;
        loadSaveCompute;
        
    end
    
    methods(Access = public)
        function obj = Distance(feature, params)
            obj.loadSaveCompute = params.loadSaveCompute;
            obj.feature = feature;
            
            if ~isfield(params, 'preComputePath') || isempty(params.preComputePath)
                params.preComputePath = params.FeatsPath;
            end
            
            params.FeatsPath = sprintf(params.FeatsPath, feature);
            params.preComputePath = sprintf(params.preComputePath, feature);
            params.FeatsFile = sprintf(params.FeatsFile, feature);
            
            if  ~strcmp(feature, 'pixel')&& obj.loadSaveCompute ~=1
                T = load([params.FeatsPath '/' params.FeatsFile]);
                obj.ALLDistanceMatContruct(T.features);
            end
            
            if ~strcmp(feature, 'pixel') && obj.loadSaveCompute == 2 % Save
                mkdir(params.preComputePath);
                disMat = obj.disMat;
                iDisMat = obj.iDisMat;
                save([params.preComputePath '/' feature '.mat'],'disMat', 'iDisMat');
            elseif ~strcmp(feature, 'pixel') && obj.loadSaveCompute == 1 %load
                try
                load([params.preComputePath '/' feature '.mat']);
                catch
                    error('Unable to read file %s. Make sure that loadSaveCompute=2 if the file is not created yet', [params.preComputePath '/' feature '.mat']);
                end
                obj.disMat = disMat;
                obj.iDisMat = iDisMat;
            end
        end
        
        function DM = distanceMatrix(self, list, gt)
            % Compute distance matrix list vs gt(indexes) in event
            [~,igt] = intersect([list.index], gt);
            DM = zeros(numel(list), numel(gt));
            for l = 1 : numel(list)
                for g = 1: numel(gt)
                    DM(l,g) = self.distance(list(igt(g)), list(l));
                end
            end
        end
        
        function cost = distance(self, f1, f2)
            if strcmp(self.feature, 'pixel')
                im1= f1.getImage();
                im2= f2.getImage();
                [sr,sc] = size(im1);
                cost = 1 - sum(sum(sum(abs(double(im1-im2)/255)))/(sr*sc))/3;
            else
                if1 = self.iDisMat == f1.index;
                if2 = self.iDisMat == f2.index;
                cost = self.disMat(if1,if2);
            end
            
        end
        
    end
    
    methods(Access = private)
        
        function ALLDistanceMatContruct(self, features)
            % Compute distances between all db images.
            fprintf('%s > Computing big similarity matrix...', self.feature);
            mx = 0;
            sf = size(features,1);
            SM = zeros(sf,sf);
            for i = 1 : sf
                for j = 1 : sf
                    err = norm(features(i,2:end)-features(j,2:end));
                    if err>mx
                        mx =err;
                    end
                    SM(i,j) = err;
                end
            end
            self.disMat = 1- SM / mx;
            self.iDisMat = features(:,1);
        end
    end
end