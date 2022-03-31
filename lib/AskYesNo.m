function resp = AskYesNo(question)
%ASKYESNO - Ask question until the answer is [y]es or [n]o (case insensitive)
%           Return lowercase 'yes' or 'no'. Also understands French [o]ui and [n]on.
% SYNOPSIS: resp = AskYesNo(question)
%
% INPUTS
%   question:   Support string formating compatible with sprintf. To use argument formating,
%               the formatted string and given argument must be in a cell array.
% Required files:
%
% EXAMPLES:
%   resp = AskYesNo('Is this example clear?');
%   resp = AskYesNo({'\tUse same directory for scoring files as recordings?\n\t--> "%s"',dirPath})
% 
% REMARKS:
%
% See also 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created with:
%    MATLAB ver.: 9.4.0.857798 (R2018a) Update 2 on
%    Linux 4.16.13-2-ARCH #1 SMP PREEMPT Fri Jun 1 18:46:11 UTC 2018 x86_64
%
% Author:     Tomy Aumont
% Work:       Centre de recherches avancees en medecine du sommeil (CEAMS), 
%              Hopital du Sacre-Coeur de Montreal.
% Email:      tomy.aumont@umontreal.ca
% Website:    www.ceams-carsm.ca
% Created on: 31-Aug-2018
% Revised on:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~iscell(question); question = {question}; end
while(true)
    answer = input([sprintf(question{:}) ' (y/n): '],'s');
    if strcmpi(answer,'y') || strcmpi(answer,'yes') || ...
            strcmpi(answer,'o') || strcmpi(answer,'oui')
        resp = 'yes';
        return
    elseif strcmpi(answer,'n') || strcmpi(answer,'no') || strcmpi(answer,'non')
        resp = 'no';
        return
    else
        fprintf(2,'  Answer must be "yes","no","oui" or "non"\n');
    end
end
