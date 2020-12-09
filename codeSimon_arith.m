clear all
%% Ask for subject code
SubjectCode = input('Entrer le code du participant : ','s');
if isempty(SubjectCode)
    SubjectCode = 'trial';
end
%% Ask for operating system (Mac? Linux? Windows?)
OSType = input('Êtes-vous sur MacOS ? Y/N','s');
if strcmp(OSType,'Y') == 1
    Screen('Preference','TextRenderer',0);
end
% Screen('Preference', 'TextRenderer', [enableFlag=0 (Legacy
% OS-specific), 1 = HighQ OS-specific (Default), 2 = Linux renderer
% plugin]);

%% Ask for duration of the task in seconds
TaskDuration = str2num(input('Quelle est la durée de la tâche (secs)? [Défault = 300] : ','s'));
%% Initialize screens and keyboards
%AssertOpenGL %compatible version of psychtoolbox with GL
KbName('UnifyKeyNames');
escapeKey=KbName('ESCAPE');
screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails
%% To fit on every screen
rect= Screen(screenNumber, 'Rect');
% resolution= Screen('Resolution', screenNumber);
% hz=Screen('FrameRate', screenNumber); %creer une frequence dimage
couleur_ecran=[100 100 100];%Ecran gris
[windowPtr, rect] = Screen('OpenWindow',screenNumber, couleur_ecran);
%define center of screens
xCenter = round(rect(3)/2);
yCenter = round(rect(4)/2);
%% Instructions
Screen('TextSize', windowPtr, 20);
Inst_1 = ['Vous allez devoir effectuer une tâche arythmétique.',newline,'Prenez le chiffre 1022 et soustrayez 13, puis soustrayez encore 13, et ainsi de suite.',newline,'A chaque fois, vous n''aurez que 7.5 secondes pour repondre.',newline,newline,newline,newline,'Pour continuez, appuyer sur une touche'];
Inst_2 = ['Il est donc important que vous soyez rapide et précis, puisque s''il y a une erreur, vous devrez recommencer à 1022.',newline,newline,newline,newline,...
    'Appuyez sur Entree pour debuter'];
DrawFormattedText(windowPtr,Inst_1,'center', 'center', 255);
Screen('Flip', windowPtr);
KbTriggerWait(KbName('return'), []);
DrawFormattedText(windowPtr,Inst_2,'center', 'center', 255);
Screen('Flip', windowPtr);
KbTriggerWait(KbName('return'), []);
% %% Exit key
% [secs, keyCode, deltaSecs] = KbWait(-1,2);
% escapeKey=KbName('ESCAPE');
% [a, v, keyCode]=KbCheck;
% if any (keyCode(escapeKey));
% else
%     sca
% end
%% Training Session
Step = 17; %soustraction
MaxRT = 7.5; %temps de reponse maximum par trial
msg = ['Entrez votre reponse'];

count = 1078;
ii = 0;

StartExp = GetSecs;
try
    for ii = 1:TaskDuration
        
        GetSecs;
        %message de depart
        Screen('TextSize', windowPtr, 50);
        DrawFormattedText(windowPtr,[num2str(count) '-' num2str(Step)],'center', (yCenter-50), 255);
        Screen('Flip', windowPtr, [], 1);
        
        FlushEvents('keyDown'); % Flush GetChar queue to remove stale characters
        
        InitTimeResp = GetSecs;
        
        part_resp = str2num(GetEchoString2(windowPtr, msg,xCenter, yCenter, 255,[], 1, [],GetSecs+MaxRT));
        
        RT = GetSecs - InitTimeResp;
        
        
        if part_resp == (count-Step) % bonne réponse (green)
            color=[80 220 100];
            half_size_dot =5;
            count = count - Step;
        elseif part_resp ~= (count-Step) % mauvaise rep (rouge)
            color=[250 10 10];
            half_size_dot =50;
            count = 1022; % remet a neuf
        elseif (RT > MaxRT) % too late!
            color=[250 10 10];
            half_size_dot =50;
            count = 1022; % remet a neuf
        end
        
        fixRect = [xCenter-half_size_dot yCenter-half_size_dot xCenter+half_size_dot yCenter+half_size_dot];%positive feedback position (from run_subjective_features_v2.m from Simon)
        Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form
        Screen('Flip', windowPtr, [], []);
        WaitSecs(1); % feeback presented for 1sec
        
        FlushEvents('keyDown'); % Reset previous events
        % end
        
      
        
    end
catch ME
    sca;
end

data.PartResp = [data.PartResp, part_resp]
% data.Equation = [data.Equation, Equation]; % May be randomized : Equation = rand(1,nTrials)
data.Accuracy = [data.Accuracy, Accuracy];
data.ReactionTime = [];
data.PartResp = [];