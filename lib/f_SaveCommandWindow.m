function f_SaveCommandWindow(fname_prefix)
%F_SAVECOMMANDWINDOW - Start recording the command window output to <fname_prefix>_date_time file.
%   in the "log_files" directory.
%
% SYNOPSIS: f_SaveCommandWindow(fname_prefix)
%
% Required files:
%
% EXAMPLES:
%
% REMARKS:
%
% See also 
%
% Copyright Tomy Aumont

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created with:
%   MATLAB ver.: 9.6.0.1214997 (R2019a) Update 6 on
%    Microsoft Windows 10 Home Version 10.0 (Build 17763)
%
% Author:     Tomy Aumont
% Work:       Center for Advance Research in Sleep Medicine
% Email:      tomy.aumont@umontreal.ca
% Website:    
% Created on: 08-May-2020
% Revised on:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Default output filename
diary_name = ['log_files' filesep datestr(now,'mmmm_dd_yyyy_HH-MM-SS')];

% ===== BUILD OUTPUT FILENAME =====
if nargin
    if ischar(fname_prefix)
        diary_name = ['log_files' filesep fname_prefix '_' datestr(now,'mmmm_dd_yyyy_HH-MM-SS')];
    else
        fprintf('WARNING: Input must be a character array. Saving log file to default: %s\n',diary_name)
    end
end

% ===== CREATE LOG FILES DIRECTORY =====
warning('off') % Silence warning if directory already exists
    try
        mkdir('log_files')
    catch
    end
warning('on') 

% ===== START RECORDING COMMAND WINDOW =====
% eval(['diary ' diary_filename]);
diary(diary_name)


callstack = dbstack(1);
fprintf('\nSCRIPT: %s on %s\n\n', callstack(1).file, date)
