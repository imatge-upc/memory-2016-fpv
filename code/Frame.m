classdef Frame < handle
 
    properties(Access=private)
        imagePath;
        aux;
    end
    properties(Access=public)
        index;
        indexInEvent;
        weight = -1;
        info;
        auxinfo;
        eventid;
        skiped;
    end
    
    methods
        function obj = Frame(path, file, ext, eventid, indexInEvent)
            if nargin<4 
                eventid = -1;
                indexInEvent = -1;
            end
            obj.index = file;
            obj.indexInEvent = indexInEvent;
            obj.imagePath= [path '/' sprintf('%06g', file) '.' ext];
            obj.info = imfinfo(obj.imagePath);
            obj.auxinfo.Height = 0;
            obj.auxinfo.Width =0 ;
            obj.eventid = eventid;
        end
        function image = getImage(self)
            image = imread(self.imagePath);
        end
        
        
        function image = getDoubleImage(self)
            image = double(imread(self.imagePath))/255;
        end
        
        function image = getAux(self)
            if isa(self.aux, 'writeOnImageHandler') && hascv
                image = self.aux.compute();
            else
                image = self.aux;
            end
        end
        
        function setAux(self, image)
            self.aux = image;
            if ~isa(image, 'writeOnImageHandler')
                self.auxinfo.Width = size(image,2);
                self.auxinfo.Height = size(image,1);
            else
                 self.auxinfo.Width = self.info.Width*image.props.scaleRes;
                 self.auxinfo.Height = self.info.Height*image.props.scaleRes;
            end
        end
        function setAuxGT(self)
           self.aux.setGT(); 
        end;
        
        function setSkip(self)
           self.skiped = true; 
        end;
        
        
    end
end