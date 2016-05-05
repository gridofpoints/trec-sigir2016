%% singleFactorAnalysisReport
% 
% Print the summary report of the single factor analyses and save them to a 
% tex file.
%
%% Synopsis
%
%   [] = singleFactorAnalysisReport(varargin)
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


function [] = singleFactorAnalysisReport(varargin)

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
    delete(EXPERIMENT.pattern.logFile.analysisReport(EXPERIMENT.analysis.singleF.name));
    diary(EXPERIMENT.pattern.logFile.analysisReport(EXPERIMENT.analysis.singleF.name));
    
    % start of overall computations
    startComputation = tic;
    
    fprintf('\n\n######## Printing summary report of the single factor analyses (%s) ########\n\n', EXPERIMENT.label.paper);
       

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
            
            for lug = 1:EXPERIMENT.taxonomy.lug.number
                
                lugID = EXPERIMENT.taxonomy.lug.list{lug};
                
                fprintf('      # lexical unit generator: %s \n', EXPERIMENT.taxonomy.(lugID).name);
                
                try
                    
                    anovaTableID = EXPERIMENT.pattern.identifier.anovaTable(EXPERIMENT.analysis.singleF.id, lugID, measureID);
                    anovaSoAID = EXPERIMENT.pattern.identifier.anovaSoA(EXPERIMENT.analysis.singleF.id, lugID, measureID);
                    
                    serload(EXPERIMENT.pattern.file.anova(trackID, EXPERIMENT.analysis.singleF.id, lugID, measureID), anovaTableID, anovaSoAID);
                    
                    eval(sprintf('anovaTable.(''%1$s'').(''%2$s'').(''%3$s'') = %4$s;', trackID, EXPERIMENT.measure.list{m}, lugID, anovaTableID));
                    eval(sprintf('soa.(''%1$s'').(''%2$s'').(''%3$s'') = %4$s;', trackID, EXPERIMENT.measure.list{m}, lugID, anovaSoAID));
                    
                    clear(anovaTableID, anovaSoAID);
                    
                catch exception
                    % do nothing, just skip the missing value
                    
                end;
                
            end; % lug
            
        end % measures
        
    end; % track
    
    clear measureID anovaTableID anovaSoAID;
    
 
    
    fprintf('+ Printing the report\n');    

    % the file where the report has to be written
    fid = fopen(EXPERIMENT.pattern.file.analysisReport(EXPERIMENT.analysis.singleF.name), 'w');


    fprintf(fid, '\\documentclass[11pt]{article} \n\n');

    fprintf(fid, '\\usepackage{amsmath}\n');
    fprintf(fid, '\\usepackage{multirow}\n');
    fprintf(fid, '\\usepackage{colortbl}\n');
    fprintf(fid, '\\usepackage{lscape}\n');
    fprintf(fid, '\\usepackage{pdflscape}\n');        
    fprintf(fid, '\\usepackage[x11names]{xcolor}\n');
    fprintf(fid, '\\usepackage[a3paper]{geometry}\n\n');
    

    fprintf(fid, '\\begin{document}\n\n');

    fprintf(fid, '\\title{Summary Report on Single Factor Analyses}\n\n');

    fprintf(fid, '\\maketitle\n\n');
    
    fprintf(fid, 'Tracks:\n');
    fprintf(fid, '\\begin{itemize}\n');
    
    % for each track
    for t = 1:tracks
        fprintf(fid, '\\item %s\n', EXPERIMENT.(varargin{t}).name);
    end;
    
    fprintf(fid, '\\end{itemize}\n');
    
    
        
    % fprintf(fid, '\\begin{landscape}  \n');
    fprintf(fid, '\\begin{table}[p] \n');
    % fprintf(fid, '\\tiny \n');
    fprintf(fid, '\\centering \n');
    fprintf(fid, '\\hspace*{-6.5em} \n');
    
    fprintf(fid, '\\begin{tabular}{|l|l|l|*{%d}{r|}} \n', EXPERIMENT.measure.number);
    
    fprintf(fid, '\\hline\\hline \n');
    
    fprintf(fid, '\\multicolumn{1}{|c}{\\textbf{Collection}} & \\multicolumn{1}{|c}{\\textbf{Lexical Units}} & \\multicolumn{1}{|c}{\\textbf{Effects}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c|}{\\textbf{%s}} \\\\  \n', ...
        EXPERIMENT.measure.getShortName(1), EXPERIMENT.measure.getShortName(2), EXPERIMENT.measure.getShortName(3), ...
        EXPERIMENT.measure.getShortName(4), EXPERIMENT.measure.getShortName(5));  
    
    fprintf(fid, '\\hline \n');  
    
    % for each track
    for t = 1:tracks
        
        trackID = varargin{t};
        
        fprintf(fid, ' \\multirow{3}*{%s} & %s &  $\\hat{\\omega}^2_{\\langle\\text{Systems}\\rangle}$ ', ...
            EXPERIMENT.(trackID).name, ...
            EXPERIMENT.taxonomy.lugall.name);
    
        for m = 1:EXPERIMENT.measure.number
            measureID = EXPERIMENT.measure.list{m};
            
            if anovaTable.(trackID).(measureID).lugall{3, 7} <= EXPERIMENT.analysis.alpha                    
                fprintf(fid, ' & %.4f (%.4f) ', soa.(trackID).(measureID).lugall.omega2p, anovaTable.(trackID).(measureID).lugall{3, 7});                      
            else
                fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                    EXPERIMENT.analysis.notSignificantColor, ...
                    soa.(trackID).(measureID).lugall.omega2p, anovaTable.(trackID).(measureID).lugall{3, 7});                        
            end;
            
            
        end; % measure        
        fprintf(fid, '\\\\ \n');
        
        
        
        fprintf(fid, '                     & %s &  $\\hat{\\omega}^2_{\\langle\\text{Systems}\\rangle}$ ', ...            
            EXPERIMENT.taxonomy.stem.name);
    
        for m = 1:EXPERIMENT.measure.number
            measureID = EXPERIMENT.measure.list{m};
            
            if anovaTable.(trackID).(measureID).stem{3, 7} <= EXPERIMENT.analysis.alpha                    
                fprintf(fid, ' & %.4f (%.4f) ', soa.(trackID).(measureID).stem.omega2p, anovaTable.(trackID).(measureID).stem{3, 7});                      
            else
                fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                    EXPERIMENT.analysis.notSignificantColor, ...
                    soa.(trackID).(measureID).stem.omega2p, anovaTable.(trackID).(measureID).stem{3, 7});                        
            end;
            
            
        end; % measure        
        fprintf(fid, '\\\\ \n');
        
        fprintf(fid, '                     & %s &  $\\hat{\\omega}^2_{\\langle\\text{Systems}\\rangle}$ ', ...
            EXPERIMENT.taxonomy.grams.name);
    
        for m = 1:EXPERIMENT.measure.number
            measureID = EXPERIMENT.measure.list{m};
            
            if anovaTable.(trackID).(measureID).stem{3, 7} <= EXPERIMENT.analysis.alpha                    
                fprintf(fid, ' & %.4f (%.4f) ', soa.(trackID).(measureID).grams.omega2p, anovaTable.(trackID).(measureID).grams{3, 7});                      
            else
                fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                    EXPERIMENT.analysis.notSignificantColor, ...
                    soa.(trackID).(measureID).grams.omega2p, anovaTable.(trackID).(measureID).grams{3, 7});                        
            end;
            
            
        end; % measure        
        fprintf(fid, '\\\\ \n');
                
        fprintf(fid, '\\hline \n');  
        
        
    end; % track
    
    
    fprintf(fid, '\\hline \n');
    
    fprintf(fid, '\\end{tabular} \n');
    
    fprintf(fid, '\\caption{Summary of single factor models on TREC Ad-hoc collections. Each cell reports the estimated $\\hat{\\omega}^2$ SoA for the System effects and, within parentheses, the p-value for those effects.} \n');
    
    fprintf(fid, '\\label{tab:singleF-summary} \n');
    
    fprintf(fid, '\\end{table} \n\n');
    
    % fprintf(fid, '\\end{landscape}  \n');
       
    
    fprintf(fid, '\\end{document} \n\n');
    
    
    fclose(fid);
    
    
    
