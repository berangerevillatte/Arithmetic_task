clear all

%% Initialize screens and keyboards
%AssertOpenGL %compatible version of psychtoolbox with GL
KbName('UnifyKeyNames');
screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails
Screen('Preference','TextRenderer',0)

%To fit on every screen
rect= Screen(screenNumber, 'Rect');
resolution= Screen('Resolution', screenNumber);
hz=Screen('FrameRate', screenNumber); %creer une frequence dimage
couleur_ecran=[255 160 160];%Ecran gris
[windowPtr, rect]=Screen('OpenWindow',screenNumber, couleur_ecran);
% Screen('Preference', 'TextRenderer', [enableFlag=0 (Legacy OS-specific), 1 = HighQ OS-specific (Default), 2 = Linux renderer plugin]);
msg = 'Bravo BB t''es trop forte!';

[clicks,whichButton] = GetClicks([windowPtr]);
if clicks == 1
    DrawFormattedText(windowPtr,msg,'center', 'center');
    Screen('flip',windowPtr);
end