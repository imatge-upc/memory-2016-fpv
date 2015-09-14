classdef EvaluationController < matlab.System
    %Minimitzation ALGRITHM.
    properties (Access = private)
        sumEvents = 0;
        matNSMS;
        countEvents = 0;
    end
    properties(Access=public)
        doPrec;
        doNSMS;
        plt;
        name;
        nbins;
    end
    
    methods
        function obj = EvaluationController(params, name)
            
            addpath('Plot');
            addpath('Evaluation');
            
            obj.doPrec = ~isfield(params, 'doPrec') || params.doPrec;
            obj.doNSMS =  ~isfield(params, 'doNSMS') || params.doNSMS;
            obj.plt = params.plt;
            obj.name = name;
            obj.matNSMS = [];
            obj.nbins = params.nbins;
        end
        
        function [nsms, avPrec, prec] = evaluate(self,sortedList, gtevent, ds)
            
            sortedListIndex = [sortedList.index];
            N  = numel(sortedList);
            prec = zeros(N,1);
            rel = zeros( N, 1);
            sms = zeros(N,1);
            
            if self.doPrec
                % PRECISION
                for i = 1 : N
                    % Check if is in gt
                    rel(i) = self.find(sortedListIndex(i),gtevent);
                    % Compute precision @k
                    prec(i) = sum(rel(1:i))/i;
                end
                avPrec = sum(prec .* rel)/numel(gtevent);
                
                if (self.plt.dispPrec)
                    fprintf('%s > Precision at... \n', self.name);
                    fprintf('\t at %d: %g \t', [1:length(prec); prec']);
                    fprintf('\n');
                end;
                if (self.plt.dispAvPrec)
                    fprintf('%s > Average Precision: %g \n',self.name, avPrec);
                end
                self.sumEvents = self.sumEvents + avPrec;
            end
            
            if self.doNSMS
                dsMat = ds.distanceMatrix(sortedList, gtevent);
                % DIVERSITY
                for k = 1 : N
                    % compute hungarian.
                    sms(k) = maxCompute(dsMat(1:k,:));
                end
                
                % Normalitzation
                sms  = sms / numel(gtevent); % in Y axes
                nsms = sample(sms,self.nbins); % in X axes: NRP normalized rank position
                self.matNSMS(:, self.countEvents+1) = nsms;
                AUC = trapz(nsms)/self.nbins;
                
                if (self.plt.dispNSMS)
                    fprintf('%s > NSMS at ... \n', self.name);
                    fprintf('\t at %d: %g \t', [1:length(nsms); nsms']);
                    fprintf('\n');
                end;
                
                if (self.plt.plotNSMS)
                    figure;
                    %                   plot(sms), title(sprintf('%s > SMS (before normalitzation): Event %g', self.name, self.countEvents));
                    figure;  plot(nsms), title(sprintf('%s > NSMS: Event %g (AUC=%g)', self.name, self.countEvents,AUC));  % NSMS = normalized sum of max similarities
                    xlabel('Index k');
                    ylabel('NSMS');
                    %
                    %                    figure;
                    
                end
                
                if (self.plt.dispAUCNSMS)
                    fprintf('%s > NSMS AUC: %g \n',self.name, AUC);
                end;
            end
            % count events
            self.countEvents = self.countEvents + 1;
        end
        
        function AUC = getAUC(self)
            mNSMS = mean(self.matNSMS,2);
            AUC = trapz(mNSMS)/self.nbins;
        end
        
        function plot(self, plt)
            if self.doPrec
                %Precision
                precstr = sprintf('%s > Mean Average Precision %g \n', self.name, self.sumEvents/self.countEvents);
                fprintf(precstr);
                if nargin > 1
                    plt.writeResults(precstr);
                end
            end
            
            if self.doNSMS
                %Diversty
                mNSMS = mean(self.matNSMS,2);
                AUC = trapz(mNSMS)/self.nbins;
                nsms_str = sprintf('%s > Mean NSMS (AUC=%g) \n', self.name, AUC);
                fprintf([nsms_str '\n']);
                
                
                if isfield(self.plt, 'holdon') && self.plt.holdon
                    hold all;
                else
                    figure;
                end
                
                if ~isfield(self.plt, 'plotMeanNSMS') || ~self.plt.plotMeanNSMS                    
                    plot((1:self.nbins)/self.nbins, mNSMS, 'DisplayName', sprintf('%s (AUC=%g)', self.name, AUC));
                    axis ([0 1 0 1])
                    
                    if isfield(self.plt, 'holdon') && self.plt.holdon
                        title('All > Mean NSMS');
                    else
                        title(nsms_str);
                    end
                    
                    xlabel('Bins (%k)');
                    ylabel('NSMS');
                end
                
                if nargin > 1
                    plt.writeResults(nsms_str, mNSMS, self.name);
                end
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
        
        
    end
end