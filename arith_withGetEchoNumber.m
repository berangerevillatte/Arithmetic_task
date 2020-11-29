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

% HideCursor;
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
part_resp = GetEchoNumber(windowPtr, msg, xCenter, yCenter, 255,[], 1, []);
%function chronometre = chrono(w, duration_max, x, y, color, textsize)
%chrono(w, duration_max, 300, 400, [255 0 0], 300);
% part_resp = input('1022-13 :');
message{1} = ['Bonne reponse'];
message{2} = ['Mauvaise reponse, veuillez recommencer du debut.'];
message{3} = ['Le temps est ecoule! veuillez recommencer du debut.'];

x = zeros(1,5); %create a vector of zeros (at least the min number of trials)
i = 0; %the first iteration starts at 0
compteur = 1022; 
i = 1:300; %maximum of trials, 1 per second for 5min (300 sec)
tic %startSecs = GetSecs;

while true
b=toc;

if part_resp == compteur-13 & (duration_max-b) > 0 % bonne réponsee
   compteur=compteur-13;
   x(i) = 1;
   i = i+1;
   
   tic
  
   Screen('TextSize', windowPtr, 50);
   DrawFormattedText(windowPtr,message{1},'center', 'center', 255);
   Screen('Flip', windowPtr, [], []);
   
   WaitSecs(1); % msg presented for 1sec
   
   part_resp = GetEchoNumber(windowPtr, msg, xCenter, yCenter, 255,[], 1, []);
   
   
elseif  (duration_max-b) == 0 || (duration_max-b) < 0 % temps écoulé

    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,message{3},'center', 'center', 255);
    Screen('Flip', windowPtr, [], []);
    
    WaitSecs(1); % msg presented for 1sec
    
    compteur = 1022;
    
    x(i) = 0;
    i = i+1;
    
    tic
    
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,'1022-13','center', (yCenter-50), 255);
    Screen('Flip', windowPtr, [], 1);
    part_resp = GetEchoNumber(windowPtr, msg, xCenter, yCenter, 255,[], 1, []);
   
else % mauvaise réponse ou réponse vide
    compteur = 1022;
    
    x(i) = 0;
    i = i+1;
    
    sca
    break;
    
    
    tic
  
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,message{2},'center', 'center', 255);
    Screen('Flip', windowPtr, [], []);
    WaitSecs(1);
   
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,'1022-13','center', (yCenter-50), 255);
    Screen('Flip', windowPtr, [], 1);
    part_resp = GetEchoNumber(windowPtr, msg, xCenter, yCenter, 255,[], 1, []);
 
   end
end

% ShowCursor;
x = x(1:i);

FileName = [SubjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
xlswrite(FileName, x);

