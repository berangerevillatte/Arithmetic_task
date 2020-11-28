clear all

%% Initialize screens and keyboards
%AssertOpenGL %compatible version of psychtoolbox with GL
KbName('UnifyKeyNames');
screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails
%Screen('Preference','TextRenderer',0) %enlever pour windows
%% To fit on every screen
rect= Screen(screenNumber, 'Rect');
resolution= Screen('Resolution', screenNumber);
hz=Screen('FrameRate', screenNumber); %creer une frequence dimage
couleur_ecran=[100 100 100];%Ecran gris
[windowPtr, rect]=Screen('OpenWindow',screenNumber, couleur_ecran);
% Screen('Preference', 'TextRenderer', [enableFlag=0 (Legacy
% OS-specific), 1 = HighQ OS-specific (Default), 2 = Linux renderer plugin]);

%% Instructions
Screen('TextSize', windowPtr,50);
xCenter = round(rect(3)/2);
yCenter = round(rect(4)/2);

welcometext = ['Vous allez devoir effectuer une tâche arythmétique.',newline,'Prenez le chiffre 1022 et soustrayez 13, puis soustrayez encore 13, et ainsi de suite.',newline,'A chaque fois, vous n''aurez que 7.5 secondes pour repondre.',newline,newline,newline,newline,'Pour continuez, appuyer sur une touche'];

DrawFormattedText(windowPtr,welcometext,'center', 'center');
Screen('Flip', windowPtr);

[secs, keyCode, deltaSecs] = KbWait([], 2);

welcometext2 = ['Il est donc important que vous soyez rapide et précis, puisque s''il y a une erreur, vous devrez recommencer à 1022.',newline,newline,newline,newline,...
    'Cliquez sur la souris pour débuter la tâche'];
DrawFormattedText(windowPtr,welcometext2,'center', 'center');
Screen('Flip', windowPtr);

[secs, keyCode, deltaSecs] = KbWait([], 2);
% 
%This program waits for the user to press the return key
[secs, keyCode, deltaSecs] = KbWait(-1,2);
escapeKey=KbName('ESCAPE');
[a, v, keyCode]=KbCheck;
% if any (keyCode(escapeKey));
%     sca
% end


%% Calcul mental 
pas = 13;
duration_max = 7.5;

% DrawFormattedText(windowPtr,Equation_depart,'center', 'center');

msg = ['Entrez votre reponse'];

     Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,'1022-13','center', (yCenter-50));
    Screen('Flip', windowPtr, [], 1);
% [string,terminatorChar] = GetEchoString(window,msg,x,y,[textColor],[bgColor],[useKbCheck=0],[deviceIndex],[untilTime=inf],[KbCheck args...]);
part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, [0 0 0],[], 1, []));
%function chronometre = chrono(w, duration_max, x, y, color, textsize)
%chrono(w, duration_max, 300, 400, [255 0 0], 300);

% part_resp = input('1022-13 :');
message{1} = ['Bonne reponse'];
message{2} = ['Mauvaise reponse, veuillez recommencer du debut.'];
message{3} = ['Le temps est ecoule! veuillez recommencer du debut.'];
message{4} = ['1022-13'];

compteur = 1022;
%startSecs = GetSecs;
tic

while true 
b=toc;

if part_resp == compteur-13 & (duration_max-b) > 0  
   compteur=compteur-13;
   tic
   pot = 1;
   retour = message{pot};
   Screen('TextSize', windowPtr, 50);
   DrawFormattedText(windowPtr,retour,'center', 'center');
   Screen('Flip', windowPtr, [], []);
   WaitSecs(1);
  % part_resp = input([num2str(compteur) '-13 :']);   
   part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, [0 0 0],[], 1, []));
   

elseif  (duration_max-b) == 0 || (duration_max-b) < 0
    pot = 3;
    retour = message{pot};
    %part_resp = input([num2str(compteur) '-13 :']); 
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,retour,'center', 'center');
    Screen('Flip', windowPtr, [], []);
    WaitSecs(1);
    compteur = 1022;
    tic
    part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, [0 0 0],[], 1, []));

else 
    compteur = 1022;
    tic
    pot = 2;
    retour = message{pot};
   % part_resp = input([num2str(compteur) '-13 :']);
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,retour,'center', 'center');
    Screen('Flip', windowPtr, [], []);
    WaitSecs(1);
    pot = 4;
    retour = message{pot};
     Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,retour,'center', (yCenter-50));
    Screen('Flip', windowPtr, [], 1);
    part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, [0 0 0],[], 1, []));
    
    end
end
