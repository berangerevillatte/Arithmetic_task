function [score, rt, playbackTime] = GetSliderFeedback(scaleLabel, scale_color, window, xCenter, yCenter, actionKeys, lang)
% function [score, rt, playbackTime] = f_Get_Slider_Feedback(scale_label, lang, window, xCenter, yCenter, StimHandle, repeatKey, notheardKey, nextKey, escapeKey, cancelKey, scale_color, waitShow)
%F_GET_SLIDER_FEEDBACK - Wait for sound stimulus to be done playing to collect slider score.
%
% SYNOPSIS: [score, rt] = f_Get_Slider_Feedback(scale_label, lang, window, xCenter, yCenter, StimHandle, repeatKey, notheardKey, nextKey)
%
% INPUTS:
%   scale_label - What the slider is measuring: 'unpleasantness' or 'intensity'
%          lang - Language to display text: 'fr' or 'en'
%        window - Window handle as define by the PTB
%       xCenter - center position of the window in pixels
%       yCenter - center position of the window in pixels (y-axis)
%    StimHandle - Handle on the sound playback
%     repeatKey - Keyboard key to repeat the stimulus playback
%   notheardKey - Keyboard key to state having not heard the stimulus
%
% OUTPUTS:
%         score - Score given on the scale, in percent (%)
%            rt - Reponse time
%  playbackTime - Time of stimulus playback
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

score = [];
rt = [];
playbackTime = [];

TextFontSize = 20;

% Slider properties
Cursor = [0 0 20 50];
rectColor = [166, 195, 222]; %blue
SizeLine = 300; % length of the feedback scale in pixels (positive xand negative)

% Scale lines positions (boundaries)
xLeft = xCenter - SizeLine;
xRight = xCenter + SizeLine;
xCoord = [xLeft, xRight, xCenter, xCenter]; % [ line1-x1, line1-x2, line2-x1, line2-x2 ]
yCoord = [yCenter, yCenter, yCenter + 20, yCenter - 20]; % [ line1-y1, line1-y2, line2-y1, line2-y2 ]
allCoords = [xCoord; yCoord];

% Scoring scale text in the desired language
[label_L, label_R, scale_title] = GetScaleLabel(scaleLabel, lang);

% Instruction text in the desired language
[cancel_instr, answer_instr, next_instr] = GetKbInstruct(lang, actionKeys);

% Initialize mouse in the center of the slider
SetMouse(xCenter, yCenter, window);
    
isValid = false;
NotEnd = true;
while ~isValid
while NotEnd

    % Get info from mouse and force at the moving slider height
    [xMouse, ~, buttons] = GetMouse(window);
    yMouse = yCenter;

    if xMouse < xLeft
        xMouse = xLeft;
        SetMouse(xMouse, yMouse, window);
    elseif xMouse > xRight
        xMouse = xRight;
        SetMouse(xMouse, yMouse, window);
    else
        SetMouse(xMouse, yMouse, window);
    end

    % Center current slider on x position of mouse
    Slider = CenterRectOnPointd(Cursor, xMouse, yMouse);

    % Draw slider lines (horizontal + vertical) and cursor
    Screen('DrawLines', window, allCoords, scale_color);
    Screen('FillRect', window, rectColor, Slider');

    % Draw slider text
    Screen('TextSize', window, TextFontSize);
    DrawSliderText(window, label_L, xCoord, yCoord, 'left');
    DrawSliderText(window, label_R, xCoord, yCoord, 'right');
    DrawSliderText(window, cancel_instr, xCoord, yCoord, 'down-center', 200);

    % Draw scale title
    DrawSliderText(window, scale_title, xCoord, yCoord, 'up-center', 200);

    % Check if mouse button pressed
    if sum(buttons) > 0
        % Participant feedback score...
        score = (xMouse - xLeft) / (SizeLine*2)*100; % in percent
        NotEnd = false;
    end

    if ~isempty(score)
        DrawSliderText(window, next_instr, xCoord, yCoord, 'down-center', 150)
    else
        DrawSliderText(window, answer_instr, xCoord, yCoord, 'down-center', 100)
    end

    Screen('Flip', window);

    % Wait for button to be released
    while sum(buttons) > 0
        [~, ~, buttons] = GetMouse(window);
    end       
    end
        
    [~, keyCode, ~] = KbWait([], 2);  
    [keyIsDown, ~, ~, ~] = KbCheck();

    if keyIsDown
        if lower(KbName(keyCode)) == lower(KbName(actionKeys.next))
            isValid = true;
        elseif lower(KbName(keyCode)) == lower(KbName(actionKeys.cancel))
            NotEnd = true;
        end
    end

end
end

