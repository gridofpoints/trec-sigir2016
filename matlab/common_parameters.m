%% common_parameters
% 
% Sets up parameters common to the different scripts.
%
%% Information
% 
% * *Author*: <mailto:ferro@dei.unipd.it Nicola Ferro>
% * *Version*: 1.00
% * *Since*: 1.00
% * *Requirements*: MATTERS 1.0 or higher; Matlab 2015b or higher
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

diary off;

%% General configuration

% if we are running on the cluster 
if (strcmpi(computer, 'GLNXA64'))
    addpath('/nas1/promise/ims/ferro/matters/base/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/analysis/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/io/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/measure/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/plot/')
    addpath('/nas1/promise/ims/ferro/matters/base/core/util/')
end;

% The base path
if (strcmpi(computer, 'GLNXA64'))
    % if we are running on the cluster 
    EXPERIMENT.path.base = '/nas1/promise/ims/ferro/SIGIR2016-FS/experiment/';
else
    EXPERIMENT.path.base = '/Users/ferro/Documents/pubblicazioni/2016/SIGIR/FS/experiment/';
end;

% The path for logs
EXPERIMENT.path.log = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'log', filesep);

% The path for measures
EXPERIMENT.path.measure = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'measure', filesep);

% The path for analyses
EXPERIMENT.path.analysis = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'analysis', filesep);

% The path for figures
EXPERIMENT.path.figure = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'figure', filesep);

% The path for reports
EXPERIMENT.path.report = sprintf('%1$s%2$s%3$s', EXPERIMENT.path.base, 'report', filesep);

% Label of the paper this experiment is for
EXPERIMENT.label.paper = 'SIGIR 2016 FS';


%% Overall Experiment Taxonomy
EXPERIMENT.taxonomy.component.list = {'stop', 'lugall', 'stem', 'grams', 'model'};
EXPERIMENT.taxonomy.component.number = length(EXPERIMENT.taxonomy.component.list);

EXPERIMENT.taxonomy.lug.list = {'lugall', 'stem', 'grams'};
EXPERIMENT.taxonomy.lug.number = length(EXPERIMENT.taxonomy.lug.list);

EXPERIMENT.taxonomy.stop.id = {'nostop', 'indri', 'lucene', 'smart', 'terrier'};
EXPERIMENT.taxonomy.stop.name = 'Stop Lists';
EXPERIMENT.taxonomy.stop.number = length(EXPERIMENT.taxonomy.stop.id);

EXPERIMENT.taxonomy.grams.id = {'nostem', '4grams', '5grams'};
EXPERIMENT.taxonomy.grams.name = 'n-grams';
EXPERIMENT.taxonomy.grams.number = length(EXPERIMENT.taxonomy.grams.id);

EXPERIMENT.taxonomy.stem.id = {'nostem', 'wkporter', 'porter', 'krovetz', 'lovins'};
EXPERIMENT.taxonomy.stem.name = 'Stemmers';
EXPERIMENT.taxonomy.stem.number = length(EXPERIMENT.taxonomy.stem.id);

EXPERIMENT.taxonomy.lugall.id = {'nostem', 'wkporter', 'porter', 'krovetz', 'lovins', '4grams', '5grams'};
EXPERIMENT.taxonomy.lugall.name = 'Stemmers and n-grams';
EXPERIMENT.taxonomy.lugall.number = length(EXPERIMENT.taxonomy.lugall.id);

EXPERIMENT.taxonomy.model.id = {'BB2', 'BM25', 'DFRBM25', 'DFRee', 'DLH', 'DLH13', 'DPH', 'HiemstraLM', 'IFB2', 'InL2', ...
    'InexpB2', 'InexpC2', 'LGD', 'LemurTFIDF', 'PL2', 'TFIDF'};
EXPERIMENT.taxonomy.model.name = 'IR Models';
EXPERIMENT.taxonomy.model.number = length(EXPERIMENT.taxonomy.model.id);


%% Configuration for collections 

% TREC 05, 1996, Adhoc
EXPERIMENT.AH_MONO_EN_TREC1996.id = 'AH_MONO_EN_TREC1996';
EXPERIMENT.AH_MONO_EN_TREC1996.name =  'TREC 05, 1996, Adhoc';

% TREC 06, 1997, Adhoc
EXPERIMENT.AH_MONO_EN_TREC1997.id = 'AH_MONO_EN_TREC1997';
EXPERIMENT.AH_MONO_EN_TREC1997.name =  'TREC 06, 1997, Adhoc';

