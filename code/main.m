% function main()
% srun-matlab -J deepmemory -l ~/logs/main.mlog main > ~/logs/main.log 2>&1 &
%% Parameters
%dbp.datasets =                  {'Marc1'};                      % Datasets of database
dbp.datasets =                  {'MAngeles1', 'MAngeles2', 'Petia1', 'Petia2','Mariella', 'Marc1', 'Estefania1'};
%dbp.datasets =                  {'Petia2', 'Petia1',  'MAngeles2', 'MAngeles1', 'Estefania1' };
dbp.path =                      '../db/$DSETNAME/Resized';                 % Path of datasets << Allows $DSETNAME >>
dbp.gtPath =                    '../db/gt';                                % Groundtruth path of database
dbp.gtSegFile =                 'GT_$DSETNAME.xls';                        % Relative to GTPATH, file xls with segmentation groundtruth << Allows $DSETNAME >>
dbp.gtRelFile =                 'keyframes_$DSETNAME.txt';                 % Relative to GTPATH, file txt with relevant frames << Allows $DSETNAME >>
dbp.imgFormat =                 'jpg';                                     % Extention of images. jpg | png
dbp.getGTimages =               false;                                     % false will return a Frame with Frame.image=0; | default: true;
dbp.dispEvent =                 true;                                      % Display Event process
% dbp.startEvent =              1;                                         % Index of start event, Coment to automatic (1)
% dbp.endEvent =                10;                                        % Index of end event, Coment or 0 to automatic.

pltp.skipPlot =                 false;                                     % Skip writting results
pltp.resultsFolder =            '../results';                              % Results folder
pltp.expName =                  'B-Saliency_gauss';                           % Experiment name, empty for date
pltp.logfile =                  'log.log';                                 % Log File
pltp.mosaic.border =            5;                                         % Border of GT images in mosaic
pltp.mosaic.gtColor =           [0 255 0];                                 % Color of GT border in mosaic
pltp.mosaic.skColor =           [0 0 255];                                 % Color of Skiped border in mosaic
pltp.mosaic.gtskColor =         [0 255 255];                               % Color of GT and Skiped border in mosaic
pltp.mosaic.cols =              8;

%evp.doPrec =                   true;                                      % Compte Precision
%evp.doNSMS =                   true;                                      % Compute NSMS
evp.plt.dispAvPrec =            true;                                      % Display Average Precision for event
evp.plt.dispPrec =              false;                                     % Display Precision at each k in event
evp.plt.plotNSMS =              false;                                     % Plot NSMS graphs for event
evp.plt.dispNSMS =              false;                                     % Display NSMS at each k in event
evp.plt.dispAUCNSMS =           true;                                      % Display NSMS AUC for event
evp.plt.plotMeanNSMS =          false;
evp.plt.holdon =                true;
evp.nbins =                     100;                                       % Number of bins in x axes normalitzation.
evp.simFeatures =               'ImageNet';                                  % Features used in Similarity [ pixel | CN7 | LSDA ]

pfp.method =                    'skip';                                    % Prefiltering Method [basic | deep | skip];
pfp.resizeTests =               1;                                         % Basic. Resize factor
pfp.thresholdBlur =             0.47;                                      % Basic. Threshold of blurriness
pfp.thresholdDark =             0.86;                                      % Basic. Threshold for darkness
pfp.thresholdBright =           0.6;                                       % Basic. Threshold for brightness
pfp.deepthresh = 				0.999;									   % Deep. Threshold for informativeness
pfp.deepPath = 					'../precomputed2/$DSETNAME/Prefiltering/';     % Deep. Path for informativeness features
pfp.deepFile = 					'prefiltering_n.mat';				   % Deep. File for informativeness features

dsp.loadSaveCompute =           1;                                         % Precompute distance matrices, [ 1 | 2 | 3 ] Load, Save, Compute
dsp.FeatsPath =                 '../precomputed2/$DSETNAME/%s/';            % Path of features {except Feature = pixel} << Allows $DSETNAME >>
dsp.FeatsFile =                 '%sfeatures_n.mat';                        % Filename of features {except Feature = pixel}
dsp.preComputePath =            '';                                        % Path to load/save Distances Matrix. Commented or empty will use FeatsPath. << Allows $DSETNAME >>


