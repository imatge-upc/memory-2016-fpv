classdef ObjectCandidatesSorter < matlab.System
    
    % Jordi Pont-Tuset*, Pablo Arbelaez*, Jonathan T. Barron, Ferran Marques, Jitendra Malik
    % Multiscale Combinatorial Grouping for Image Segmentation and Object Proposal Generation
    % arXiv:1503.00848, March 2015
 
    properties (Access = private)
     
    end
    
    properties (Access = public)
        method;
        plt;
        numObj;
    end
    
    methods
        function obj = ObjectCandidatesSorter(params, plt)
            
            addpath(genpath('ObjectCandidates/mcg-2.0/pre-trained'));
            
            obj.method = params.method; % fast / accurate 
            obj.plt = params.plt;
            obj.numObj = params.numObj;
            
            if isfield(obj.plt, 'auxLog')
                obj.plt.auxLog = [plt.resultsFolder '/' sprintf(obj.plt.auxLog, params.method)];
            end
            
            
            
        end
        
        function sortedList = sort(self,event)
            for i = 1 : numel(event)
                % Detect objects
                image= event(i).getImage();
                [candidates_mcg, ~] = im2mcg(image,self.method); 
                
                %%%
                 if numel(candidates_mcg)>0
                    
                    % weight
                    if self.numObj ~= 0
                        sortedScores = sort (candidates_mcg.scores, 'descend');
                        event(i).weight = sum(sortedScores(1:self.numObj)); % Sum square confidences
                    else % All obects
                        event(i).weight = sum(candidates_mcg.scores);
                    end
                                        
                 else
                    event(i).weight = -inf;
                 end
                    
                 
                event(i).setAux(writeOnImageHandler(event(i), 'rectangle', candidates_mcg.bboxes(:,1:4), candidates_mcg.scores(1:5),  self.plt.imres, self.plt.textPos, sprintf('%g',  event(i).weight) ));
                
                auxInf = [sprintf('ev: %g \t| frame: %g \t|  candidates: %g \t| weight: %g \t|  10 scores: [', event(i).eventid, event(i).index, numel(sortedScores), event(i).weight)  sprintf('%g ', sortedScores(1:10)) sprintf('] \n')]; 
                
                if isfield(self.plt, 'debug')&& self.plt.debug
                   fprintf(auxInf);
                end
                if isfield(self.plt, 'auxLog')
                    fid = fopen(self.plt.auxLog,'a');
                    fprintf(fid, auxInf);
                    fclose(fid);
                end
            end
            
            % Sort images by weight
            [~,indexSortedList]=sort([event.weight], 'descend');
            sortedList = event(indexSortedList);
        end
    end
end