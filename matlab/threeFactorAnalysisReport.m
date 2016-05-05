%% threeFactorAnalysisReport
% 
% Print the summary report of the three factors analyses and save them to a 
% tex file.
%
%% Synopsis
%
%   [] = threeFactorAnalysisReport(varargin)
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


function [] = threeFactorAnalysisReport(varargin)

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
    delete(EXPERIMENT.pattern.logFile.analysisReport(EXPERIMENT.analysis.threeF.name));
    diary(EXPERIMENT.pattern.logFile.analysisReport(EXPERIMENT.analysis.threeF.name));
    
    % start of overall computations
    startComputation = tic;
    
    fprintf('\n\n######## Printing summary report of the three factor analyses (%s) ########\n\n', EXPERIMENT.label.paper);
       

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
                    
                    anovaTableID = EXPERIMENT.pattern.identifier.anovaTable(EXPERIMENT.analysis.threeF.id, lugID, measureID);
                    anovaSoAID = EXPERIMENT.pattern.identifier.anovaSoA(EXPERIMENT.analysis.threeF.id, lugID, measureID);
                    
                    serload(EXPERIMENT.pattern.file.anova(trackID, EXPERIMENT.analysis.threeF.id, lugID, measureID), anovaTableID, anovaSoAID);
                    
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
    fid = fopen(EXPERIMENT.pattern.file.analysisReport(EXPERIMENT.analysis.threeF.name), 'w');


    fprintf(fid, '\\documentclass[11pt]{article} \n\n');

    fprintf(fid, '\\usepackage{amsmath}\n');
    fprintf(fid, '\\usepackage{multirow}\n');
    fprintf(fid, '\\usepackage{colortbl}\n');
    fprintf(fid, '\\usepackage{lscape}\n');
    fprintf(fid, '\\usepackage{pdflscape}\n');        
    fprintf(fid, '\\usepackage[x11names]{xcolor}\n');
    fprintf(fid, '\\usepackage[a3paper]{geometry}\n\n');
    

    fprintf(fid, '\\begin{document}\n\n');

    fprintf(fid, '\\title{Summary Report on Three Factors Analyses}\n\n');

    fprintf(fid, '\\maketitle\n\n');
    
    fprintf(fid, 'Tracks:\n');
    fprintf(fid, '\\begin{itemize}\n');
    
    % for each track
    for t = 1:tracks
        fprintf(fid, '\\item %s\n', EXPERIMENT.(varargin{t}).name);
    end;
    
    fprintf(fid, '\\end{itemize}\n');
    
    
        
   
    
    subTrackRows = 21;
    subLugRows = 7;
    
    % for each track
    for t = 1:tracks
        
        trackID = varargin{t};
        trackName = EXPERIMENT.(trackID).name;
        
        printFirstRow = true;
        
        fprintf(fid, '\\begin{landscape}  \n');
        fprintf(fid, '\\begin{table}[p] \n');
        % fprintf(fid, '\\tiny \n');
        fprintf(fid, '\\centering \n');
        % fprintf(fid, '\\vspace*{-12em} \n');
        fprintf(fid, '\\hspace*{-6.5em} \n');
        
        fprintf(fid, '\\begin{tabular}{|l|l|l|*{%d}{r|}} \n', EXPERIMENT.measure.number);
        
        fprintf(fid, '\\hline\\hline \n');
        
        fprintf(fid, '\\multicolumn{1}{|c}{\\textbf{Collection}} & \\multicolumn{1}{|c}{\\textbf{Lexical Units}} & \\multicolumn{1}{|c}{\\textbf{Effects}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c}{\\textbf{%s}} & \\multicolumn{1}{|c|}{\\textbf{%s}} \\\\  \n', ...
            EXPERIMENT.measure.getShortName(1), EXPERIMENT.measure.getShortName(2), EXPERIMENT.measure.getShortName(3), ...
            EXPERIMENT.measure.getShortName(4), EXPERIMENT.measure.getShortName(5));
        
        fprintf(fid, '\\hline \n');
        
        for lug = 1:EXPERIMENT.taxonomy.lug.number
                
                lugID = EXPERIMENT.taxonomy.lug.list{lug};                
                lugName = EXPERIMENT.taxonomy.(lugID).name;   
        
                if printFirstRow  % the header for the very first row of the table
                    fprintf(fid, ' \\multirow{%d}*{%s} & \\multirow{%d}*{%s} & $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', ...
                        subTrackRows, trackName , ...
                        subLugRows, lugName, ...
                        EXPERIMENT.taxonomy.stop.name);
                    
                    printFirstRow = false;
                else
                    fprintf(fid, '  & \\multirow{%d}*{%s} & $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', ...
                        subLugRows, lugName, ...
                        EXPERIMENT.taxonomy.stop.name);
                end;
                                
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    if anovaTable.(trackID).(measureID).(lugID){3, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, ' & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(lugID).omega2p.stop, ...
                            anovaTable.(trackID).(measureID).(lugID){3, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(lugID).omega2p.stop, ...
                            anovaTable.(trackID).(measureID).(lugID){3, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                fprintf(fid, '             &        &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.(lugID).name);
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    if anovaTable.(trackID).(measureID).(lugID){4, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, ' & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(lugID).omega2p.stem, ...
                            anovaTable.(trackID).(measureID).(lugID){4, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(lugID).omega2p.stem, ...
                            anovaTable.(trackID).(measureID).(lugID){4, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                fprintf(fid, '             &        &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.model.name);
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    if anovaTable.(trackID).(measureID).(lugID){5, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, ' & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(lugID).omega2p.model, ...
                            anovaTable.(trackID).(measureID).(lugID){5, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(lugID).omega2p.model, ...
                            anovaTable.(trackID).(measureID).(lugID){5, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                fprintf(fid, '            &         &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugID).name);
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    if anovaTable.(trackID).(measureID).(lugID){6, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, ' & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(lugID).omega2p.stop_stem, ...
                            anovaTable.(trackID).(measureID).(lugID){6, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(lugID).omega2p.stop_stem, ...
                            anovaTable.(trackID).(measureID).(lugID){6, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                fprintf(fid, '            &         &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.model.name);
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    if anovaTable.(trackID).(measureID).(lugID){7, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, ' & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(lugID).omega2p.stop_model, ...
                            anovaTable.(trackID).(measureID).(lugID){7, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(lugID).omega2p.stop_model, ...
                            anovaTable.(trackID).(measureID).(lugID){7, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                fprintf(fid, '           &          &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.(lugID).name, EXPERIMENT.taxonomy.model.name);
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    if anovaTable.(trackID).(measureID).(lugID){8, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, ' & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(lugID).omega2p.stem_model, ...
                            anovaTable.(trackID).(measureID).(lugID){8, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(lugID).omega2p.stem_model, ...
                            anovaTable.(trackID).(measureID).(lugID){8, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                fprintf(fid, '          &           &  $\\hat{\\omega}^2_{\\langle\\text{%s}\\times\\text{%s}\\times\\text{%s}\\rangle}$ ', EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.(lugID).name, EXPERIMENT.taxonomy.model.name);
                for m = 1:EXPERIMENT.measure.number
                    measureID = EXPERIMENT.measure.list{m};
                    
                    if anovaTable.(trackID).(measureID).(lugID){9, 7} <= EXPERIMENT.analysis.alpha
                        fprintf(fid, ' & %.4f (%.4f) ', ...
                            soa.(trackID).(measureID).(lugID).omega2p.stop_stem_model, ...
                            anovaTable.(trackID).(measureID).(lugID){9, 7} ...
                            );
                    else
                        fprintf(fid, ' & \\cellcolor{%s} %.4f (%.4f) ', ...
                            EXPERIMENT.analysis.notSignificantColor, ...
                            soa.(trackID).(measureID).(lugID).omega2p.stop_stem_model, ...
                            anovaTable.(trackID).(measureID).(lugID){9, 7} ...
                            );
                    end;
                end; % measure
                fprintf(fid, '\\\\ \n');
                
                fprintf(fid, '\\cline{2-8} \n');
                
        end;
        
        fprintf(fid, '\\hline \n');
        
         fprintf(fid, '\\hline \n');
    
    fprintf(fid, '\\end{tabular} \n');
    
    fprintf(fid, '\\caption{Summary of three factor models on %s. Each cell reports the estimated $\\omega^2$ SoA for the speficied effects and, within parentheses, the p-value for those effects.} \n', trackName);
    
    fprintf(fid, '\\label{tab:threeF-summary-%s} \n', trackID);
    
    fprintf(fid, '\\end{table} \n\n');
    
    fprintf(fid, '\\end{landscape}  \n');
        
    end; % track
    
    
   
    
    fprintf(fid, '\\end{document}');

    fclose(fid);


    
    
%     
%     
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
%                         
%             fprintf(fid, '\\hline\\hline \n');
%             fprintf(fid, '\\multicolumn{6}{|c|}{\\textbf{GLMM for %1$s -- Collection: %2$s}} \\\\ \n', measureShortName, EXPERIMENT.(trackID).name);
%             fprintf(fid, '\\hline \n');  
%             
%             fprintf(fid, '\\multicolumn{1}{|c}{\\textbf{Source}} & \\multicolumn{1}{|c}{\\textbf{SS}} & \\multicolumn{1}{|c}{\\textbf{DF}} & \\multicolumn{1}{|c}{\\textbf{MS}} & \\multicolumn{1}{|c}{\\textbf{F}} & \\multicolumn{1}{|c|}{\\textbf{p-value}} \\\\  \n');  
%             fprintf(fid, '\\hline \n');  
%             
%             fprintf(fid, '\\textbf{%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stop.name, ...
%                 anovaTable.(trackID).(measureID){3, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){3, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){3, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){3, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){3, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n');  
%             
%             fprintf(fid, '\\textbf{%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stem.name, ...
%                 anovaTable.(trackID).(measureID){4, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){4, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){4, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){4, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){4, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n');  
%             
%             fprintf(fid, '\\textbf{%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.model.name, ...
%                 anovaTable.(trackID).(measureID){5, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){5, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){5, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){5, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){5, 7}  ... % p-value
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
%             
%             fprintf(fid, '\\textbf{%s$\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.stem.name, ...
%                 anovaTable.(trackID).(measureID){9, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){9, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){9, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){9, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){9, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n');  
%             
%             fprintf(fid, '\\textbf{%s$\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.model.name, ...
%                 anovaTable.(trackID).(measureID){10, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){10, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){10, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){10, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){10, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n');  
%             
%             fprintf(fid, '\\textbf{%s$\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stem.name, EXPERIMENT.taxonomy.model.name, ...
%                 anovaTable.(trackID).(measureID){11, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){11, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){11, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){11, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){11, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stop.name, ...
%                 anovaTable.(trackID).(measureID){6, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){6, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){6, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){6, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){6, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stem.name, ...
%                 anovaTable.(trackID).(measureID){7, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){7, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){7, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){7, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){7, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.model.name, ...
%                 anovaTable.(trackID).(measureID){8, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){8, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){8, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){8, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){8, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\textbf{%s$\\times$%s$\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.stem.name, EXPERIMENT.taxonomy.model.name, ...
%                 anovaTable.(trackID).(measureID){15, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){15, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){15, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){15, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){15, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s$\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.stem.name, ...
%                 anovaTable.(trackID).(measureID){12, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){12, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){12, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){12, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){12, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s$\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.model.name, ...
%                 anovaTable.(trackID).(measureID){13, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){13, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){13, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){13, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){13, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n');
%             
%             fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s$\\times$%s} & %.4f & %d & %.4f & %.4f & %.4f \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stem.name, EXPERIMENT.taxonomy.model.name, ...
%                 anovaTable.(trackID).(measureID){14, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){14, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){14, 5}, ... % Mean Squares
%                 anovaTable.(trackID).(measureID){14, 6}, ... % F-value
%                 anovaTable.(trackID).(measureID){14, 7}  ... % p-value
%             );
%             fprintf(fid, '\\hline \n');
%             
%         
%             fprintf(fid, '\\textbf{Topics$^\\prime\\times$%s$\\times$%s$\\times$%s} & %.4f & %d & %.4f & -- & -- \\\\ \n', ...
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.stem.name, EXPERIMENT.taxonomy.model.name, ...
%                 anovaTable.(trackID).(measureID){16, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){16, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){16, 5} ... % Mean Squares
%             );
%             fprintf(fid, '\\hline \n');  
%         
%             fprintf(fid, '\\textbf{Error} & %.4f & %d & %.4f & -- & -- \\\\ \n', ...
%                 anovaTable.(trackID).(measureID){17, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){17, 3}, ... % Degrees of freedom
%                 anovaTable.(trackID).(measureID){17, 5}  ... % Mean Squares
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\textbf{Total} & %.4f & %d & -- & -- & -- \\\\ \n', ...
%                 anovaTable.(trackID).(measureID){18, 2}, ... % Sum of squares 
%                 anovaTable.(trackID).(measureID){18, 3}  ... % Degrees of freedom
%             );
%             fprintf(fid, '\\hline \n'); 
%             
%             fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}} =$ %.4f} \\\\ \n', ... 
%                 EXPERIMENT.taxonomy.stop.name, ...
%                 omega2.(trackID).(measureID).stop  ... % Strength of association
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}} =$ %.4f} \\\\ \n', ... 
%                 EXPERIMENT.taxonomy.stem.name, ...
%                 omega2.(trackID).(measureID).stem  ... % Strength of association
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}} =$ %.4f} \\\\ \n', ... 
%                 EXPERIMENT.taxonomy.model.name, ...
%                 omega2.(trackID).(measureID).model  ... % Strength of association
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}\\times\\text{%s}} =$ %.4f} \\\\ \n', ... 
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.stem.name, ...
%                 omega2.(trackID).(measureID).stop_stem  ... % Strength of association
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}\\times\\text{%s}} =$ %.4f} \\\\ \n', ... 
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.model.name, ...
%                 omega2.(trackID).(measureID).stop_model  ... % Strength of association
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}\\times\\text{%s}} =$ %.4f} \\\\ \n', ... 
%                 EXPERIMENT.taxonomy.stem.name, EXPERIMENT.taxonomy.model.name, ...
%                 omega2.(trackID).(measureID).stem_model  ... % Strength of association
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{$\\omega^2_{\\text{%s}\\times\\text{%s}\\times\\text{%s}} =$ %.4f} \\\\ \n', ... 
%                 EXPERIMENT.taxonomy.stop.name, EXPERIMENT.taxonomy.stem.name, EXPERIMENT.taxonomy.model.name, ...
%                 omega2.(trackID).(measureID).stop_stem_model  ... % Strength of association
%             );
%         
%         
%             fprintf(fid, '\\multicolumn{6}{|l|}{Levene''s sfericity $\\text{p-value}_{\\text{%s}} =$ %.4f} \\\\ \n', ...  
%                 EXPERIMENT.taxonomy.stop.name, ...
%                 sfericity.(trackID).(measureID).stop  ... % Sfericity p-value
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{Levene''s sfericity $\\text{p-value}_{\\text{%s}} =$ %.4f} \\\\ \n', ...  
%                 EXPERIMENT.taxonomy.stem.name, ...
%                 sfericity.(trackID).(measureID).stem  ... % Sfericity p-value
%             );
%             fprintf(fid, '\\multicolumn{6}{|l|}{Levene''s sfericity $\\text{p-value}_{\\text{%s}} =$ %.4f} \\\\ \n', ...  
%                 EXPERIMENT.taxonomy.model.name, ...
%                 sfericity.(trackID).(measureID).model  ... % Sfericity p-value
%             );
% 
%             fprintf(fid, '\\hline\\hline \n');       
% 
%             fprintf(fid, '\\end{tabular} \n');
% 
%             fprintf(fid, '\\caption{%1$s. ANOVA table for GLMM of %2$s on collection %3$s.} \n', ...
%                 EXPERIMENT.analysis.threeF.description, EXPERIMENT.measure.getFullName(m), EXPERIMENT.(trackID).name);
% 
%             fprintf(fid, '\\label{tab:threeF-ANOVA-table-%1$s-%2$s} \n', measureShortName, trackID);
% 
%             fprintf(fid, '\\end{table} \n\n');
% 
%             % fprintf(fid, '\\end{landscape}  \n');
% 
% 
%         end; % track
%         
% 
%     end; % measure
%     
%     

    
    fprintf('\n\n######## Total elapsed time for printing summary report of the three factors analyses (%s): %s ########\n\n', ...
            EXPERIMENT.label.paper, elapsedToHourMinutesSeconds(toc(startComputation)));


    diary off;

end
