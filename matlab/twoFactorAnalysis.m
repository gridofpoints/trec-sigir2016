%% twoFactorAnalysis
% 
% Performs a two factors analysis on the considered experimental
% collections.

%% Synopsis
%
%   [] = twoFactorAnalysis(trackID, startMeasure, endMeasure)
%  
%
% *Parameters*
%
% * *|trackID|* - the identifier of the track for which the processing is
% performed.
% * *|startMeasure|* - the index of the start measure to analyse. Optional.
% * *|endMeasure|* - the index of the end measure to analyse. Optional.
%
%
% *Returns*
%
% Nothing
%

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

function [] = twoFactorAnalysis(trackID, startMeasure, endMeasure)

    % check the number of input arguments
    narginchk(1, 3);
    
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
    
    % setup common parameters
    common_parameters;
    
    if nargin == 3
        validateattributes(startMeasure, {'numeric'}, ...
            {'nonempty', 'integer', 'scalar', '>=', 1, '<=', EXPERIMENT.measure.number }, '', 'startMeasure');
        
        validateattributes(endMeasure, {'numeric'}, ...
            {'nonempty', 'integer', 'scalar', '>=', startMeasure, '<=', EXPERIMENT.measure.number }, '', 'endMeasure');

    else 
        startMeasure = 1;
        endMeasure = EXPERIMENT.measure.number;
    end;
    
    % turn on logging
    delete(EXPERIMENT.pattern.logFile.analysis(EXPERIMENT.analysis.twoF.name, trackID));
    diary(EXPERIMENT.pattern.logFile.analysis(EXPERIMENT.analysis.twoF.name, trackID));

    % start of overall computations
    startComputation = tic;

    fprintf('\n\n######## Computing two factor analyses on collection %s (%s) ########\n\n', EXPERIMENT.(trackID).name, EXPERIMENT.label.paper);
        
    fprintf('+ Settings\n');
    fprintf('  - computed on %s\n', datestr(now, 'yyyy-mm-dd at HH:MM:SS'));
    fprintf('  - significance level alpha: %f\n', EXPERIMENT.analysis.alpha);
     
    if ~isempty(EXPERIMENT.analysis.maxTopic)
        fprintf('  - maximum number of analysed topics: %d\n', EXPERIMENT.analysis.maxTopic);
    else
        fprintf('  - maximum number of analysed topics: all\n');
    end;
    fprintf('  - analysis type: %s\n', EXPERIMENT.analysis.twoF.description);
    fprintf('  - slice \n');
    fprintf('    * start measure: %d\n', startMeasure);
    fprintf('    * end measure: %d\n', endMeasure);


    % for each measure in EXPERIMENT.measure.list
    for m = 1:startMeasure:endMeasure
        
        fprintf('\n+ Analysing %s\n', EXPERIMENT.measure.getShortName(m));
        
        measureID = EXPERIMENT.pattern.identifier.measure(EXPERIMENT.measure.list{m}, trackID);
        
        fprintf('  - loading measures\n');
        serload(EXPERIMENT.pattern.file.measure(trackID, measureID), measureID);
                 
        for c = 1:EXPERIMENT.taxonomy.component.number
            
            componentID = EXPERIMENT.taxonomy.component.list{c};
            
            for lug = 1:EXPERIMENT.taxonomy.lug.number
                
                start = tic;
                
                lugID = EXPERIMENT.taxonomy.lug.list{lug};
                
                % if we are dealing with a lexical unit generator, only
                % pairs (stem, stem), (gram, gram), (lugall, lugall) are
                % to be considered for analysis
                if any(strcmp(componentID, EXPERIMENT.taxonomy.lug.list)) && ~strcmp(componentID, lugID)
                    continue;
                end;
                
                fprintf('  - performing analyses on component %s using lexical unit generators %s\n', ...
                    EXPERIMENT.taxonomy.(componentID).name, EXPERIMENT.taxonomy.(lugID).name);

                
                groups = groupSystemsByComponent(componentID, lugID);
                
                anovaTableID = EXPERIMENT.pattern.identifier.anovaTable(EXPERIMENT.analysis.twoF.componentAnalysis(componentID), lugID, measureID);
                anovaStatsID = EXPERIMENT.pattern.identifier.anovaStats(EXPERIMENT.analysis.twoF.componentAnalysis(componentID), lugID, measureID);
                anovaSoAID = EXPERIMENT.pattern.identifier.anovaSoA(EXPERIMENT.analysis.twoF.componentAnalysis(componentID), lugID, measureID);
                anovaSfericityID = EXPERIMENT.pattern.identifier.anovaSfericity(EXPERIMENT.analysis.twoF.componentAnalysis(componentID), lugID, measureID);                                
                
                evalf(EXPERIMENT.analysis.twoF.command, ...
                    {measureID, 'groups'}, ...
                    {anovaTableID, anovaStatsID, anovaSoAID, anovaSfericityID});
                
                fprintf('    * saving analyses\n');
                sersave(EXPERIMENT.pattern.file.anova(trackID, EXPERIMENT.analysis.twoF.componentAnalysis(componentID), lugID, measureID), ...
                    anovaTableID(:), anovaStatsID(:), anovaSoAID(:), anovaSfericityID(:))
                
                % free space
                clear(anovaTableID, anovaStatsID, anovaSoAID, anovaSfericityID);
                
                fprintf('    * elapsed time: %s\n', elapsedToHourMinutesSeconds(toc(start)));
                
            end; % lug
        end; % component
        
        % free space
        clear(measureID);
        
    end; % measure

    fprintf('\n\n######## Total elapsed time for computing two factor analyses on collection %s (%s): %s ########\n\n', ...
        EXPERIMENT.(trackID).name, EXPERIMENT.label.paper, elapsedToHourMinutesSeconds(toc(startComputation)));
    
    diary off;
    
end


