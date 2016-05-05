%% threeFactorInteractionEffectsPlot
% 
% Computes the interaction plots for a three factors, mixed effects, 
% repeated measures GLMM considering topics as random factor and system 
% components as fixed factors.

%% Synopsis
%
%   [] = threeFactorInteractionEffectsPlot(measures, measureShortName, trackID, list)
%  
% *Parameters*
%
% * *|measures|* - a set of measures. 
% * *|measureShortName|* - the name of the measure. 
% * *|trackID|* - the identifier of the track for which the processing is
% performed.
% * *|lugType|* - the type of the lexical unit generator which has to be 
% used to  list systems. The following values can be used: _|lugall|_ to 
% list all the systems; _|stem|_ to list only systems using stemmers;  
% _|grams|_ to list only systems using n-grams.
%
% *Returns*
%
% Nothing.

%% Information
% 
% * *Author*: <mailto:ferro@dei.unipd.it Nicola Ferro>
% * *Version*: 1.00
% * *Since*: 1.00
% * *Requirements*: Matlab 2015b or higher
% * *Copyright:* (C) 2016 <http://ims.dei.unipd.it/ Information 
% Management Systems> (IMS) research group, <http://www.dei.unipd.it/ 
% Department of Information Engineering> (DEI), <http://www.unipd.it/ 
% University of Padua>, Italy
% * *License:* <http://www.apache.org/licenses/LICENSE-2.0 Apache License, 
% Version 2.0>

%%
%{
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
      http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
%}

%%

