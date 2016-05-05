%% singleFactorRepeatedMeasuresMixedCrossedEffects
% 
% Computes a single factor, mixed crossed effects, repeated measures GLMM
% considering topics as random factor (repeated measures/within-subject) 
% and systems as fixed factor.

%% Synopsis
%
%   [tbl, stats, soa, sfericity] = singleFactorRepeatedMeasuresMixedCrossedEffects(measures, list)
%  
% *Parameters*
%
% * *|measures|* - a set of measures. 
% * *|list|* - the list of systems to analyse. 
%
% *Returns*
%
% * *|tbl|*  - the ANOVA table corresponding to the computed GLMM; 
% * *|stats|* - a struct summarizing statistics about the computed GLMM;
% * *|soa|* - the strength of association for the systems effects.
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

function [tbl, stats, soa, sfericity] = singleFactorRepeatedMeasuresMixedCrossedEffects(measures, list)

    % check the number of input arguments
    narginchk(2, 2);
    
    % check that measures is a non-empty table
    validateattributes(measures, {'table'}, {'nonempty'}, '', 'measures', 1);
    
    % check that list is a non-empty cell array of strings
    validateattributes(list, {'cell'}, {'nonempty', 'vector'}, '', 'list', 1);
    assert(iscellstr(list), 'List expected to be a cell array of strings');
    
    % load common parameters
    common_parameters

    % select only the requested systems
    measures = measures(:, list);
    
    % if a maximum number of topics to be analysed is speficied, reduce the 
    % dataset to that number 
    if ~isempty(EXPERIMENT.analysis.maxTopic)
        measures = measures(1:EXPERIMENT.analysis.maxTopic, : );
    end;
    
    % get the labels of the topics
    topics = measures.Properties.RowNames;
    topics = topics(:).';
    m = length(topics);
    
    % get the labels of the systems
    systems = measures.Properties.VariableNames;
    systems = systems(:).';
    p = length(systems);
    
    % extract all the data as a row vector
    data = measures{:, :}(:);
    
    N = length(data);
    
    % define the grouping variables
    topics = repmat(topics, 1, p);
    systems = repmat(systems, m, 1);
    systems = reshape(systems, 1, m*p);

    % compute a 1-way ANOVA with repeated measures and mixed effects, 
    % considering topics as random effects and systems as fixed effects
    [~, tbl, stats] = anovan(data, {topics, systems}, 'Model', 'linear', ...
        'VarNames', {'Topics', 'Systems'}, ...
        'alpha', EXPERIMENT.analysis.alpha, 'display', 'off');
        
    df_systems = tbl{3, 3};
    ss_systems = tbl{3, 2};
    F_systems = tbl{3, 6};
    
    ss_error = tbl{4, 2};
    df_error = tbl{4, 3};
    
    ss_total = tbl{5, 2};
    
    % compute the strength of association
    soa.omega2 = df_systems * (F_systems - 1) / (df_systems * F_systems + df_error + 1);
    soa.omega2p = df_systems * (F_systems - 1) / (df_systems * (F_systems - 1) + N);
    
    soa.eta2 = ss_systems / ss_total;
    soa.eta2p = ss_systems / (ss_systems + ss_error);
    
    % compute the sfericity
    sfericity = vartestn(data, systems, 'TestType', 'OBrien', 'display','off');
            
end

