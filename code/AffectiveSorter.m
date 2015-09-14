classdef AffectiveSorter < matlab.System
    
    
    properties (Access = private)
        feats;
        method;
    end
    
    
    methods
        function obj = AffectiveSorter(params)
            T = load([params.FeatsPath '/' params.FeatsFile]);
            obj.feats = T.features;
            obj.method = params.method;
        end
        
        function sortedList = sort(self,event)
            for i = 1 : numel(event)
                ife = self.feats(:,1) == event(i).index;
                fe =  self.feats(ife,3); % Taking positive classe (because negative is complementary)
                if strcmp(self.method,'positive')
                    event(i).weight = fe;
                elseif strcmp(self.method,'negative')
                    event(i).weight = 1-fe; 
                elseif strcmp(self.method,'extreme')
                    event(i).weight = abs(fe-0.5)*2; % Converting 0.5 as worse 1 or 0 as best (considering very negative or very positive as relevant)
                else
                    error('method incorrrect');
                end
            end
            
            % Sort images by weight
            [~,indexSortedList]=sort([event.weight], 'descend');
            sortedList = event(indexSortedList);
        end
    end
end