function [] = threeFactorInteractionEffectsPlot(measures, measureShortName, trackID, lugType)

    % check the number of input parameters
    narginchk(4, 4);

    % load common parameters
    common_parameters


    % check that measures is a non-empty table
    validateattributes(measures, {'table'}, {'nonempty'}, '', 'measures', 1);
    
    % check that measureShortName is a non-empty string
    validateattributes(measureShortName,{'char', 'cell'}, {'nonempty', 'vector'}, '', 'measureShortName');
    
    if iscell(measureShortName)
        % check that measureShortName is a cell array of strings with one element
        assert(iscellstr(measureShortName) && numel(measureShortName) == 1, ...
            'MATTERS:IllegalArgument', 'Expected measureShortName to be a cell array of strings containing just one string.');
    end
    
    % remove useless white spaces, if any, and ensure it is a char row
    measureShortName = char(strtrim(measureShortName));
    measureShortName = measureShortName(:).';
    
    % check that trackID is a non-empty string
    validateattributes(trackID,{'char', 'cell'}, {'nonempty', 'vector'}, '', 'trackID');
    
    if iscell(trackID)
        % check that trackID is a cell array of strings with one element
        assert(iscellstr(trackID) && numel(trackID) == 1, ...
            'MATTERS:IllegalArgument', 'Expected trackID to be a cell array of strings containing just one string.');
    end
    
    % remove useless white spaces, if any, and ensure it is a char row
    trackID = char(strtrim(trackID));
    trackID = trackID(:).';
    
    % check that lugType is a non-empty string
    validateattributes(lugType, ...
        {'char', 'cell'}, {'nonempty', 'vector'}, '', ...
        'lugType');
    
    % check that lugType assumes a valid value
    validatestring(lugType, ...
        EXPERIMENT.taxonomy.lug.list, '', 'lugType');
    
    % remove useless white spaces, if any, and ensure it is a char row
    lugType = char(lower(strtrim(lugType)));
    lugType = lugType(:).';  
        
    % if a maximum number of topics to be analysed is speficied, reduce the 
    % dataset to that number 
    if ~isempty(EXPERIMENT.analysis.maxTopic)
        measures = measures(1:EXPERIMENT.analysis.maxTopic, : );
    end;
    
    
    % get the labels of the topics (subjects/cell contents)
    topics = measures.Properties.RowNames;
    topics = topics(:).';
    m = length(topics);

    switch lugType
        
        case 'lugall'
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number *  EXPERIMENT.taxonomy.lugall.number * EXPERIMENT.taxonomy.model.number * m;
                
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (lugall)
            factorC = cell(1, N);  % grouping variable for factorC (model)
    
            % the current element in the list
            currentElement = 1;
           
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for lugall = 1:EXPERIMENT.taxonomy.lugall.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        
                        range = (currentElement-1)*m+1:currentElement*m;
                        
                        % copy the measures in the correct range of the data
                        data(range) = measures{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                            EXPERIMENT.taxonomy.lugall.id{lugall}, EXPERIMENT.taxonomy.model.id{model})};
                        
                        % set the correct grouping variables
                        subject(range) = topics;
                        factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                        factorB(range) = EXPERIMENT.taxonomy.lugall.id(lugall);
                        factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                        
                        % increment the current element counter
                        currentElement = currentElement + 1;
                        
                    end; % model
                end; % stem
            end; % stop
            
        case 'stem'
            
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number *  EXPERIMENT.taxonomy.stem.number * EXPERIMENT.taxonomy.model.number * m;
                
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (stemmer)
            factorC = cell(1, N);  % grouping variable for factorC (model)
    
            % the current element in the list
            currentElement = 1;
           
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for stem = 1:EXPERIMENT.taxonomy.stem.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        
                        range = (currentElement-1)*m+1:currentElement*m;
                        
                        % copy the measures in the correct range of the data
                        data(range) = measures{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                            EXPERIMENT.taxonomy.stem.id{stem}, EXPERIMENT.taxonomy.model.id{model})};
                        
                        % set the correct grouping variables
                        subject(range) = topics;
                        factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                        factorB(range) = EXPERIMENT.taxonomy.stem.id(stem);
                        factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                        
                        % increment the current element counter
                        currentElement = currentElement + 1;
                        
                    end; % model
                end; % stem
            end; % stop
            
        case 'grams'
            % total number of elements in the list
            N = EXPERIMENT.taxonomy.stop.number *  EXPERIMENT.taxonomy.grams.number * EXPERIMENT.taxonomy.model.number * m;
                
            % preallocate vectors
            data = NaN(1, N);      % the data
            subject = cell(1, N);  % grouping variable for the subjects (topics)
            factorA = cell(1, N);  % grouping variable for factorA (stop list)
            factorB = cell(1, N);  % grouping variable for factorB (grams)
            factorC = cell(1, N);  % grouping variable for factorC (model)
    
            % the current element in the list
            currentElement = 1;
           
            for stop = 1:EXPERIMENT.taxonomy.stop.number % factorA
                for grams = 1:EXPERIMENT.taxonomy.grams.number % factorB
                    for model = 1:EXPERIMENT.taxonomy.model.number % factorC
                        
                        range = (currentElement-1)*m+1:currentElement*m;
                        
                        % copy the measures in the correct range of the data
                        data(range) = measures{:, createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                            EXPERIMENT.taxonomy.grams.id{grams}, EXPERIMENT.taxonomy.model.id{model})};
                        
                        % set the correct grouping variables
                        subject(range) = topics;
                        factorA(range) = EXPERIMENT.taxonomy.stop.id(stop);
                        factorB(range) = EXPERIMENT.taxonomy.grams.id(grams);
                        factorC(range) = EXPERIMENT.taxonomy.model.id(model);
                        
                        % increment the current element counter
                        currentElement = currentElement + 1;
                        
                    end; % model
                end; % stem
            end; % stop
            
        otherwise
            error('Unexpected component type');
    end; 
    
    data = data(:);
    subject = subject(:);
    factorA = factorA(:);
    factorB = factorB(:);
    factorC = factorC(:);                               
            
    currentFigure = figure('Visible', 'on');
    
        interactionplot(data, {factorA, factorB, factorC}, ...
            'VarNames', {EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugType).name, EXPERIMENT.taxonomy.model.name});
        
      %  title(sprintf('Interaction Effects between %s, %s, and %s for %s on collection %s', ...
      %      EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugType).name, EXPERIMENT.taxonomy.model.name, ...
      %      EXPERIMENT.measure.(measureShortName).fullName, EXPERIMENT.(trackID).name));

        %currentFigure.PaperPositionMode = 'manual';
        %currentFigure.PaperType = 'a0';
        %currentFigure.PaperOrientation = 'landscape';
        %currentFigure.PaperUnits = 'normalized';
        %currentFigure.PaperPosition = [0.05 0.05 0.9 0.9];

        %figureID = EXPERIMENT.pattern.identifier.figure.interactionEffects(measureShortName, lugType, trackID);

        %print(currentFigure, '-dpdf', EXPERIMENT.pattern.file.figure(trackID, figureID));

        %close(currentFigure)    
end

