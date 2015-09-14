classdef RandomSorter < matlab.System
    
    properties
    end
    
    properties(Access=public)
        method;
    end
    
    methods
        function obj = RandomSorter(met)
            if nargin<1
               obj.method = 'random';
            else
                obj.method = met;
            end
        end
        
        function sortedList = sort(self,event, gt)
            nE = length(event);
            switch self.method
                case 'skip'
                    sortedList = event;
                case 'random'
                    indexSortedList = randperm(nE);
                    sortedList = event(indexSortedList);
                case 'uniformsampling'
                    ngt = numel(gt);
                    m=nE/ngt;
                    indexSortedList = zeros(1,nE);
                    indexSortedList(round(m*(1:ngt))) = 1;
                    indexSortedList = logical(indexSortedList);
                    sortedList = event(indexSortedList);
                case 'groundtruth'
                    sortedListGT = [];
                    sortedListOTHER = [];
                    for i = 1 : nE
                        if self.find(event(i).index, gt)
                            sortedListGT = [sortedListGT event(i)];
                        else
                            sortedListOTHER = [sortedListOTHER event(i)];
                        end
                    end
                    sortedList = [sortedListGT sortedListOTHER];
                otherwise
                    
                    error('Method in random incorrect');
            end
            
        end
        
        % FIND GT
        function bool = find(~, elem , list)
            for i = 1: numel(list)
                if (elem==list(i))
                    bool = true;
                    return;
                end
            end
            bool= false;
        end
    end
end