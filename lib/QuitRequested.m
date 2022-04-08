function quitFlag = QuitRequested(targetKeyCode)
% QUITREQUESTED - Check if the targetKey has been pressed
%
% SYNOPSIS: quitFlag = QuitRequested(targetKeyCode)
%
% INPUTS:
%    targetKeyCode - Keycode associated with the desired quit button
%
% OUTPUTS:
%         quitFlag - (logical) defines if the quit button has been pressed or not
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
%   MATLAB ver.: 9.11.0.1873467 (R2021b) Update 3 on
%    Microsoft Windows 10 Home Version 10.0 (Build 19042)
%
% Author:     Tomy Aumont
% Work:       
% Email:      tomy.aumont@umontreal.ca
% Website:    
% Created on: 07-Apr-2022
% Revised on:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[~,~, keyCode] = KbCheck();
quitFlag = keyCode(targetKeyCode);
if quitFlag
    % Wait release of key before continuing
    KbWait([], 1, []);
end