%     % for each measure
%     for m = 1:EXPERIMENT.measure.number
%         
%         measureID  = EXPERIMENT.measure.list{m};
%         measureShortName = EXPERIMENT.measure.getShortName(m);
%         
%         % fprintf(fid, '\\begin{landscape}  \n');
%         fprintf(fid, '\\begin{table}[p] \n');
%         % fprintf(fid, '\\tiny \n');
%         fprintf(fid, '\\centering \n');
%         % fprintf(fid, '\\vspace*{-12em} \n');
%         % fprintf(fid, '\\hspace*{-16.5em} \n');
%         
%         fprintf(fid, '\\begin{tabular}{|l|*{5}{r|}} \n');
%         
%         % for each track
%         for t = 1:tracks
%             
%             trackID = varargin{t};
%                         
%             fprintf(fid, '\\hline\\hline \n');
%             fprintf(fid, '\\multicolumn{6}{|c|}{\\textbf{GLMM for %1$s -- Collection: %2$s}} \\\\ \n', measureShortName, EXPERIMENT.(trackID).name);
%             fprintf(fid, '\\hline \n');  
%             
%             fprintf(fid, '\\multicolumn{1}{|c}{\\textbf{Source}} & \\multicolumn{1}{|c}{\\textbf{SS}} & \\multicolumn{1}{|c}{\\textbf{DF}} & \\multicolumn{1}{|c}{\\textbf{MS}} & \\multicolumn{1}{|c}{\\textbf{F}} & \\multicolumn{1}{|c|}{\\textbf{p-value}} \\\\  \n');  
%             fprintf(fid, '\\hline \n');  
%             
%             fprintf(fid, '\\textbf{Systems} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 anovaTable.(trackID).(measureID){3, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){3, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){3, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){3, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){3, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n');  
%         
%             fprintf(fid, '\\textbf{Topics$^\\prime$} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 anovaTable.(trackID).(measureID){2, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){2, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){2, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){2, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){2, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n');  
%         
%             fprintf(fid, '\\textbf{Topics$^\\prime\\times$Systems} & %.4f & %d & %.4f & -- & -- \\\\ \n', ...
%                 anovaTable.(trackID).(measureID){4, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){4, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){4, 5} ... % Mean Squares
%             );
%             fprintf(fid, '\\hline \n');  
%         
%             fprintf(fid, '\\textbf{Error} & %.4f & %d & %.4f & -- & -- \\\\ \n', ...
%                 anovaTable.(trackID).(measureID){5, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){5, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){5, 5}  ... % Mean Squares
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\textbf{Total} & %.4f & %d & -- & -- & -- \\\\ \n', ...
%                 anovaTable.(trackID).(measureID){6, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){6, 3}  ... % Degrees of freedom
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{Systems}} =$ %.4f} \\\\ \n', ...               
%                 soa.(trackID).(measureID)  ... % Strength of association
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{Levene''s sfericity $\\text{p-value}_{\\text{Systems}} =$ %.4f} \\\\ \n', ...               
%                 sfericity.(trackID).(measureID)  ... % Sfericity p-value
%             );
%             
%         end; % track
%         
%         fprintf(fid, '\\hline\\hline \n');       
%         
%         fprintf(fid, '\\end{tabular} \n');
%         
%         fprintf(fid, '\\caption{%1$s. ANOVA table for GLMM of %2$s on TREC Ad-hoc collections.} \n', ...
%             EXPERIMENT.analysis.singleF.description, EXPERIMENT.measure.getFullName(m));
%         
%         fprintf(fid, '\\label{tab:singleF-ANOVA-table-%1$s} \n', measureShortName);
%         
%         fprintf(fid, '\\end{table} \n\n');
%         
%         % fprintf(fid, '\\end{landscape}  \n');
% 
% 
%     end; % measure
%     
%     
% 
%     
%     
%     fprintf(fid, '\\end{document}');
% 
%     fclose(fid);

     fprintf('\n\n######## Total elapsed time for printing summary report of the single factor analyses (%s): %s ########\n\n', ...
            EXPERIMENT.label.paper, elapsedToHourMinutesSeconds(toc(startComputation)));


    diary off;

end
