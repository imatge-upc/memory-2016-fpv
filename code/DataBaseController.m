classdef DataBaseController < matlab.System
    
    properties (Access=private)
        indexDs = 1;
        actualDataSet;
    end
    
    properties
        dataSetParameters;
        datasets;
    end
    
    methods
        function obj = DataBaseController(params)
            addpath(genpath('DataBase'))
            obj.dataSetParameters = params;
            obj.datasets = params.datasets;
        end
        
        function bool = dataSetsEnd(self)
            bool = self.indexDs > numel(self.datasets);
        end
        
        function dataset = getDataSet(self)
            params           = self.dataSetParameters;
            params.path      = strrep(params.path, '$DSETNAME', self.datasets{self.indexDs});
            params.gtPath    = strrep(params.gtPath, '$DSETNAME', self.datasets{self.indexDs});
            params.gtSegFile = strrep(params.gtSegFile, '$DSETNAME', self.datasets{self.indexDs});
            params.gtRelFile = strrep(params.gtRelFile, '$DSETNAME', self.datasets{self.indexDs});
            params.name      = self.datasets{self.indexDs};
            
            dataset = DataSetController(params);
            self.actualDataSet = self.datasets{self.indexDs};
            self.indexDs = self.indexDs+1;
            fprintf('############################### DATASET: %s ################################## \n',self.actualDataSet);
            
            
        end
        
        function [mthdpp, dspp, pfpp] = reinitialize(self, plt, mthdp, dsp, pfp)
            plt.updateDataSet(self.actualDataSet);
            mthdpp = mthdp;
            mthdpp.objectsLSDA.FeatsPath = strrep(mthdpp.objectsLSDA.FeatsPath, '$DSETNAME', self.actualDataSet);
            mthdpp.affective.FeatsPath = strrep(mthdpp.affective.FeatsPath, '$DSETNAME', self.actualDataSet);
			mthdpp.saliency.deepPath = strrep(mthdpp.saliency.deepPath, '$DSETNAME', self.actualDataSet);
            mthdpp.faces.loadSavePath = strrep(mthdpp.faces.loadSavePath, '$DSETNAME', self.actualDataSet);
            dspp = dsp;
            dspp.FeatsPath = strrep(dspp.FeatsPath, '$DSETNAME', self.actualDataSet);
            dspp.preComputePath = strrep(dspp.preComputePath, '$DSETNAME', self.actualDataSet);
			pfpp = pfp;
			pfpp.deepPath  = strrep(pfpp.deepPath, '$DSETNAME', self.actualDataSet);
            
        end
        
        
    end
    
    
   
end