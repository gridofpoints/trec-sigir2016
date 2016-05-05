%% twoFactorRepeatedMeasuresMixedCrossedEffects
% 
% 
% Computes a two factor, mixed effects, repeated measures GLMM
% considering topics as random factor (repeated measures/within-subject)
% and components and pipelines as fixed factors.

%% Synopsis
%
%   [tbl, stats, soa, sfericity] = twoFactorRepeatedMeasuresMixedCrossedEffects(measures, groups)
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
% * *|soa|* - the strength of association for the different effects.
% * *|sfericity|* - the O'Brien's test for sfericity of the data.

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

function [tbl, stats, soa, sfericity] = twoFactorRepeatedMeasuresMixedCrossedEffects(measures, groups)

    % check the number of input arguments
    narginchk(2, 2);

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
    factorA = cell(1, N);  % grouping variable for factorA (groups.Properties.UserData.componentType)
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
    
    % model components = Topics + FactorA + FactorB + FactorA*FactorB
    m = [1 0 0; ...
         0 1 0; ...
         0 0 1; ...
         0 1 1];
    
    % compute a 2-way ANOVA with repeated measures and mixed effects, 
    % considering topics as random effects and components and pipelines as fixed effects
    [~, tbl, stats] = anovan(data, {subject, factorA, factorB}, 'Model', m, ...
        'VarNames', {'Topics', EXPERIMENT.taxonomy.(groups.Properties.UserData.componentType).name, 'Pipelines'}, ...
        'alpha', EXPERIMENT.analysis.alpha, 'display', 'off');
        
    df_components = tbl{3,3};
    ss_components = tbl{3,2};
    F_components = tbl{3,6};
    
    df_pipelines = tbl{4,3};
    ss_pipelines = tbl{4,2};
    F_pipelines = tbl{4,6};
    
    df_components_pipelines = tbl{5,3};
    ss_components_pipelines = tbl{5,2};
    F_components_pipelines = tbl{5,6};
    
    df_error = tbl{6, 3};
    ss_error = tbl{6, 2};

    ss_total = tbl{7, 2};
        
    % compute the strength of association
    soa.omega2.components = df_components * (F_components - 1) / (df_components * F_components + df_pipelines * F_pipelines + + df_components_pipelines * F_components_pipelines + df_error + 1);
    soa.omega2.pipelines = df_pipelines * (F_pipelines - 1) / (df_components * F_components + df_pipelines * F_pipelines + + df_components_pipelines * F_components_pipelines + df_error + 1);
    soa.omega2.components_pipelines = df_components_pipelines * (F_components_pipelines - 1) / (df_components * F_components + df_pipelines * F_pipelines + + df_components_pipelines * F_components_pipelines + df_error + 1);
    
    soa.omega2p.components = df_components * (F_components - 1) / (df_components * (F_components - 1) + N);
    soa.omega2p.pipelines = df_pipelines * (F_pipelines - 1) / (df_pipelines * (F_pipelines - 1) + N);
    soa.omega2p.components_pipelines = df_components_pipelines * (F_components_pipelines - 1) / (df_components_pipelines * (F_components_pipelines - 1) + N);
    
    
    soa.eta2.components = ss_components/ ss_total;
    soa.eta2.pipelines = ss_pipelines / ss_total;
    soa.eta2.components_pipelines = ss_components_pipelines / ss_total;
    
    soa.eta2p.components = ss_components/ (ss_components + ss_error);
    soa.eta2p.pipelines = ss_pipelines / (ss_pipelines + ss_error);
    soa.eta2p.components_pipelines = ss_components_pipelines / (ss_components_pipelines + ss_error);

    % compute the sfericity
    sfericity.components = vartestn(data(:), factorA, 'TestType', 'OBrien', 'display','off');
    sfericity.pipelines = vartestn(data(:), factorB, 'TestType', 'OBrien', 'display','off');
 

end

