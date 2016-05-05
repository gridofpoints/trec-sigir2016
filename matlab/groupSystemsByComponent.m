%% groupSystemsByComponent
% 
% Groups identifiers of systems by the selected component.

%% Synopsis
%
%   [groups] = groupSystemsByComponent(componentType)
%  
% *Parameters*
%
% * *|componentType|* - the type of the component which has to be used to 
% group systems. The following values can be used: _|stop|_ to group 
% systems by stop list; _|stem|_ to group systems by stemmer; _|grams|_ to 
% group systems by n-grams; _|lugall|_ to group systems by stemmer and 
% n-grams;_|model|_ to group systems by IR model.
% * *|lugType|* - the type of the lexical unit generator which has to be 
% used to group systems. It must be used only when |componentType| is either
% |stop| or |model|. The following values can be used:_|stem|_ consider 
% only systems which made use of stemmers; _|grams|_ to consider only
% systems which made use of n-grams; _|lugall|_ to consider systems which
% made use of either stemmers or n-grams.

%
% *Returns*
%
% * *|group|*  - a table containing the identifiers of systems grouped by 
% the selected component type. Colums are different kinds of the selected
% component type, e.g. different stop lists; rows a IR system pipelines
% using that component.

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

function [groups] = groupSystemsByComponent(componentType, lugType)

    % check the number of input arguments
    narginchk(1, 2);

    % load common parameters
    common_parameters;

    % check that componentType is a non-empty string
    validateattributes(componentType, ...
        {'char', 'cell'}, {'nonempty', 'vector'}, '', ...
        'componentType');
    
    % check that componentType assumes a valid value
    validatestring(componentType, ...
        EXPERIMENT.taxonomy.component.list, '', 'componentType');
    
    % remove useless white spaces, if any, and ensure it is a char row
    componentType = char(lower(strtrim(componentType)));
    componentType = componentType(:).';
    
    % the number of options for the selected component
    componentTypeSize = EXPERIMENT.taxonomy.(componentType).number;

    if strcmp(componentType, 'stop') || strcmp(componentType, 'model')
        % check the number of input arguments
        narginchk(2, 2);
        
        % check that lugType is a non-empty string
        validateattributes(lugType, ...
            {'char', 'cell'}, {'nonempty', 'vector'}, '', ...
            'lugType');
        
        % check that componentType assumes a valid value
        validatestring(lugType, ...
            EXPERIMENT.taxonomy.lug.list, '', 'lugType');
        
        % remove useless white spaces, if any, and ensure it is a char row
        lugType = char(lower(strtrim(lugType)));
        lugType = lugType(:).';
        
    end;
    
    switch componentType
        
        case 'stop'
            
            switch lugType
                
                case 'stem'
                    
                    subjects = EXPERIMENT.taxonomy.stem.number * EXPERIMENT.taxonomy.model.number;
                    currentSubject = 1;
                    
                    groups = cell(subjects, componentTypeSize);
                    groups = cell2table(groups);
                    groups.Properties.VariableNames = EXPERIMENT.taxonomy.stop.id;
                    groups.Properties.UserData.componentType = componentType;
                    groups.Properties.UserData.lugType = lugType;
                    
                    for stemIdx = 1:EXPERIMENT.taxonomy.stem.number
                        for modelIdx = 1:EXPERIMENT.taxonomy.model.number
                            
                            groups.Properties.RowNames{currentSubject} = createSystemName('stopPIPE', ...
                                EXPERIMENT.taxonomy.stem.id{stemIdx}, EXPERIMENT.taxonomy.model.id{modelIdx});
                            
                            for componentIdx = 1:componentTypeSize
                                
                                groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{componentIdx}, ...
                                    EXPERIMENT.taxonomy.stem.id{stemIdx}, EXPERIMENT.taxonomy.model.id{modelIdx})};
                                
                            end; % component
                            
                            currentSubject = currentSubject + 1;
                            
                        end; % model
                    end; % stem
                    
                case 'grams'
                    
                    subjects = EXPERIMENT.taxonomy.grams.number * EXPERIMENT.taxonomy.model.number;
                    currentSubject = 1;
                    
                    groups = cell(subjects, componentTypeSize);
                    groups = cell2table(groups);
                    groups.Properties.VariableNames = EXPERIMENT.taxonomy.stop.id;
                    groups.Properties.UserData.componentType = componentType;
                    groups.Properties.UserData.lugType = lugType;
                    
                    for stemIdx = 1:EXPERIMENT.taxonomy.grams.number
                        for modelIdx = 1:EXPERIMENT.taxonomy.model.number
                            
                            groups.Properties.RowNames{currentSubject} = createSystemName('stopPIPE', ...
                                EXPERIMENT.taxonomy.grams.id{stemIdx}, EXPERIMENT.taxonomy.model.id{modelIdx});
                            
                            for componentIdx = 1:componentTypeSize
                                
                                groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{componentIdx}, ...
                                    EXPERIMENT.taxonomy.grams.id{stemIdx}, EXPERIMENT.taxonomy.model.id{modelIdx})};
                                
                            end; % component
                            
                            currentSubject = currentSubject + 1;
                            
                        end; % model
                    end; % grams
                    
                case 'lugall'
                    
                    subjects = EXPERIMENT.taxonomy.lugall.number * EXPERIMENT.taxonomy.model.number;
                    currentSubject = 1;
                    
                    groups = cell(subjects, componentTypeSize);
                    groups = cell2table(groups);
                    groups.Properties.VariableNames = EXPERIMENT.taxonomy.stop.id;
                    groups.Properties.UserData.componentType = componentType;
                    groups.Properties.UserData.lugType = lugType;
                    
                    for stemIdx = 1:EXPERIMENT.taxonomy.lugall.number
                        for modelIdx = 1:EXPERIMENT.taxonomy.model.number
                            
                            groups.Properties.RowNames{currentSubject} = createSystemName('stopPIPE', ...
                                EXPERIMENT.taxonomy.lugall.id{stemIdx}, EXPERIMENT.taxonomy.model.id{modelIdx});
                            
                            for componentIdx = 1:componentTypeSize
                                
                                groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{componentIdx}, ...
                                    EXPERIMENT.taxonomy.lugall.id{stemIdx}, EXPERIMENT.taxonomy.model.id{modelIdx})};
                                
                            end; % component
                            
                            currentSubject = currentSubject + 1;
                            
                        end; % model
                    end; % lugall
                    
                otherwise
                    error('Unexpected lexical unit generator type');
            end;
                        
        case 'stem'
            
            subjects = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.model.number;
            currentSubject = 1;
            
            groups = cell(subjects, componentTypeSize);
            groups = cell2table(groups);
            
            % deal with matlab id names...
            for i = 1:EXPERIMENT.taxonomy.stem.number
                groups.Properties.VariableNames{i} = matlab.lang.makeValidName(EXPERIMENT.taxonomy.stem.id{i});
            end;
            
            groups.Properties.UserData.componentType = componentType;
            
            for stopIdx = 1:EXPERIMENT.taxonomy.stop.number
                for modelIdx = 1:EXPERIMENT.taxonomy.model.number
                    
                    groups.Properties.RowNames{currentSubject}  = createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                            'stemPIPE', EXPERIMENT.taxonomy.model.id{modelIdx});
                    
                    for componentIdx = 1:componentTypeSize
                        
                        groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                            EXPERIMENT.taxonomy.stem.id{componentIdx}, EXPERIMENT.taxonomy.model.id{modelIdx})};
                        
                    end; % component
                    
                    currentSubject = currentSubject + 1;
                    
                end; % model
            end; % stop
            
        case 'grams'
            
            subjects = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.model.number;
            currentSubject = 1;
            
            groups = cell(subjects, componentTypeSize);
            groups = cell2table(groups);
            
            % deal with matlab id names...
            for i = 1:EXPERIMENT.taxonomy.grams.number
                groups.Properties.VariableNames{i} = matlab.lang.makeValidName(EXPERIMENT.taxonomy.grams.id{i});
            end;
            
            groups.Properties.UserData.componentType = componentType;
            
            for stopIdx = 1:EXPERIMENT.taxonomy.stop.number
                for modelIdx = 1:EXPERIMENT.taxonomy.model.number
                    
                    groups.Properties.RowNames{currentSubject}  = createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                            'gramsPIPE', EXPERIMENT.taxonomy.model.id{modelIdx});
                    
                    for componentIdx = 1:componentTypeSize
                        
                        groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                            EXPERIMENT.taxonomy.grams.id{componentIdx}, EXPERIMENT.taxonomy.model.id{modelIdx})};
                        
                    end; % component
                    
                    currentSubject = currentSubject + 1;
                    
                end; % model
            end; % stop            

        case 'lugall'
            
            subjects = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.model.number;
            currentSubject = 1;
            
            groups = cell(subjects, componentTypeSize);
            groups = cell2table(groups);
            
            % deal with matlab id names...
            for i = 1:EXPERIMENT.taxonomy.grams.number
                groups.Properties.VariableNames{i} = matlab.lang.makeValidName(EXPERIMENT.taxonomy.lugall.id{i});
            end;
            
            groups.Properties.UserData.componentType = componentType;
            
            for stopIdx = 1:EXPERIMENT.taxonomy.stop.number
                for modelIdx = 1:EXPERIMENT.taxonomy.model.number
                    
                    groups.Properties.RowNames{currentSubject}  = createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                            'lugallPIPE', EXPERIMENT.taxonomy.model.id{modelIdx});
                    
                    for componentIdx = 1:componentTypeSize
                        
                        groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                            EXPERIMENT.taxonomy.lugall.id{componentIdx}, EXPERIMENT.taxonomy.model.id{modelIdx})};
                        
                    end; % component
                    
                    currentSubject = currentSubject + 1;
                    
                end; % model
            end; % stop       
            
        case 'model'
            
            switch lugType
                
                case 'stem'
                                        
                    subjects = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.stem.number;
                    currentSubject = 1;
                    
                    groups = cell(subjects, componentTypeSize);
                    groups = cell2table(groups);
                    groups.Properties.VariableNames = EXPERIMENT.taxonomy.model.id;
                    
                    groups.Properties.UserData.componentType = componentType;
                    groups.Properties.UserData.lugType = lugType;
                    
                    for stopIdx = 1:EXPERIMENT.taxonomy.stop.number
                        for stemIdx = 1:EXPERIMENT.taxonomy.stem.number
                            
                            groups.Properties.RowNames{currentSubject} = createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                                EXPERIMENT.taxonomy.stem.id{stemIdx}, 'modelPIPE');
                            
                            for componentIdx = 1:componentTypeSize
                                
                                groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                                    EXPERIMENT.taxonomy.stem.id{stemIdx}, EXPERIMENT.taxonomy.model.id{componentIdx})};
                                
                            end; % component
                            
                            currentSubject = currentSubject + 1;
                            
                        end; % stem
                    end; % stop
                    
                case 'grams'
                    
                    subjects = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.grams.number;
                    currentSubject = 1;
                    
                    groups = cell(subjects, componentTypeSize);
                    groups = cell2table(groups);
                    groups.Properties.VariableNames = EXPERIMENT.taxonomy.model.id;
                    
                    groups.Properties.UserData.componentType = componentType;
                    groups.Properties.UserData.lugType = lugType;
                    
                    for stopIdx = 1:EXPERIMENT.taxonomy.stop.number
                        for stemIdx = 1:EXPERIMENT.taxonomy.grams.number
                            
                            groups.Properties.RowNames{currentSubject} = createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                                EXPERIMENT.taxonomy.grams.id{stemIdx}, 'modelPIPE');
                            
                            for componentIdx = 1:componentTypeSize
                                
                                groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                                    EXPERIMENT.taxonomy.grams.id{stemIdx}, EXPERIMENT.taxonomy.model.id{componentIdx})};
                                
                            end; % component
                            
                            currentSubject = currentSubject + 1;
                            
                        end; % grams
                    end; % stop
                    
                case 'lugall'
                    
                    subjects = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.lugall.number;
                    currentSubject = 1;
                    
                    groups = cell(subjects, componentTypeSize);
                    groups = cell2table(groups);
                    groups.Properties.VariableNames = EXPERIMENT.taxonomy.model.id;
                    
                    groups.Properties.UserData.componentType = componentType;
                    groups.Properties.UserData.lugType = lugType;
                    
                    for stopIdx = 1:EXPERIMENT.taxonomy.stop.number
                        for stemIdx = 1:EXPERIMENT.taxonomy.lugall.number
                            
                            groups.Properties.RowNames{currentSubject} = createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                                EXPERIMENT.taxonomy.lugall.id{stemIdx}, 'modelPIPE');
                            
                            for componentIdx = 1:componentTypeSize
                                
                                groups{currentSubject, componentIdx} = {createSystemName(EXPERIMENT.taxonomy.stop.id{stopIdx}, ...
                                    EXPERIMENT.taxonomy.lugall.id{stemIdx}, EXPERIMENT.taxonomy.model.id{componentIdx})};
                                
                            end; % component
                            
                            currentSubject = currentSubject + 1;
                            
                        end; % lugall
                    end; % stop
                    
                otherwise
                    error('Unexpected lexical unit generator type');
            end;
            
            
        otherwise
            error('Unexpected component type');
    end;
    
end

