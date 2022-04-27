function secs = f_Wait_KbKeyPress(targetKey)
%F_WAIT_KBKEYPRESS - Uses PTB functions to wait for a specific keyboard press and return the 
%                    press time as obtained by GetSecs()
%
% SYNOPSIS: secs = f_Wait_KbKeyPress(targetKey)
%
% INPUTS:
%  targetKey - Keyboard key index obtained by KbName() corresponding to the desired key
%
% OUTPUTS:
%       secs - high precision time of key press as obtained by GetSecs()
%
% Required files:
%
%
% EXAMPLES:
%
%
% REMARKS:
%
% See also 
%
% Copyright Tomy Aumont

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created with:
%   MATLAB ver.: 9.11.0.1769968 (R2021b) on
%    Microsoft Windows 10 Home Version 10.0 (Build 19042)
%
% Author:     Tomy Aumont
% Work:       
% Email:      tomy.aumont@umontreal.ca
% Website:    
% Created on: 26-Oct-2021
% Revised on:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while 1
    [~, secs, keyCode] = KbCheck;
    if any(keyCode(targetKey))
        break
    end
end

%Wait release of key before continuing
KbWait([], 1, []);

