classdef ObjectCandidatesSorterLSDA < matlab.System
    
    
    properties (Access = private)
        lsdaFeats;
        numObj;
    end
    
    
    methods
        function obj = ObjectCandidatesSorterLSDA(params)
            T = load([params.FeatsPath '/' params.FeatsFile]);
            obj.lsdaFeats = T.features;
            
            obj.numObj = params.numObj;
        end
        
        function sortedList = sort(self,event)
            for i = 1 : numel(event)
                ife = self.lsdaFeats(:,1) == event(i).index;
                fe =  self.lsdaFeats(ife,2:end);
                if self.numObj ~= 0
                    [sfe,~] = sort(fe, 'descend');
                    event(i).weight = sum(sfe(1:self.numObj));
                else
                    fe = fe(fe>0);
                    event(i).weight = sum(fe);
                end
            end
            
            % Sort images by weight
            [~,indexSortedList]=sort([event.weight], 'descend');
            sortedList = event(indexSortedList);
        end
    end
end