methods =                       {'saliency'};                   % Cell of methods {'method1','method2',...}
                                                                           % random | groundtruth | uniformsapling | skip | saliency | faces | objects | affective

fsp.method =                    'pondsum rank';                           % Method used in fusion [ random | first | sum | pondsum  {score | rank}]
fsp.pondArray =                 [1];                                 % Ponderation for each method {method = pondsum [..]}

distances =                     {'pixel'};                              % Cell of distances {'distance1', 'distance2', ...}
                                                                           % pixel, ImageNet, LSDA, Places

dvp.method =                    'skip';                                     % Method used when applying diversity [RSD | RSDF | skip]
dvp.pondArray =                 [1];                                       % Ponderation for each distance {method = RSDF}
dvp.maxSelected =               false;                                     % Perform max on already selected (true).

mthdp.random.parameter =        '';                                        % Not used

mthdp.saliency.method = 		'deep';									   % [deep , basic]
mthdp.saliency.gauss =          true;                                     % Mutiply saliency map by a centered Gaussian
mthdp.saliency.sigma =          10;                                        % Sigma of centered Gaussian. Only if saliency.gauss is true
mthdp.saliency.colorChannels =  'LAB';                                     % Saliency colorspace
mthdp.saliency.blurSigma =      .045;                                      % Saliency blur sigma
mthdp.saliency.mapWidth =       64;                                        % Saliency map widith
mthdp.saliency.resizeToInput =  1;                                         % Saliency resize to input
mthdp.saliency.subtractMin =    1;                                         % Saliency substract min
mthdp.saliency.deepPath = 		'../precomputed2/$DSETNAME/saliency/';


mthdp.faces.plt.debug =         true;                                      % Display faces steps
mthdp.faces.plt.textPos =       [10,10];                                   % Place to display text in auxiliar mosaic
mthdp.faces.plt.imres =         1/2;                                       % Image resize factor in auxiliar mosaicS
mthdp.faces.plt.auxLog =        'faces_%s_auxiliar.log';                   % Auxiliar faces log
mthdp.faces.model =             'model1';                                  % Pre-trained faces model [model1 | model2 | model3]
mthdp.faces.thresh =            -1;                                        % Threshold SVM
mthdp.faces.loadSaveCompute =   2;
mthdp.faces.loadSavePath =      '../precomputed2/$DSETNAME/faces/';

mthdp.objects.method =          'fast';                                    % Object Candidates method [fast | accurate] (UCM, MCG respectivelly)
mthdp.objects.plt.auxLog =      'objects_%s_auxiliar.log';                 % Auxiliar objects log
mthdp.objects.plt.debug =        true;                                     % Display Objects steps
mthdp.objects.plt.textPos =      [10,10];                                  % Place to display text in auxiliar mosaic
mthdp.objects.plt.imres =        1/2;                                      % Image resize factor in auxiliar mosaic
mthdp.objects.numObj =           5;                                        % Number of objecs taken. 0 will take all objects

mthdp.objectsLSDA.numObj =       0;                                        % Number of objecs taken. 0 will take all objects
mthdp.objectsLSDA.FeatsPath =    '../precomputed2/$DSETNAME/LSDAf1/';       % Path of features {except Feature = pixel} << Allows $DSETNAME >>
mthdp.objectsLSDA.FeatsFile =    'LSDAf1features_n.mat';                   % Filename of features {except Feature = pixel}

mthdp.affective.FeatsPath =    '../precomputed2/$DSETNAME/Affective/';      % Path of features {except Feature = pixel} << Allows $DSETNAME >>
mthdp.affective.FeatsFile =    'Affectivefeatures_n.mat';                  % Filename of features {except Feature = pixel}
mthdp.affective.method =        'positive';                                % Method used for weighting [positive | negative |extrem]

%% INITIALITZATION

% INITIALIZE DATABASE, PLOTS & EVALUATION
db = DataBaseController(dbp);
plt = PlotController(pltp, methods);
ev = EvaluationController(evp, 'fusion');   %Final evaluation (fusion)
mev = cell(numel(methods), 1);
for m = 1: numel(methods)
    mev{m} = EvaluationController(evp, methods{m});    
