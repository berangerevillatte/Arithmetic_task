function DrawSliderText(window, txt, xCoord, yCoord, txtPos, NumPixels)
%F_DRAW_SLIDERTEXT - Draw text somewhere around a slider using the PTB
%
% SYNOPSIS: f_Draw_SliderText(window, txt, xCoord, yCoord, txtPos, [NumPixels])
%
% INPUTS:
%      window - Window pointer as defined in the PTB
%         txt - text to display
%      xCoord - x-coordinate of the slider [left, right, center, center]
%      yCoord - y-coordinate of the slider [center, center, high, low]
%      txtPos - Location where to display the text: 'left', 'right', 'up', 'down'
%   NumPixels - Define the translation (in pixels) on the vertical axis from the point of interest.
%
% OUTPUTS:
%          -
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

xCenter = xCoord(3);
yCenter = yCoord(1);
[scrnW, scrnH] = Screen('WindowSize', window);
if ~isempty(txt)
    [normBoundsRect, ~] = Screen('TextBounds', window, txt, [], [], [], []);
else
    return
end
xMargin = 40;

if nargin < 6
    NumPixels = 100;
end

switch lower(txtPos)
    case 'left'
        Screen('DrawText', window, txt, xCoord(1) - normBoundsRect(3) - xMargin, yCenter - normBoundsRect(4)/2);

    case 'right'
        Screen('DrawText', window, txt, xCoord(2) + xMargin, yCenter - normBoundsRect(4)/2);

    case 'upleft-corner'
        Screen('DrawText', window, txt, 100, NumPixels);

    case 'upright-corner'
        Screen('DrawText', window, txt, scrnW - normBoundsRect(3) - xMargin, NumPixels);
    
    case 'downleft-corner'
        Screen('DrawText', window, txt, 100, scrnH - NumPixels);
    
    case 'downright-corner'
        Screen('DrawText', window, txt, scrnW - normBoundsRect(3) - xMargin, scrnH - NumPixels);

    case 'down-center'
        Screen('DrawText', window, txt, xCenter - (normBoundsRect(3)/2), yCenter + NumPixels);
    
    case 'down-left'
        Screen('DrawText', window, txt, xCoord(1), yCenter + NumPixels);

    case 'down-right'
        Screen('DrawText', window, txt, xCoord(2), yCenter + NumPixels);

    case 'up-center'
        Screen('DrawText', window, txt, xCenter - (normBoundsRect(3)/2), yCenter - NumPixels);
    
    case 'up-left'
        Screen('DrawText', window, txt, xCoord(1), yCenter - NumPixels);
    
    case 'up-right'
        Screen('DrawText', window, txt, xCoord(2), yCenter - NumPixels);

    otherwise
        warning([mfilename ' : Unknown position requested'])
end

