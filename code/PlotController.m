classdef PlotController < matlab.System
    
    properties(Access=private)
        dsname;
        dsetResultsFolder;
        mets;
    end
    properties(Access=public)
        skipPlot = false;
        mosaic;
        resultsFolder;
        hasDiary=false;
    end
    
    methods
        function obj = PlotController(pltp, mets)
            addpath('Plot');
            obj.mosaic = pltp.mosaic;
            if ~isfield(pltp, 'expName') || strcmp(pltp.expName,'')
                c = clock;
                pltp.expName = sprintf('%d%.2d%0d_%.2d%.2d',c(1:3),c(4:5));
            end
            obj.resultsFolder = [pltp.resultsFolder '/' pltp.expName];
            mkdir(obj.resultsFolder);
            
            if isfield(pltp, 'skipPlot')
                obj.skipPlot = pltp.skipPlot;
            end
            if isfield(pltp, 'logfile')
                logfile = [obj.resultsFolder '/' pltp.logfile];
                diary(logfile);
                obj.hasDiary = true;
            end
            
            obj.mets = mets;
            obj.emptyFile([obj.resultsFolder '/results.txt']);
        end
        
        function updateDataSet(self, dsname)
            self.dsname = dsname;
            self.dsetResultsFolder = [self.resultsFolder '/' dsname];
            
            mkdir([self.dsetResultsFolder '/fusion/']);
            mkdir([self.dsetResultsFolder '/event/']);
            
            for m = 1 : numel(self.mets)
                mkdir([self.dsetResultsFolder '/' self.mets{m} '/a']);
                if ~hascv
                    mkdir ([self.dsetResultsFolder '/' self.mets{m} '/a/afiles']);
                end
            end
            
        end
        
        function write(self, sortedList, index, method, gtevent, retail)
            if ~self.skipPlot
                if nargin<5
                    self.eventWritter(sortedList, sprintf('%s/%02g_%s.jpg', method, index, method), 'image');
                elseif nargin<6
                    self.eventWritter(sortedList, sprintf('%s/%02g_%s.jpg', method, index, method), 'image', gtevent);
                    if ~strcmp(method,'random') && ~strcmp(method,'fusion'),
                        % self.eventWritter(sortedList, sprintf('%s/a/%02g_%s.jpg', method, index, ['aux_' method]), 'aux', gtevent);
                    end
                else
                    self.eventWritter(sortedList, sprintf('%s/%02g_%s.jpg', method, index, method), 'image', gtevent, numel(gtevent));
                end
            end
        end
        
        function saveParameters(self, dbp,pltp,evp,pfp,dsp,dvp,mthdp, methods, distances )
            A = evalc('methods');
            A = [A evalc('distances')];
            A = [A evalc('fn_structdisp(dbp)')];
            A = [A evalc('fn_structdisp(pltp)')];
            A = [A evalc('fn_structdisp(evp)')];
            A = [A evalc('fn_structdisp(pfp)')];
            A = [A evalc('fn_structdisp(dsp)')];
            A = [A evalc('fn_structdisp(dvp)')];
            A = [A evalc('fn_structdisp(mthdp)')];
            
            fid = fopen([self.resultsFolder '/parameters.txt'] ,'w');
            fprintf(fid,'%s',A);
            fclose(fid);
            
        end
        
        function writeResults(self, text, div, method)
            fid = fopen([self.resultsFolder '/results.txt'],'a');
            fprintf(fid,'%s',text);
            if nargin>2
                save(sprintf('%s/reNSMS_%s.mat',self.resultsFolder,method),'div');
            end
            fclose(fid);
        end
        
        function close(self)
            legend(gca,'show', 'Location','southeast')
            if self.hasDiary
                diary off;
            end
        end
    end
    
    methods (Access=private)
        function bool = find(~, elem , list)
            for i = 1: numel(list)
                if (elem==list(i))
                    bool = true;
                    return;
                end
            end
            bool= false;
        end
        
        function emptyFile(~,file)
            fclose(fopen(file,'w'));
        end
        
        function eventWritter(self, event, fname, chan, eventgt, max)
            
            if nargin < 6
                max = numel(event);
                noborder = false;
            else
                noborder = true;
                event = event(1:max);
                [~, ind]=sort([event.index]);
                event = event(ind);
            end
            
            if  nargin < 4 || strcmp(chan, 'image') || noborder
                for i = 1 : max
                    image = addborder(imresize(event(i).getImage(),1/2),1,[255 255 255],'inner');
%                     image = addborder(event(i).getImage(),1,[255 255 255],'inner');
                    if nargin > 4 && self.find(event(i).index, eventgt) && ~noborder % groundtruth
                        border = floor((event(i).info.Width + event(i).info.Height)/200*self.mosaic.border);
                        if event(i).skiped 
                            color = self.mosaic.gtskColor;
                        else
                            color = self.mosaic.gtColor;
                        end
                        list{i} =  addborder(image, border, color, 'inner');
                    elseif ~isempty(event(i).skiped) && ~noborder
                        border = floor((event(i).info.Width + event(i).info.Height)/200*self.mosaic.border);
                        list{i} =  addborder(image, border, self.mosaic.skColor, 'inner');
                    else
                        list{i} =  image;
                    end
                end
                
                outImg=concatImages2Dhor('inImgCell',list, 'subVcols', self.mosaic.cols);
                imwrite( outImg, [self.dsetResultsFolder '/' fname]);
                
            elseif (strcmp(chan, 'aux'))
                if hascv % write auxiliar with CV toolbox
                    for i = 1 : numel(event)
                        if nargin > 4 && self.find(event(i).index, eventgt) % groundtruth
                            border = floor((event(i).auxinfo.Width + event(i).auxinfo.Height)/200*self.mosaic.border);
                            list{i} =  addborder(event(i).getAux(), border, self.mosaic.gtColor, 'inner');
                        else
                            list{i} =  event(i).getAux();
                        end
                    end
                    
                    outImg=concatImages2Dhor('inImgCell',list, 'subVcols', self.mosaic.cols);
                    imwrite( outImg, [self.dsetResultsFolder '/' fname]);
                else
                    for i = 1 : numel(event)
                        
                        if nargin > 4 && self.find(event(i).index, eventgt) % groundtruth
                            event(i).setAuxGT();
                        end
                        list{i} =  event(i).getAux();
                    end
                    
                    [pathstr,name,~] = fileparts(fname);
                    save([self.dsetResultsFolder '/' pathstr '/afiles/' name '.mat'], 'list');
                    
                end
            else
                error('Channel(chan) must be image or aux');
            end
            
        end
    end
end