clear all

%% Ask for subject code
SubjectCode = input('Enter participant code: ','s');
if isempty(SubjectCode)
  SubjectCode = 'trial';
end

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

%% Instructions
Screen('TextSize', windowPtr, 20);

Inst_1 = ['Vous allez devoir effectuer une tâche arythmétique.',newline,'Prenez le chiffre 1022 et soustrayez 13, puis soustrayez encore 13, et ainsi de suite.',newline,'A chaque fois, vous n''aurez que 7.5 secondes pour repondre.',newline,newline,newline,newline,'Pour continuez, appuyer sur une touche'];
Inst_2 = ['Il est donc important que vous soyez rapide et précis, puisque s''il y a une erreur, vous devrez recommencer à 1022.',newline,newline,newline,newline,...
    'Appuyez sur Entree pour debuter'];

DrawFormattedText(windowPtr,Inst_1,'center', 'center', 255);
Screen('Flip', windowPtr);

[secs, keyCode, deltaSecs] = KbWait([], 2);


DrawFormattedText(windowPtr,Inst_2,'center', 'center', 255);
Screen('Flip', windowPtr);

[secs, keyCode, deltaSecs] = KbWait([], 2);
%
%This program waits for the user to press the return key
% [secs, keyCode, deltaSecs] = KbWait(-1,2);
% escapeKey=KbName('ESCAPE');
% [a, v, keyCode]=KbCheck;
% % if any (keyCode(escapeKey));
% %     sca
% end


%% Calcul mental
pas = 13; %soustraction
duration_max = 7.5; %temps de reponse maximum par trial
msg = ['Entrez votre reponse'];

%message de depart
Screen('TextSize', windowPtr, 50);
DrawFormattedText(windowPtr,'1022-13','center', (yCenter-50), 255);
Screen('Flip', windowPtr, [], 1);

% [string,terminatorChar] = GetEchoString(window,msg,x,y,[textColor],[bgColor],[useKbCheck=0],[deviceIndex],[untilTime=inf],[KbCheck args...]);
part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+duration_max));
%function chronometre = chrono(w, duration_max, x, y, color, textsize)
%chrono(w, duration_max, 300, 400, [255 0 0], 300);
% part_resp = input('1022-13 :');

message{1} = ['Bonne reponse'];
message{2} = ['Mauvaise reponse, veuillez recommencer du debut.'];
message{3} = ['Le temps est ecoule! veuillez recommencer du debut.'];

Task_duration = 300; % min 1sec
% answer = zeros(1,trials); %create a vector of zeros (at least the min number of trials)

startexp = GetSecs;
RT = GetSecs - startexp;
% timer

compteur = 1022; 
trials=0;
answer = zeros(1,trials); %create a vector of zeros (at least the min number of trials)
ReactionTime = zeros(1,trials)
part_data = zeros(2,trials);
part_data(1,:) = answer;
part_data(2,:) = ReactionTime;

ReactionTime(1,:) = RT;

for trials = 1:Task_duration
    trials = trials+1;

%     tic
%startSecs = GetSecs;

while true
    
GetSecs;
%chrono(windowPtr, duration_max, 300, 400, [255 0 0], 300);

if part_resp == compteur-13 & RT < duration_max % bonne réponse
    compteur=compteur-13;
    answer(trials) = 1;
    fixRect = [xCenter-5 yCenter-5 xCenter+5 yCenter+5];%positive feedback position (from run_subjective_features_v2.m from Simon)
    Screen('FillOval', windowPtr, [80 220 100], fixRect);%positive feedback color and oval form
    Screen('Flip', windowPtr, [], []);
    WaitSecs(1); % feeback presented for 1sec
    FlushEvents('keyDown');
    startexp;
%     tic
    part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+duration_max));
    GetSecs;
    RT;
    
elseif part_resp ~= compteur-13 & RT < duration_max % mauvaise rep
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,message{2},'center', 'center', 255);
    Screen('Flip', windowPtr, [], []);
    WaitSecs(1); % msg presented for 1sec
    compteur = 1022;
    answer(trials) = 0;
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,'1022-13','center', (yCenter-50), 255);
    Screen('Flip', windowPtr, [], 1);
    FlushEvents('keyDown');
%     tic
    startexp;
    part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+duration_max));
    GetSecs;
    RT;
    
elseif (isempty(part_resp)) & RT < duration_max
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,message{2},'center', 'center', 255);
    Screen('Flip', windowPtr, [], []);
    WaitSecs(1); % msg presented for 1sec
    compteur = 1022;
    answer(trials) = 0;
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,'1022-13','center', (yCenter-50), 255);
    Screen('Flip', windowPtr, [], 1);
    FlushEvents('keyDown');
    startexp;
%     tic
    part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+duration_max));
    GetSecs;
    RT;

    
else % mauvaise réponse ou réponse vide
    compteur = 1022;
    answer(trials) = 0;
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,message{3},'center', 'center', 255);
    Screen('Flip', windowPtr, [], []);
    WaitSecs(1);
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,'1022-13','center', (yCenter-50), 255);
    Screen('Flip', windowPtr, [], 1);
    FlushEvents('keyDown');
    startexp;
%     tic
    part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+duration_max));
    GetSecs;
    RT;

   end
end
end

sca;

part_data
answer = answer(1:trials)
FileName = [SubjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
xlswrite(FileName, answer);