% TREC 07, 1998, Adhoc
EXPERIMENT.AH_MONO_EN_TREC1998.id = 'AH_MONO_EN_TREC1998';
EXPERIMENT.AH_MONO_EN_TREC1998.name =  'TREC 07, 1998, Adhoc';

% TREC 08, 1999, Adhoc
EXPERIMENT.AH_MONO_EN_TREC1999.id = 'AH_MONO_EN_TREC1999';
EXPERIMENT.AH_MONO_EN_TREC1999.name =  'TREC 08, 1999, Adhoc';


%% Patterns for LOG files

% Pattern EXPERIMENT.path.base/log/<type>Analysis_<trackID>.log
EXPERIMENT.pattern.logFile.analysis = @(type, trackID) sprintf('%1$s%2$sAnalysis_%3$s.log', EXPERIMENT.path.log, type, trackID);

% Pattern EXPERIMENT.path.base/log/<type>AnalysisReport.log
EXPERIMENT.pattern.logFile.analysisReport = @(type) sprintf('%1$s%2$sAnalysisReport.log', EXPERIMENT.path.log, type);

% Pattern EXPERIMENT.path.base/log/<type>AnalysisPlot.log
EXPERIMENT.pattern.logFile.analysisPlot = @(type) sprintf('%1$s%2$sAnalysisPlot.log', EXPERIMENT.path.log, type);


%% Patterns for files names

% Pattern EXPERIMENT.path.measure/<trackID>/<measureID>
EXPERIMENT.pattern.file.measure = @(trackID, measureID) ...
    sprintf('%1$s%2$s%3$s%4$s.mat', EXPERIMENT.path.measure, trackID, filesep, measureID);

% Pattern EXPERIMENT.path.analysis/<trackID>/<analysis>_<lugID>_<measureID>
EXPERIMENT.pattern.file.anova = @(trackID, analysis, lugID, measureID) ...
    sprintf('%1$s%2$s%3$s%4$s_%5$s_%6$s.mat', EXPERIMENT.path.analysis, trackID, filesep, analysis, lugID, measureID);

% Pattern EXPERIMENT.path.figure/<trackID>/<figureID>
EXPERIMENT.pattern.file.figure = @(trackID, figureID) ...
    sprintf('%1$s%2$s%3$s%4$s.pdf', EXPERIMENT.path.figure, trackID, filesep, figureID);

% Pattern EXPERIMENT.path.report/<type>AnalysisReport.tex
EXPERIMENT.pattern.file.analysisReport = @(type) ...
    sprintf('%1$s%2$sAnalysisReport.tex', EXPERIMENT.path.report, type);


%% Patterns for identifiers

% Pattern <measureID>_<trackID>
EXPERIMENT.pattern.identifier.measure =  @(measureID, trackID) sprintf('%1$s_%2$s', measureID, trackID);

% Pattern <analysis>_<lugID>_table_<measureID>
EXPERIMENT.pattern.identifier.anovaTable =  @(analysis, lugID, measureID) sprintf('%1$s_%2$s_table_%3$s', analysis, lugID, measureID);

% Pattern <analysis>_<lugID>_stats_<measureID>
EXPERIMENT.pattern.identifier.anovaStats =  @(analysis,lugID, measureID) sprintf('%1$s_%2$s_stats_%3$s', analysis, lugID, measureID);

% Pattern <analysis>_<lugID>_soa_<measureID>
EXPERIMENT.pattern.identifier.anovaSoA =  @(analysis, lugID, measureID) sprintf('%1$s_%2$s_soa_%3$s', analysis,lugID, measureID);

% Pattern <analysis>_<lugID>_sfericity_<measureID>
EXPERIMENT.pattern.identifier.anovaSfericity =  @(analysis, lugID, measureID) sprintf('%1$s_%2$s_sfericity_%3$s', analysis, lugID, measureID);

% Pattern <measure>_mainEffects_<lugID>_<trackID>
EXPERIMENT.pattern.identifier.figure.mainEffects = @(measure, lugID, trackID) ...
    sprintf('%1$s_mainEffects_%2$s_%3$s', measure,  lugID, trackID);

% Pattern <measure>_interactionEffects_<lugID>_<trackID>
EXPERIMENT.pattern.identifier.figure.interactionEffects = @(measure, lugID, trackID) ...
    sprintf('%1$s_interactionEffects_%2$s_%3$s', measure,  lugID, trackID);

% Pattern <measure>_multivariEffects_<lugID>_<trackID>
EXPERIMENT.pattern.identifier.figure.multivariEffects = @(measure, lugID, trackID) ...
    sprintf('%1$s_multivariEffects_%2$s_%3$s', measure,  lugID, trackID);
 
%% Configuration for measures

