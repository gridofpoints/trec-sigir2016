%% listSystems
% 
% Creates a list of system identifiers which do not use query expansion.

%% Synopsis
%
%   [list] = listSystems(lugType)
%
% *Parameters*
%
% * *|lugType|* - the type of the lexical unit generator which has to be 
% used to  list systems. The following values can be used: _|lugall|_ to 
% list all the systems; _|stem|_ to list only systems using stemmers;  
% _|grams|_ to list only systems using n-grams.
%  
% *Returns*
%
% * *|list|*  - a string cell array containing the list of the identifiers 
% of all the systems under experimentation.

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

function [list] = listSystems(lugType)

    % check the number of input arguments
    narginchk(1, 1);
    
    % load common parameters
    common_parameters;
           
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
    
    switch lugType
        
        case 'lugall'
            % total number of elements in the list
            els = EXPERIMENT.taxonomy.stop.number *  EXPERIMENT.taxonomy.lugall.number * EXPERIMENT.taxonomy.model.number;
            
            % the list of systems
            list = cell(1, els);
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number
                for lugall = 1:EXPERIMENT.taxonomy.lugall.number
                    for model = 1:EXPERIMENT.taxonomy.model.number
                        
                        list{1, currentElement} = createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                            EXPERIMENT.taxonomy.lugall.id{lugall}, EXPERIMENT.taxonomy.model.id{model});
                        
                        currentElement = currentElement + 1;
                        
                    end; % model
                end; % lexical units
            end; % stop
            
        case 'stem'
            % total number of elements in the list
            els = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.stem.number * EXPERIMENT.taxonomy.model.number;
            
            % the list of systems
            list = cell(1, els);
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number
                for stem = 1:EXPERIMENT.taxonomy.stem.number
                    for model = 1:EXPERIMENT.taxonomy.model.number
                        
                        list{1, currentElement} = createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                            EXPERIMENT.taxonomy.stem.id{stem}, EXPERIMENT.taxonomy.model.id{model});
                        
                        currentElement = currentElement + 1;
                        
                    end; % model
                end; % stem
            end; % stop
            
        case 'grams'
            % total number of elements in the list
            els = EXPERIMENT.taxonomy.stop.number * EXPERIMENT.taxonomy.grams.number * EXPERIMENT.taxonomy.model.number;
            
            % the list of systems
            list = cell(1, els);
            
            % the current element in the list
            currentElement = 1;
            
            for stop = 1:EXPERIMENT.taxonomy.stop.number
                for grams = 1:EXPERIMENT.taxonomy.grams.number
                    for model = 1:EXPERIMENT.taxonomy.model.number
                        
                        list{1, currentElement} = createSystemName(EXPERIMENT.taxonomy.stop.id{stop}, ...
                            EXPERIMENT.taxonomy.grams.id{grams}, EXPERIMENT.taxonomy.model.id{model});
                        
                        currentElement = currentElement + 1;
                        
                    end; % model
                end; % grams
            end; % stop
            
        otherwise
            error('Unexpected component type');
    end;
    
        
end

