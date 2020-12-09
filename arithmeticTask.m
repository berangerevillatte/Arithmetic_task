function arithmeticTask()
%% Ask for subject code
subjectCode = input('Entrer le code du participant : ','s');
if isempty(subjectCode)
  subjectCode = 'trial';
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
taskDuration = str2num(input('Quelle est la durée de la tâche (secs)? [Défault = 300] : ','s'));

%% Initialize screens and keyboards
AssertOpenGL %compatible version of psychtoolbox with GL
KbName('UnifyKeyNames');
screens=Screen('screens'); % locate screens
screenNumber=max(screens); % search secondary screen
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails

%% To fit on every screen
rect= Screen(screenNumber, 'Rect'); % Encodes the useable size of the window or screen.
screenColor=[100 100 100];% background screen color is grey
[windowPtr, rect] = Screen('OpenWindow',screenNumber, screenColor);

%define center of screens
xCenter = round(rect(3)/2);
yCenter = round(rect(4)/2);

%% Instructions
Screen('TextSize', windowPtr, 20);
instruct = ['Vous allez devoir effectuer une tâche arythmétique. Vous devrez :',newline, newline,newline,newline,...
    newline,'1. Soustraire un nombre d''un autre nombre',newline,...
    newline,'2. Vous souvenir du résultat, et soustraire encore 17, et ainsi de suite jusqu''à atteindre 0.',newline,newline,...
    '1078 - 17 ',newline,newline,'1061',newline,'1044',newline,'1027',newline,'...',newline,newline,...
    'A chaque fois, vous n''aurez que 7.5 secondes pour repondre.',newline,...
    'Il est donc important que vous soyez rapide et précis, puisque s''il y a une erreur, vous devrez recommencer au début.',...
    newline,newline,newline,newline,newline,newline,'Appuyez sur une touche pour débuter l''entraînement'];
instruct2 = ['Vous êtes maintenant prêt à passer à la tâche. Vos réponses seront enregistrées.',newline, newline,newline,newline,...
    'Appuyez sur une touche pour débuter la tâche.'];

%% Give instructions
DrawFormattedText(windowPtr,instruct,'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2); % Press any key to continue to next screen

%% Compute main session parameters
startCount = 1022; % Starting number for arithmetic task
step = 13; % step size subtraction
trialTout = 7.5; % max time allocated per trial
%% Initialize participant answer data structure
% Pre-allocate memory with max possible trials = Taks_duration in secs
data(1:taskDuration) = struct('step',NaN,'accuracy',NaN,'partResponse',NaN,'rt',NaN);
data(1).step = 1; % First trial is necessarily step 1. 
% answ.step : step # in chain of equations. After a wrong answer, step of next answer resets to 1
% answ.num : numerical response provided
% answ.rt : reaction time
% answ.isGood : logical value indicating whether the answer was correct

%% Initialize other variables
escIsDown = false;
isTaskTout = false;
taskTimer = 0; 
taskIni = GetSecs();
ntrials = 0; % Initialize count and iterations

%% Experiment loop
try
while (~isTaskTout && ~escIsDown) % Experiment loop
    ntrials = ntrials +1;
    [data, escIsDown] = ArithFunction2(data, windowPtr, xCenter, yCenter,ntrials, startCount, step, trialTout)
    %function [data, escIsDown] = ArithFunction2(data, windowPtr, x, y, ntrial, startCount, step, trialTout)
    taskTimer = GetSecs() - taskIni;% Update timer, check if time is up
    if (taskTimer >= taskDuration), isTaskTout = true; 
    end
end
    while (~isTaskTout && ~escIsDown) % Experiment loop
        ntrials = ntrials+1;
        [answ, escIsDown] = runTrial1(answ, windowPtr, ntrials, trialTout, nbIni, stepSize, msgs);
        %% Update timer, check if time is up
        taskTimer = GetSecs() - taskTini;
        if (taskTimer >= taskTout), isTaskTout = true; end
    end % Experiment while loop
    
    sca;
    ListenChar(0);
KbQueueRelease([]);

catch ME
    sca;
    ListenChar(0);
    KbQueueRelease([]);
end 

data = data(1:ntrials);
fileName = [subjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
%xlswrite(fileName, struct2table(data));
% %% Final Message
%  endMsg = [' Epreuve terminée. '];
%  Screen('TextSize', windowPtr, 80);
%  DrawFormattedText(windowPtr,endMsg,'center', 'center', 255);
%  Screen('Flip', windowPtr, [], 1);
%  WaitSecs(2);
% xlswrite(fileName, struct2table(dataFinal));
% sca
end
