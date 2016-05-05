%% twoFactorAnalysisReport
% 
% Print the summary report of the two factors analyses and save them to a 
% tex file.
%
%% Synopsis
%
%   [] = twoFactorAnalysisReport(varargin)
%  
%
% *Parameters*
%
% * *|varargin|* - the identifiers of the tracks to print.
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


function [] = twoFactorAnalysisReport(varargin)

    tracks = length(varargin);
    
    for t = 1:tracks
        
        % check that trackID is a non-empty string
        validateattributes(varargin{t}, {'char', 'cell'}, {'nonempty', 'vector'}, '', 'trackID');
        
        if iscell(varargin{t})
            
            % check that trackID is a cell array of strings with one element
            assert(iscellstr(varargin{t}) && numel(varargin{t}) == 1, ...
                'MATTERS:IllegalArgument', 'Expected trackID to be a cell array of strings containing just one string.');
        end
        
        % remove useless white spaces, if any, and ensure it is a char row
        varargin{t} = char(strtrim(varargin{t}));
        varargin{t} = varargin{t}(:).';
        
    end;

    % setup common parameters
    common_parameters;
        
    % turn on logging
    delete(EXPERIMENT.pattern.logFile.analysisReport('twoFactor'));
    diary(EXPERIMENT.pattern.logFile.analysisReport('twoFactor'));
    
    % start of overall computations
    startComputation = tic;
    
    fprintf('\n\n######## Printing summary report of the two factors analyses (%s) ########\n\n', EXPERIMENT.label.paper);
       

    fprintf('+ Settings\n');
    fprintf('  - computed on %s\n', datestr(now, 'yyyy-mm-dd at HH:MM:SS'));
    fprintf('  - tracks: \n    * %s\n\n', strjoin(varargin, '\n    * '));
            
    fprintf('+ Loading analyses\n');
    
    % the data structures
    anovaTable = [];
    soa = [];
        
    % for each track
    for t = 1:tracks
        
        trackID = varargin{t};
        
        fprintf('  - track: %s \n', trackID);
        
        % for each measure
        for m = 1:EXPERIMENT.measure.number
            
            fprintf('    * measure: %s \n', EXPERIMENT.measure.getShortName(m));
            
            measureID = EXPERIMENT.pattern.identifier.measure(EXPERIMENT.measure.list{m}, trackID);
            
            for c = 1:EXPERIMENT.taxonomy.component.number
                
                componentID = EXPERIMENT.taxonomy.component.list{c};
                
                fprintf('      # component: %s\n', componentID);
                
                for lug = 1:EXPERIMENT.taxonomy.lug.number
                    
                    lugID = EXPERIMENT.taxonomy.lug.list{lug};
                    
                    % if we are dealing with a lexical unit generator, only
                    % pairs (stem, stem), (gram, gram), (lugall, lugall) are
                    % to be considered for analysis
                    if any(strcmp(componentID, EXPERIMENT.taxonomy.lug.list)) && ~strcmp(componentID, lugID)
                        continue;
                    end;
                    
                    fprintf('        = lexical unit generator: %s\n', lugID);
                    
                    try
                        
                        anovaTableID = EXPERIMENT.pattern.identifier.anovaTable(EXPERIMENT.analysis.twoF.componentAnalysis(componentID), lugID, measureID);
                        anovaSoAID = EXPERIMENT.pattern.identifier.anovaSoA(EXPERIMENT.analysis.twoF.componentAnalysis(componentID), lugID, measureID);
                                                
                        serload(EXPERIMENT.pattern.file.anova(trackID, EXPERIMENT.analysis.twoF.componentAnalysis(componentID), lugID, measureID), ...
                            anovaTableID, anovaSoAID);
                        
                        eval(sprintf('anovaTable.(''%1$s'').(''%2$s'').(''%3$s'').(''%4$s'') = %5$s;', trackID, EXPERIMENT.measure.list{m}, componentID, lugID, anovaTableID));
                        eval(sprintf('soa.(''%1$s'').(''%2$s'').(''%3$s'').(''%4$s'') = %5$s;', trackID, EXPERIMENT.measure.list{m}, componentID, lugID, anovaSoAID));
                        
                        clear(anovaTableID, anovaSoAID);
                        
                    catch exception
                        % do nothing, just skip the missing value
                        
                    end;
                    
                end; % lug
                
            end; % components
            
        end % measures
        
    end; % track
    
    clear measureID anovaTableID anovaSoAID;
    
 
    
    fprintf('+ Printing the report\n');    

    % the file where the report has to be written
    fid = fopen(EXPERIMENT.pattern.file.analysisReport(EXPERIMENT.analysis.twoF.name), 'w');

    fprintf(fid, '\\documentclass[11pt]{article} \n\n');

    fprintf(fid, '\\usepackage{amsmath}\n');
    fprintf(fid, '\\usepackage{multirow}\n');
    fprintf(fid, '\\usepackage{colortbl}\n');
    fprintf(fid, '\\usepackage{lscape}\n');
    fprintf(fid, '\\usepackage{pdflscape}\n');        
    fprintf(fid, '\\usepackage[x11names]{xcolor}\n');
    fprintf(fid, '\\usepackage[a3paper]{geometry}\n\n');
    

    fprintf(fid, '\\begin{document}\n\n');

    fprintf(fid, '\\title{Summary Report on Two Factors Analyses}\n\n');

    fprintf(fid, '\\maketitle\n\n');
    
    fprintf(fid, 'Tracks:\n');
    fprintf(fid, '\\begin{itemize}\n');
    
    % for each track
    for t = 1:tracks
        fprintf(fid, '\\item %s\n', EXPERIMENT.(varargin{t}).name);
    end;
    
    fprintf(fid, '\\end{itemize}\n');
    
    
    
    subTrackRows = 27;
    subLugRows = 3;
  
    % for each track
    for t = 1:tracks
        
        trackID = varargin{t};
        trackName = EXPERIMENT.(trackID).name;
        
        fprintf(fid, '\\begin{landscape}  \n');
        fprintf(fid, '\\begin{table}[p] \n');
        % fprintf(fid, '\\tiny \n');
        fprintf(fid, '\\centering \n');
        % fprintf(fid, '\\vspace*{-12em} \n');
        %fprintf(fid, '\\hspace*{-6.5em} \n');
        
        fprintf(fid, '\\begin{tabular}{|l|l|l|*{%d}{r|}} \n', EXPERIMENT.measure.number);
        
        fprintf(fid, '\\hline\\hline \n');
        
        fprintf(fid, '\\multicolumn{1}{|c}{\\textbf{Collection}} & \\multicolumn{1}{|c}{\\textbf{Lexical Units}} & \\multicolumn{1}{|c}{\\textbf{Effects}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c|}{\\textbf{%s}} \\\\  \n', ...
            EXPERIMENT.measure.getShortName(1), EXPERIMENT.measure.getShortName(2), EXPERIMENT.measure.getShortName(3), ...
            EXPERIMENT.measure.getShortName(4), EXPERIMENT.measure.getShortName(5));
        
        fprintf(fid, '\\hline \n');
        
        printFirstRow = true;
        for c = 1:EXPERIMENT.taxonomy.component.number
            
            componentID = EXPERIMENT.taxonomy.component.list{c};
            componentName = EXPERIMENT.taxonomy.(componentID).name;
                        
            for lug = 1:EXPERIMENT.taxonomy.lug.number
                
                lugID = EXPERIMENT.taxonomy.lug.list{lug};                
                lugName = EXPERIMENT.taxonomy.(lugID).name;                                                                          
                               
                % if we are dealing with a lexical unit generator, only
                % pairs like (stem, stem), (gram, gram), (lugall, lugall)
                % are to be considered for analysis
                if any(strcmp(componentID, EXPERIMENT.taxonomy.lug.list)) && ~strcmp(componentID, lugID)
                    continue;
                end;
                                
                if printFirstRow  % the header for the very first row of the table
                    fprintf(fid, ' \\multirow{%d}*{%s} & \\multirow{%d}*{%s} & $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', ...
                        subTrackRows, trackName , ...
                        subLugRows, lugName, ...
                        componentName);
                    
                    printFirstRow = false;
                else
                    fprintf(fid, '  & \\multirow{%d}*{%s} & $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', ...
                        subLugRows, lugName, ...
                        componentName);
                end;
                
                % print the component data               
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    if anovaTable.(trackID).(measureID).(componentID).(lugID){3, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, '  & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(componentID).(lugID).omega2p.components, ...
                            anovaTable.(trackID).(measureID).(componentID).(lugID){3, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(componentID).(lugID).omega2p.components, ...
                            anovaTable.(trackID).(measureID).(componentID).(lugID){3, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                % print the pipeline data
                fprintf(fid, '            &          &  $\\hat{\\omega}^2_{\\langle\\text{Pipelines}\\rangle}$ ');
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    
                    if anovaTable.(trackID).(measureID).(componentID).(lugID){4, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, ' & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(componentID).(lugID).omega2p.pipelines, ...
                            anovaTable.(trackID).(measureID).(componentID).(lugID){4, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(componentID).(lugID).omega2p.pipelines, ...
                            anovaTable.(trackID).(measureID).(componentID).(lugID){4, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                % print the component x pipeline data
                fprintf(fid, '          &           &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{Pipelines}\\rangle}$ ', componentName);                
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    
                    if anovaTable.(trackID).(measureID).(componentID).(lugID){5, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, '  & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(componentID).(lugID).omega2p.components_pipelines, ...
                            anovaTable.(trackID).(measureID).(componentID).(lugID){5, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(componentID).(lugID).omega2p.components_pipelines, ...
                            anovaTable.(trackID).(measureID).(componentID).(lugID){5, 7} ...
                            );
                    end;
                end; % measure
                
                fprintf(fid, '\\\\ \n');
                
                fprintf(fid, '\\cline{3-8} \n');
                
            end; %lug
            
            fprintf(fid, '\\cline{2-8} \n');
        end; %component
        
        fprintf(fid, '\\hline \n');  
        
         fprintf(fid, '\\hline \n');
    
    fprintf(fid, '\\end{tabular} \n');
    
    fprintf(fid, '\\caption{Summary of two factor models on %s. Each cell reports the estimated $\\hat{\\omega}^2$ SoA for the speficied effects and, within parentheses, the p-value for those effects.} \n', ...
        trackName);
    
    fprintf(fid, '\\label{tab:twoF-summary-%s} \n', trackID);
    
    fprintf(fid, '\\end{table} \n\n');
    
    fprintf(fid, '\\end{landscape}  \n');
        
        
    end; % track
    
    
   
    
        
    fprintf(fid, '\\end{document}');

    fclose(fid);

    
    
    
        
%     % for each measure
%     for m = 1:EXPERIMENT.measure.number
%         
%         measureID  = EXPERIMENT.measure.list{m};
%         measureShortName = EXPERIMENT.measure.getShortName(m);
%                 
%         % for each track
%         for t = 1:tracks
%             
%             trackID = varargin{t};
%             
%             % fprintf(fid, '\\begin{landscape}  \n');
%             fprintf(fid, '\\begin{table}[p] \n');
%             % fprintf(fid, '\\tiny \n');
%             fprintf(fid, '\\centering \n');
%             % fprintf(fid, '\\vspace*{-12em} \n');
%             % fprintf(fid, '\\hspace*{-16.5em} \n');
% 
%             fprintf(fid, '\\begin{tabular}{|l|*{5}{r|}} \n');
% 
%             for c = 1:EXPERIMENT.taxonomy.component.number
%                 
%                 componentID = EXPERIMENT.taxonomy.component.list{c};
%                 componentName = EXPERIMENT.taxonomy.(componentID).name;
%                                         
%                 fprintf(fid, '\\hline\\hline \n');
%                 fprintf(fid, '\\multicolumn{6}{|c|}{\\textbf{GLMM for %1$s with %2$s -- Collection: %3$s}} \\\\ \n', componentName, measureShortName, EXPERIMENT.(trackID).name);
%                 fprintf(fid, '\\hline \n');  
%             
%                 fprintf(fid, '\\multicolumn{1}{|c}{\\textbf{Source}} & \\multicolumn{1}{|c}{\\textbf{SS}} & \\multicolumn{1}{|c}{\\textbf{DF}} & \\multicolumn{1}{|c}{\\textbf{MS}} & \\multicolumn{1}{|c}{\\textbf{F}} & \\multicolumn{1}{|c|}{\\textbf{p-value}} \\\\  \n');  
%                 fprintf(fid, '\\hline \n'); 
%                 
%                 fprintf(fid, '\\textbf{%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                     componentName, ...
%                     anovaTable.(trackID).(measureID).(componentID){3, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){3, 3}, ... % Degrees of freedom
%                     anovaTable.(trackID).(measureID).(componentID){3, 5}, ... % Mean Squares
%                     anovaTable.(trackID).(measureID).(componentID){3, 6}, ... % F-value
%                     anovaTable.(trackID).(measureID).(componentID){3, 7}  ... % p-value
%                 );
%                 fprintf(fid, '\\hline \n');
% 
%                 fprintf(fid, '\\textbf{Pipelines} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                     anovaTable.(trackID).(measureID).(componentID){4, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){4, 3}, ... % Degrees of freedom
%                     anovaTable.(trackID).(measureID).(componentID){4, 5}, ... % Mean Squares
%                     anovaTable.(trackID).(measureID).(componentID){4, 6}, ... % F-value
%                     anovaTable.(trackID).(measureID).(componentID){4, 7}  ... % p-value
%                 );
%                 fprintf(fid, '\\hline \n');  
%         
%                 fprintf(fid, '\\textbf{Topics$^\\prime$} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                     anovaTable.(trackID).(measureID).(componentID){2, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){2, 3}, ... % Degrees of freedom
%                     anovaTable.(trackID).(measureID).(componentID){2, 5}, ... % Mean Squares
%                     anovaTable.(trackID).(measureID).(componentID){2, 6}, ... % F-value
%                     anovaTable.(trackID).(measureID).(componentID){2, 7}  ... % p-value
%                 );
%                 fprintf(fid, '\\hline \n'); 
%                 
%                 fprintf(fid, '\\textbf{%s$\\times$Pipelines} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                     componentName, ...
%                     anovaTable.(trackID).(measureID).(componentID){7, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){7, 3}, ... % Degrees of freedom
%                     anovaTable.(trackID).(measureID).(componentID){7, 5}, ... % Mean Squares
%                     anovaTable.(trackID).(measureID).(componentID){7, 6}, ... % F-value
%                     anovaTable.(trackID).(measureID).(componentID){7, 7}  ... % p-value
%                 );
%                 fprintf(fid, '\\hline \n');
%                 
%                 fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                     componentName, ...
%                     anovaTable.(trackID).(measureID).(componentID){5, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){5, 3}, ... % Degrees of freedom
%                     anovaTable.(trackID).(measureID).(componentID){5, 5}, ... % Mean Squares
%                     anovaTable.(trackID).(measureID).(componentID){5, 6}, ... % F-value
%                     anovaTable.(trackID).(measureID).(componentID){5, 7}  ... % p-value
%                 );
%                 fprintf(fid, '\\hline \n');  
%                 
%                 fprintf(fid, '\\textbf{Topics$^\\prime\\times$Pipelines} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                     anovaTable.(trackID).(measureID).(componentID){6, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){6, 3}, ... % Degrees of freedom
%                     anovaTable.(trackID).(measureID).(componentID){6, 5}, ... % Mean Squares
%                     anovaTable.(trackID).(measureID).(componentID){6, 6}, ... % F-value
%                     anovaTable.(trackID).(measureID).(componentID){6, 7}  ... % p-value
%                 );
%                 fprintf(fid, '\\hline \n');
%         
%                 fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s$\\times$Pipelines} & %.4f & %d & %.4f & -- & -- \\\\ \n', ...
%                     componentName, ...
%                     anovaTable.(trackID).(measureID).(componentID){8, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){8, 3}, ... % Degrees of freedom
%                     anovaTable.(trackID).(measureID).(componentID){8, 5}  ... % Mean Squares
%                 );
%                 fprintf(fid, '\\hline \n');  
% 
%                 fprintf(fid, '\\textbf{Error} & %.4f & %d & %.4f & -- & -- \\\\ \n', ...
%                     anovaTable.(trackID).(measureID).(componentID){9, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){9, 3}, ... % Degrees of freedom
%                     anovaTable.(trackID).(measureID).(componentID){9, 5}  ... % Mean Squares
%                 );
%                 fprintf(fid, '\\hline \n'); 
% 
%                 fprintf(fid, '\\textbf{Total} & %.4f & %d & -- & -- & -- \\\\ \n', ...
%                     anovaTable.(trackID).(measureID).(componentID){10, 2}, ... % Sum of squares 
%                     anovaTable.(trackID).(measureID).(componentID){10, 3}  ... % Degrees of freedom
%                 );
%                 fprintf(fid, '\\hline \n'); 
% 
%                 fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}} =$ %.4f} \\\\ \n', ...    
%                     componentName, ...
%                     omega2.(trackID).(measureID).(componentID).components  ... % Strength of association
%                 );
%                 fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{Pipelines}} =$ %.4f} \\\\ \n', ...               
%                     omega2.(trackID).(measureID).(componentID).pipelines  ... % Strength of association
%                 );
%                 fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}\\times\\text{Pipelines}} =$ %.4f} \\\\ \n', ...    
%                     componentName, ...
%                     omega2.(trackID).(measureID).(componentID).components_pipelines  ... % Strength of association
%                 );
%         
%                 fprintf(fid, '\\multicolumn{6}{|l|}{Levene''s sfericity $\\text{p-value}_{\\text{%s}} =$ %.4f} \\\\ \n', ...    
%                     componentName, ...
%                     sfericity.(trackID).(measureID).(componentID).components  ... % Sfericity p-value
%                 );
%                 fprintf(fid, '\\multicolumn{6}{|l|}{Levene''s sfericity $\\text{p-value}_{\\text{Pipelines}} =$ %.4f} \\\\ \n', ...               
%                     sfericity.(trackID).(measureID).(componentID).pipelines  ... % Sfericity p-value
%                 );
%                             
%             end; % component
%             
%             fprintf(fid, '\\hline\\hline \n');
%             
%             fprintf(fid, '\\end{tabular} \n');
%             
%             fprintf(fid, '\\caption{%1$s. ANOVA table for GLMM of %2$s on collection %3$s.} \n', ...
%                 EXPERIMENT.analysis.twoF.description, EXPERIMENT.measure.getFullName(m), EXPERIMENT.(trackID).name);
%             
%             fprintf(fid, '\\label{tab:twoF-ANOVA-table-%1$s-%2$s} \n', measureShortName, trackID);
%             
%             fprintf(fid, '\\end{table} \n\n');
%             
%             % fprintf(fid, '\\end{landscape}  \n');
%             
%         end; % track
%         
%     end; % measure
       
    
    fprintf('\n\n######## Total elapsed time for printing summary report of the two factors analyses (%s): %s ########\n\n', ...
            EXPERIMENT.label.paper, elapsedToHourMinutesSeconds(toc(startComputation)));


    diary off;

end
