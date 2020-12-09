clear all
%% Ask for subject code
SubjectCode = input('Entrer le code du participant : ','s');
if isempty(SubjectCode)
  SubjectCode = 'trial';
end
%% Ask for operating system (Mac? Linux? Windows?)
OSType = input('Êtes-vous sur MacOS ? [Y/N] ','s');
if strcmp(OSType,'Y') == 1
    Screen('Preference','TextRenderer',0);
end
% Screen('Preference', 'TextRenderer', [enableFlag=0 (Legacy
% OS-specific), 1 = HighQ OS-specific (Default), 2 = Linux renderer
% plugin]);

%% Ask for duration of the task in seconds
TaskDuration1 = str2num(input('Quelle est la durée de la tâche (secs)? [Défault = 300] : ','s'));

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
DrawFormattedText(windowPtr,Inst_1,'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2);

Inst_2 = ['Il est donc important que vous soyez rapide et précis, puisque s''il y a une erreur, vous devrez recommencer à 1022.',newline,newline,newline,newline,...
     'Appuyez sur une touche pour débuter l''entraînement'];
DrawFormattedText(windowPtr,Inst_1,'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2);

% %% Training Session
SaveData = 0;
StartCount = 1078;
Step = 17;
RT = 7.5;
TaskDuration = 20; % Default for training session
ArithFunction(windowPtr, xCenter, yCenter, TaskDuration, StartCount, Step, RT, SaveData);
WaitSecs(1);

% %% Transition message 

Inst_2 = ['Vous êtes maintenant prêt à passer à la tâche. Vos réponses seront enregistrées.',newline, newline,newline,newline,...
    'Appuyez sur une touche pour débuter la tâche.'];
Screen('TextSize', windowPtr, 20);
DrawFormattedText(windowPtr,Inst_2,'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2);
% 
%% Task
SaveData = 1;
StartCount = 1022;
Step = 13;
RT = 7.5;
ArithFunction(windowPtr, xCenter, yCenter, TaskDuration1, StartCount, Step, RT, SaveData);
WaitSecs(1);

%% Final Message
EndMsg = [' Epreuve terminée. '];
Screen('TextSize', windowPtr, 80);
DrawFormattedText(windowPtr,EndMsg,'center', 'center', 255);
Screen('Flip', windowPtr, [], 1);
WaitSecs(2);
sca

%% save data
% data.Answer(1,ii) = [AnswerMat];
Variables = ["Equation" "Participant response" "Accuracy" "Reaction Time"];
DataCollect = [EquationMat; PartRespMat; AnswerMat; ReactionTimeMat]';
DataFinal = [Variables; DataCollect];

if SaveData == 1
    FileName = [SubjectCode,'_trial_', datestr(now,'dd-mm-yyyy')]; 
elseif SaveData == 0
    FileName = [SubjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
end

xlswrite(FileName, DataFinal);