% The list of measures under experimentation
EXPERIMENT.measure.list = {'ap', 'p10', 'rbp', 'ndcg', 'err'};

% The number of measures under experimentation
EXPERIMENT.measure.number = length(EXPERIMENT.measure.list);

% Configuration for AP
EXPERIMENT.measure.ap.id = 'ap';
EXPERIMENT.measure.ap.shortName = 'AP';
EXPERIMENT.measure.ap.fullName = 'Average Precision (AP)';

% Configuration for P@10
EXPERIMENT.measure.p10.id = 'p10';
EXPERIMENT.measure.p10.shortName = 'P@10';
EXPERIMENT.measure.p10.fullName = 'Precision at 10 Retrieved Documents';

% Configuration for RBP
EXPERIMENT.measure.rbp.id = 'rbp';
EXPERIMENT.measure.rbp.shortName = 'RBP';
EXPERIMENT.measure.rbp.fullName = 'Rank-biased Precision (RBP)';

% Configuration for nDCG@20
EXPERIMENT.measure.ndcg.id = 'ndcg';
EXPERIMENT.measure.ndcg.shortName = 'nDCG@20';
EXPERIMENT.measure.ndcg.fullName = 'Normalized Discounted Cumulated Gain (nDCG) at 20 Retrieved Documents';

% Configuration for ERR@20
EXPERIMENT.measure.err.id = 'err';
EXPERIMENT.measure.err.shortName = 'ERR@20';
EXPERIMENT.measure.err.fullName = 'Expected Reciprocal Rank (ERR) at 20 Retrieved Documents';

% Returns the name of a measure given its index in EXPERIMENT.measure.list
EXPERIMENT.measure.getShortName = @(idx) ( EXPERIMENT.measure.(EXPERIMENT.measure.list{idx}).shortName ); 

% Returns the full name of a measure given its index in EXPERIMENT.measure.list
EXPERIMENT.measure.getFullName = @(idx) ( EXPERIMENT.measure.(EXPERIMENT.measure.list{idx}).fullName ); 



%% Configuration for analyses

% The significance level for the analyses
EXPERIMENT.analysis.alpha = 0.05;
EXPERIMENT.analysis.notSignificantColor = 'yellow';

% The maximum number of topics to consider in the analyses. If empty, all
% the topics will be considered
%EXPERIMENT.analysis.maxTopic = 5;
EXPERIMENT.analysis.maxTopic = [];

% Type of analyses
EXPERIMENT.analysis.singleF.id = 'singleF';
EXPERIMENT.analysis.singleF.name = 'singleFactor';
EXPERIMENT.analysis.singleF.description = 'Single factor, repeated measures, mixed crossed effects GLMM: topics are random effects (repeated measures/within-subject), systems are fixed effects';
EXPERIMENT.analysis.singleF.command = @(measures, list) ( singleFactorRepeatedMeasuresMixedCrossedEffects(measures, list) );

EXPERIMENT.analysis.twoF.id = 'twoF';
EXPERIMENT.analysis.twoF.name = 'twoFactor';
EXPERIMENT.analysis.twoF.description = 'Two factors, repeated measures, mixed crossed effects GLMM: topics are random effects (repeated measures/within-subject), selected components and IR pipelines are fixed effects';
EXPERIMENT.analysis.twoF.command = @(measures, groups) ( twoFactorRepeatedMeasuresMixedCrossedEffects(measures, groups) );
EXPERIMENT.analysis.twoF.componentAnalysis = @(componentType) ( sprintf('%s_%s', EXPERIMENT.analysis.twoF.id, componentType) );

EXPERIMENT.analysis.threeF.id = 'threeF';
EXPERIMENT.analysis.threeF.name = 'threeFactor';
EXPERIMENT.analysis.threeF.description = 'Three factors, repeated measures, mixed crossed effects GLMM: topics are random effects (repeated measures/within-subject), stop lists, stemmers and/or n-grams, and IR models are fixed effects';
EXPERIMENT.analysis.threeF.command = @(measures, lugType) ( threeFactorRepeatedMeasuresMixedCrossedEffects(measures, lugType) );
EXPERIMENT.analysis.threeF.interactionEffectsPlots = @(measures, measureID, trackID, list) threeFactorInteractionEffectsPlot(measures, measureID, trackID, list);
EXPERIMENT.analysis.threeF.mainEffectsPlots = @(measures, measureID, trackID, lugType) threeFactorMainEffectsPlot(measures, measureID, trackID, lugType);
EXPERIMENT.analysis.threeF.multivariEffectsPlots = @(measures, measureID, trackID, list) threeFactorMultivariEffectsPlot(measures, measureID, trackID, list);
