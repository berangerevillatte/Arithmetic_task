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
couleur_ecran = [100 100 100];%Ecran gris
% [windowPtr, rect]=Screen('OpenWindow',screenNumber, couleur_ecran);
windowPtr = Screen('OpenWindow',screenNumber, couleur_ecran);

StartSecs = GetSecs;
RTMax = 7.5;

%% Print to screen
printTimer(windowPtr,trialTimer,RTMax);

Screen('TextSize', windowPtr, 50);
DrawFormattedText(windowPtr,output, 'center', 'center');
    if answ(ntrial).step == 1    %% Print equation
        DrawFormattedText(windowPtr,eqStr,'center', (yCenter-200), 255);
    end
Screen('Flip', windowPtr, [], []);

%% Update timer, check if time is up
trialTimer = GetSecs - StartSecs;
if (trialTimer >= RTMax), isTrialTout = true; end

function printTimer(windowPtr,trialTimer,trialTout)
% Adds a progress bar showing the time left in the frame buffer of windowPtr
    rectColor = [256,0,0];
    penWidth = 5;
    rectW = 300;
    rectH = 50;
    rectWtime = round(rectW*(trialTimer/trialTout));
    rectOutline = [0, 0, rectW, rectH];
    rectProgress = [0, 0, rectWtime, rectH];
    Screen('FrameRect', windowPtr, rectColor, rectOutline, penWidth);
    Screen('FillRect', windowPtr, rectColor, rectProgress);
end
% %% Fonction ancienne
%  FlushEvents('keyDown'); % Flush GetChar queue to remove stale characters
% 
% startexp = GetSecs;
% part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+MaxRT));
% GetSecs;
% RT = GetSecs - startexp
% 
% ii = 0;
% Startsecs = GetSecs;    
% for ii = 1:0.5:7.5 
%     
%     xMax = (xCenter - 225) + ((ii)*60);
%     
%     fixRect2 = [xMax yCenter-300 xCenter+225 yCenter-290];
%     Screen('fillRect', windowPtr, 255, fixRect2);
%     Screen('flip', windowPtr, 1, 1);
% 
%     fixRect3 = [xCenter-225 yCenter-300 xMax yCenter-290];
%     Screen('fillRect', windowPtr, [255 0 0], fixRect3);
%     Screen('flip', windowPtr, 1, 1);
%     WaitSecs(0.5);
% end
% 
% GetSecs;
% BarDuration = GetSecs - Startsecs
% 
% WaitSecs(3);
% sca