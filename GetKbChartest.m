%% Initialize screens and keyboards
%AssertOpenGL %compatible version of psychtoolbox with GL
KbName('UnifyKeyNames');
screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails
Screen('Preference','TextRenderer',0); %enlever pour windows
% Screen('Preference', 'TextRenderer', [enableFlag=0 (Legacy
% OS-specific), 1 = HighQ OS-specific (Default), 2 = Linux renderer
% plugin]);

%% To fit on every screen
rect= Screen(screenNumber, 'Rect');
resolution= Screen('Resolution', screenNumber);
hz=Screen('FrameRate', screenNumber); %creer une frequence dimage
couleur_ecran=[100 100 100];%Ecran gris
[windowPtr, rect]=Screen('OpenWindow',screenNumber, couleur_ecran);

%define center of screens
xCenter = round(rect(3)/2);
yCenter = round(rect(4)/2);

%% get a input
[ch, when] = GetKbChar([]);
message = '1022 - 13 :';
% replySubj = Ask(windowPtr, message, 255, 0, 'GetChar','center');
DrawFormattedText(windowPtr,'hey','center', 'center', 255);
Screen('Flip', windowPtr);

