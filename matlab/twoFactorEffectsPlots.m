%% twoFactorEffectsPlots
% 
% 
% Computes a two factor, mixed effects, repeated measures GLMM
% considering topics as random factor and components and pipelines as fixed 
% factors.

%% Synopsis
%
%   [tbl, stats, omega2, sfericity] = twoFactorRepeatedMeasuresMixedCrossedEffects(measures, groups)
%  
% *Parameters*
%
% * *|measures|* - a set of measures. 
% * *|groups|* - the groups of systems according to a selected component. 
%
% *Returns*
%
% * *|tbl|*  - the ANOVA table corresponding to the computed GLMM; 
% * *|stats|* - a struct summarizing statistics about the computed GLMM;
% * *|omega2|* - the strength of association for the systems effect.
% * *|sfericity|* - the Levene's test for sfericity of the data.

%% References
% 
% * Doncaster, C. P. and Davey, A. J. H. (2007). _Analysis of Variance and Covariance. 
%   How to Choose and Construct Models for the Life Sciences_. Cambridge University Press, Cambridge, UK.
% * Maxwell, S. and Delaney, H. D. (2004). _Designing Experiments and Analyzing Data. 
%   A Model Comparison Perspective_. Lawrence Erlbaum Asso- ciates, Mahwah (NJ), USA, 2nd edition.
% * Rutherford, A. (2011). _ANOVA and ANCOVA. A GLMM Approach_. John Wiley & Sons, New York, USA, 2nd edition.

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

function [] = twoFactorEffectsPlots(measures, groups)

    % check that measures is a non-empty table
    validateattributes(measures, {'table'}, {'nonempty'}, '', 'measures', 1);
    
    % check that groups is a non-empty table
    validateattributes(groups, {'table'}, {'nonempty'}, '', 'groups', 1);

    % load common parameters
    common_parameters;
        
    % if a maximum number of topics to be analysed is speficied, reduce the 
    % dataset to that number 
    if ~isempty(EXPERIMENT.analysis.maxTopic)
        measures = measures(1:EXPERIMENT.analysis.maxTopic, : );
    end;
        
    % get the labels of the different factors
    components = groups.Properties.VariableNames;
    p = length(components);   % factor A (components/columns)
    
    pipelines = groups.Properties.RowNames;
    q = length(pipelines);  % factor B (pipelines/rows)

    % get the labels of the topics (subjects/cell contents)
    topics = measures.Properties.RowNames;
    topics = topics(:).';
    m = length(topics);
        
    % total number of elements
    N = m*p*q; 
    
    % preallocate vectors
    data = NaN(1, N);      % the data
    subject = cell(1, N);  % grouping variable for the subjects (topics)
    factorA = cell(1, N);  % grouping variable for factorA (groups.Properties.UserData.factorType)
    factorB = cell(1, N);  % grouping variable for factorB (pipelines)
    
    
    for i = 1:q % factorB (pipelines/rows) 
        for j = 1:p % factorA (components/columns)
            
            currentElement = (i-1)*p + j;
            range = (currentElement-1)*m+1:currentElement*m;
            
            % copy the measures in the correct range of the data
            data(range) = measures{:, groups{i, j}};
            
            % set the correct grouping variables
            subject(range) = topics;
            factorA(range) = components(j);
            factorB(range) = pipelines(i);
            
        end; % factorA
    end; % factorB
    
 %   maineffectsplot(data(:), {factorA, factorB}, ...
 %              'VarNames', {groups.Properties.UserData.componentName, 'Pipelines'});
           
    interactionplot(data(:), {factorA, factorB}, ...
        'VarNames', {groups.Properties.UserData.componentName, 'Pipelines'});  
    
end

