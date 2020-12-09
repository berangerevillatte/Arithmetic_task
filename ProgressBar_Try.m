clear all
%% Ask for subject code
SubjectCode = input('Entrer le code du participant : ','s');
if isempty(SubjectCode)
  SubjectCode = 'trial';
end
%% Ask for operating system (Mac? Linux? Windows?)
OSType = input('Quel type d''ordinateur utilisez-vous ? [Mac=M/Linux=L/Windows=W] ','s');
if strcmp(OSType,'M') == 1
    Screen('Preference','TextRenderer',0);
elseif strcmp(OSType,'L') == 1
    Screen('Preference','TextRenderer',2);
end
% Screen('Preference', 'TextRenderer', [enableFlag=0 (Legacy
% OS-specific), 1 = HighQ OS-specific (Default), 2 = Linux renderer
% plugin]);

%% Initialize screens and keyboards
%AssertOpenGL %compatible version of psychtoolbox with GL
KbName('UnifyKeyNames');
screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails

%% To fit on every screen
rect = Screen(screenNumber, 'Rect');
% resolution= Screen('Resolution', screenNumber);
% hz = Screen('FrameRate', screenNumber); %creer une frequence dimage
couleur_ecran = [87 87 87];%Ecran gris
% [windowPtr, rect]=Screen('OpenWindow',screenNumber, couleur_ecran);
windowPtr = Screen('OpenWindow',screenNumber, couleur_ecran);

%define center of screens
xCenter = round(rect(3)/2);
yCenter = round(rect(4)/2);

%% progress bar
%% Video
moviename = [ PsychtoolboxRoot 'PsychDemos/MovieDemos/ProgBar_Video.mov' ];

InitSecs = GetSecs;
part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter+300, 255,[], 1, [], GetSecs+MaxRT));
GetSecs;

RT = GetSecs - InitSecs;

% Open 'windowrect' sized window on screen, with black [0] background color:
% windowPtr = Screen('OpenWindow', 1, 0, rect/2);
movie = Screen('OpenMovie', windowPtr, moviename);% Open movie file
Screen('PlayMovie', movie, 1);% Start playback engine


 while ~KbCheck
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', windowPtr, movie);
        
        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end
        
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', windowPtr, tex);

        % Update display:
        Screen('Flip', windowPtr,[],1);

        % Release texture:
        Screen('Close', tex);
 end

% Stop playback:
Screen('PlayMovie', movie, 0);

% Close movie:
Screen('CloseMovie', movie);
    
% Close Screen, we're done:
sca;    

%% Images

FlushEvents('keyDown'); % Flush GetChar queue to remove stale characters

startexp = GetSecs;
part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+MaxRT));
GetSecs;
RT = GetSecs - startexp

ii = 0;
Startsecs = GetSecs;    
for ii = 1:0.5:7.5 
    
    xMax = (xCenter - 225) + ((ii)*60);
    
    fixRect2 = [xMax yCenter-300 xCenter+225 yCenter-290];
    Screen('fillRect', windowPtr, 255, fixRect2);
    Screen('flip', windowPtr, 1, 1);

    fixRect3 = [xCenter-225 yCenter-300 xMax yCenter-290];
    Screen('fillRect', windowPtr, [255 0 0], fixRect3);
    Screen('flip', windowPtr, 1, 1);
    WaitSecs(0.5);
    
    ii = ii + 1;
end

GetSecs;
BarDuration = GetSecs - Startsecs

WaitSecs(3);
sca