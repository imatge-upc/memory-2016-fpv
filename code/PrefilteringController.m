classdef PrefilteringController < matlab.System
    
    properties
    end
    
    properties(Access=public)
        resizeTests;
        thresholdBlur;
        thresholdDark;
        thresholdBright;
        deepthresh;
        deepFeats;
        method;
    end
    
    methods
        function obj = PrefilteringController(params)
            addpath('Prefiltering/basic');
            addpath('Prefiltering/deep');
            obj.method =  params.method; %'skip', 'basic', 'deep';
            if strcmp(obj.method, 'basic')
                obj.resizeTests  = params.resizeTests;
                obj.thresholdBlur = params.thresholdBlur;
                obj.thresholdDark = 1- params.thresholdDark;
                obj.thresholdBright = params.thresholdBright;
            elseif strcmp(obj.method, 'deep')
                obj.deepthresh = params.deepthresh;
                T = load([params.deepPath '/' params.deepFile]);
                obj.deepFeats = T.features;
            end
        end
        
        function [skipEvents, selectedEvents] = filter(self,event)
            if strcmp(self.method, 'basic')
                skip = zeros(numel(event),1);
                for i = 1 : numel(event)
                    im = event(i).getDoubleImage();
                    props = size(im) / self.resizeTests;
                    im2 = imresize(im, props(1:2));
                    
                    % Check blurriness
                    blur = mean(extractBlurriness(im2, 9, [9 9]));
                    % Check darkness
                    dark = mean(mean(mean(im2)));
                    if(blur > self.thresholdBlur || dark < self.thresholdDark || dark > self.thresholdBright)
                        disp([num2str(i+1) ' > ' num2str(event(i).index) '  blur:' num2str(blur) ' dark:' num2str(1-dark)]);
                        %figure; imshow(im);
                        skip(i) = 1;
                        event(i).setSkip;
                        %                     else
                        %                         disp([num2str(i+1) ' > ' num2str(event(i).index) '  blur:' num2str(blur) ' dark:' num2str(1-dark)]);
                    end
                end
                
                skipEvents = self.put(event, skip);
                selectedEvents = self.put(event, ~skip);
                
            elseif strcmp(self.method, 'deep')
                skip = zeros(numel(event),1);
                for i = 1 : numel(event)
                    ife = self.deepFeats(:,1) == event(i).index;
                    ni =  self.deepFeats(ife,2); % Probability of non-inforative
                    if(ni >= self.deepthresh)
                        disp([num2str(i+1) ' > ' num2str(event(i).index) '  informative:' num2str(1-ni) ]);
                        skip(i) = 1;
                        event(i).setSkip;
                        %                     else
                        %                         disp([num2str(i+1) ' > ' num2str(event(i).index) '  informative:' num2str(1-ni) ]);
                    end
                end
                
                skipEvents = self.put(event, skip);
                selectedEvents = self.put(event, ~skip);
                
            else
                skipEvents = [];
                selectedEvents = event;
            end
        end
        
        function out = put(~, in , index)
            
            if sum(index)>0
                out = in(logical(index));
            else
                out = [];
            end
        end
        
    end
end