end
plt.saveParameters(dbp,pltp,evp,pfp,dsp,dvp,mthdp,methods, distances);

% LOOP DATASETS
while(~db.dataSetsEnd())
    dset = db.getDataSet();
    [mthdpp, dspp, pfpp] = db.reinitialize(plt, mthdp, dsp, pfp);
    
    % INITIALIZE METHODS AND DISTANCES FOR METHODS
    dse = Distance(evp.simFeatures, dspp);
	pf = PrefilteringController(pfpp);
    mthd = cell(numel(methods), 1);
    dsts = cell(numel(distances), 1);

    % METHODS
    for m = 1: numel(methods)

        switch methods{m}
            case 'random'
                mthd{m} = RandomSorter();
            case 'uniformsampling'
                mthd{m} = RandomSorter('uniformsampling');
            case 'groundtruth'
                mthd{m} = RandomSorter('groundtruth');
            case 'skip'
                mthd{m} = RandomSorter('skip');
            case 'saliency'
				mthdpp.saliency.method = 		'deep';
                mthd{m} = SaliencySorter(mthdpp.saliency);
            case 'saliency2'
				mthdpp.saliency.method = 		'basic';
                mthd{m} = SaliencySorter(mthdpp.saliency);
            case 'faces'
                mthd{m} = FacesSorter(mthdpp.faces, plt);
            case 'objects'
                mthd{m} = ObjectCandidatesSorter(mthdpp.objects, plt);
            case 'objectsLSDA'
                mthd{m} = ObjectCandidatesSorterLSDA(mthdpp.objectsLSDA);
            case 'affective'
                mthd{m} = AffectiveSorter(mthdpp.affective);
            otherwise
                error('Method incorrect');
        end;
        
    end
    
    % DISTANCES
    for d = 1: numel(distances)
        
        switch distances{d}
            case 'pixel'
                dsts{d} = Distance('pixel', dspp);
            case 'ImageNet'
                dsts{d} = Distance('ImageNet', dspp);
            case 'LSDA'
                dsts{d} = Distance('LSDAf1', dspp);
            case 'Places'
                dsts{d} = Distance('Places7', dspp);
            otherwise
                error('Distance incorrect');
        end;
        
    end
    % INITIALIZE FUSION & DIVERSITY
    fs = FusionController(fsp,methods);
    dv = DiversityController(dvp, dsts);
    
    %% LOOP EVENTS
    while (~dset.eventsEnd())
        
        % GET FRAMES AND GROUNDTRUTH
        [fevent, gtevent] = dset.event();
        
        % PREFILTERING
        [sevent, event] = pf.filter(fevent);
        
        if ~isempty(event)
            % LOOP METHODS
            for m = 1: numel(methods)

                % COMPUTE SORTED LIST
%                 sortedList = mthd{m}.sort(event,gtevent); %uniform sampling
                sortedList = mthd{m}.sort(event); %others

                % MERGE
                fullSortedList = [sortedList, sevent];

                % EVALUATE METHOD IN EVENT
                mev{m}.evaluate(fullSortedList, gtevent, dse);

                % PLOT METHOD RESULTS LIST IN EVENT
                plt.write(fullSortedList, dset.eventIndex(), methods{m}, gtevent)

                % ADD EVENT TO FUSION
                fs.add(sortedList);

            end;

            % FUSION METHODS
            sortedList = fs.fusion();

            % ADD DIVERSITY
            sortedList = dv.diverse(sortedList);

            % MERGE
            fullSortedList = [sortedList, sevent];

        else
            fullSortedList = sevent;
        end
            
        % EVALUATE EVENT FUSION
        ev.evaluate(fullSortedList, gtevent, dse);
        
        % PLOT EVENT
        plt.write(fevent, dset.eventIndex(), 'event')
        %plt.write(fullSortedList, dset.eventIndex(), 'fusion', gtevent)
        plt.write(fullSortedList, dset.eventIndex(), 'fusion', gtevent, 'retail')
    end
end
figure;
% Display partial evaluations
for m = 1: numel(methods)
    mev{m}.plot(plt);
end

% Learn Weigths based on AUC and Display
learnWeights(mev, methods);

% Display final evaluation
ev.plot(plt);

plt.close();