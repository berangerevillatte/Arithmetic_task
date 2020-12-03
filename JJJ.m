clear all
%% Ask for subject code
SubjectCode = input('Entrer le code du participant : ','s');
if isempty(SubjectCode)
  SubjectCode = 'trial';
end
%% Ask for operating system (Mac? Linux? Windows?)
OSType = input('Quel type d''OS utilisez-vous ? [Mac=M/Linux=L/Windows=W] ','s');
if strcmp(OSType,'M') == 1
    Screen('Preference','TextRenderer',0);
elseif strcmp(OSType,'L') == 1
    Screen('Preference','TextRenderer',2);
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

%% Exit key
[secs, keyCode, deltaSecs] = KbWait(-1,2);
escapeKey=KbName('ESCAPE');
[a, v, keyCode]=KbCheck;
if any (keyCode(escapeKey));
else
    sca
end

%% Training Session
ArithFunction(TaskDuration, StartCount, Step, RT)
WaitSecs(1);
%% Transition msg
EndMsg = ['Vous êtes maintenant prêt. Vous avez à présent 5 minutes pour arriver à 0.',newline,newline,newline,...
    'Appuyer sur "Entrer" pour commencer la tâche'];
Screen('TextSize', windowPtr, 30);
DrawFormattedText(windowPtr,EndMsg,'center', 'center', 255);
Screen('Flip', windowPtr);

KbTriggerWait(KbName('return'), []);

%% Calcul mental 
Step = 13; %soustraction
MaxRT = 7.5; %temps de reponse maximum par trial
msg = ['Entrez votre reponse'];

%function chronometre = chrono(w, duration_max, x, y, color, textsize)
%chrono(w, duration_max, 300, 400, [255 0 0], 300);
% part_resp = input('1022-13 :');
% message{1} = ['Bonne reponse'];
message{2} = ['Mauvaise reponse, veuillez recommencer du debut.'];
message{3} = ['Le temps est ecoule! veuillez recommencer du debut.'];

% Create empty structures to store data
data = struct;
data.Equation = [];
data.Answer = [];
data.ReactionTime = [];
data.PartResp = [];

% Create matrix to store data
EquationMat = strings(1,TaskDuration); 
AnswerMat = zeros(1,TaskDuration);
ReactionTimeMat = zeros(1,TaskDuration);
PartRespMat = zeros(1,TaskDuration);


% Initialize count and iterations
count = 1022; 
ii = 0;
RespIndicator = min(PartRespMat);
% Initialize time for each trials and total experimentation
InitTimeResp = GetSecs;
StartExp = GetSecs;    

for ii = 1:TaskDuration
 
    GetSecs;
    %message de depart
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,[num2str(count) '-' num2str(Step)],'center', (yCenter-50), 255);
    Screen('Flip', windowPtr, [], 1);
    
    FlushEvents('keyDown'); % Flush GetChar queue to remove stale characters
    
    Screen('TextSize', windowPtr, 30);
    DrawFormattedText(windowPtr,num2str(RespIndicator),'right', (yCenter-300), 255);
    Screen('Flip', windowPtr, [], 1);
    
    InitTimeResp = GetSecs;
    part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+MaxRT));
    GetSecs;
    RT = GetSecs - InitTimeResp;
    
%     ii = ii+1;
    
    while (GetSecs - StartExp) < TaskDuration

    % GetSecs;
        if part_resp == (count-Step) % bonne réponse

            % Save data in matrices
            AnswerMat(ii) = 1;
            ReactionTimeMat(ii) = RT;
            PartRespMat(ii) = part_resp;
            EquationMat(ii) = [num2str(count) '-' num2str(Step)] ;

            % positive feedback on screen
            fixRect = [xCenter-5 yCenter-5 xCenter+5 yCenter+5];%positive feedback position (from run_subjective_features_v2.m from Simon)
            Screen('FillOval', windowPtr, [80 220 100], fixRect);%positive feedback color and oval form
            Screen('Flip', windowPtr, [], []);
            WaitSecs(1); % feeback presented for 1sec

            FlushEvents('keyDown'); % Reset previous events
            
            % Show best response indicator
            Screen('TextSize', windowPtr, 30);
            DrawFormattedText(windowPtr,num2str(RespIndicator),xCenter+300, yCenter-300, 255);
            Screen('Flip', windowPtr, [], 1);
            
            % Record reaction time
            InitTimeResp = GetSecs;
            part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+MaxRT));
            GetSecs;
            RT = GetSecs - InitTimeResp;

            % Go to next iteration and reset count
            ii = ii+1;
            count = count - Step;


        elseif part_resp ~= (count-Step) % mauvaise rep

            % Save data in matrices
            AnswerMat(ii) = 0;
            ReactionTimeMat(ii) = RT;
            PartRespMat(ii) = part_resp;
            EquationMat(ii) = [num2str(count) '-' num2str(Step)] ;

            % negative feedback on screen
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr,message{2},'center', 'center', 255);
            Screen('Flip', windowPtr, [], []);
            WaitSecs(1); % msg presented for 1sec

            % Returns the first input string
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr,[num2str(count) '-' num2str(Step)],'center', (yCenter-50), 255);
            Screen('Flip', windowPtr, [], 1);

            FlushEvents('keyDown'); % reset all events
            
            % Show best response indicator
            RespIndicator = min(PartRespMat);
            Screen('TextSize', windowPtr, 30);
            DrawFormattedText(windowPtr,num2str(RespIndicator),xCenter+300, yCenter-300, 255);
            Screen('Flip', windowPtr, [], 1);

            % Record reaction time
            InitTimeResp = GetSecs;
            part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+MaxRT));
            GetSecs;
            RT = GetSecs - InitTimeResp;

            % Go to next iteration and reset count
            ii = ii+1;
            count = 1022;


        elseif (isempty(part_resp)) & (RT < MaxRT) %empty response 

            ReactionTimeMat(ii) = NaN;
            AnswerMat(ii) = 0;
            PartRespMat(ii) = NaN;
            EquationMat(ii) = [num2str(count) '-' num2str(Step)] ;

            % Negative feedback on screen
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr,message{2},'center', 'center', 255);
            Screen('Flip', windowPtr, [], []);
            WaitSecs(1); % feedback presented for 1sec

            % Reinitilize count
            count = 1022;

            % Returns the first input string
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr,[num2str(count) '-' num2str(Step)],'center', (yCenter-50), 255);
            Screen('Flip', windowPtr, [], 1);

            FlushEvents('keyDown');
           
            % Show best response indicator
            RespIndicator = min(PartRespMat);
            Screen('TextSize', windowPtr, 30);
            DrawFormattedText(windowPtr,num2str(RespIndicator),xCenter+300, yCenter-300, 255);
            Screen('Flip', windowPtr, [], 1);
            
            % Ask for response
            InitTimeResp = GetSecs;
            part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+MaxRT));
            GetSecs;
            RT = GetSecs - InitTimeResp;

            % Go to next iteration and reset count
            ii = ii+1;
            count = 1022;

        else % Timeout

            ReactionTimeMat(ii) = 7.50;
            AnswerMat(ii) = 0;
            PartRespMat(ii) = NaN;
            EquationMat(ii) = [num2str(count) '-' num2str(Step)] ;

            % Negative feedback on screen
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr,message{3},'center', 'center', 255);
            Screen('Flip', windowPtr, [], []);
            WaitSecs(1); % feedback presented for 1sec

            % Reinitialize count
            count = 1022;

            % Returns the first input string
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr,[num2str(count) '-' num2str(Step)],'center', (yCenter-50), 255);
            Screen('Flip', windowPtr, [], 1);

            FlushEvents('keyDown'); % reset all events
            
            % Show best response indicator
            RespIndicator = min(PartRespMat);
            Screen('TextSize', windowPtr, 30);
            DrawFormattedText(windowPtr,[num2str(RespIndicator) ' ' ,newline,'Résultat moyen des participants : 8'],xCenter+300, yCenter-300, 255);
            Screen('Flip', windowPtr, [], 1);

            % Ask for response
            InitTimeResp = GetSecs;
            part_resp = str2num(GetEchoString2(windowPtr, msg, xCenter, yCenter, 255,[], 1, [], GetSecs+MaxRT));
            GetSecs;
            RT = GetSecs - InitTimeResp;

            % Go to next iteration and reset count
            ii = ii+1;
            count = 1022;

        end
    end
    
break;
end

%% Final Message
EndMsg = [' GAME OVER !'];
Screen('TextSize', windowPtr, 150);
DrawFormattedText(windowPtr,EndMsg,'center', 'center', 255);
Screen('Flip', windowPtr, [], 1);
WaitSecs(3);
sca

RespIndicator
%% Save into excel file
% Will probably save in .csv for Mac users
Variables = ["Equation" "Participant response" "Accuracy" "Reaction Time"];
DataCollect = [EquationMat; PartRespMat; AnswerMat; ReactionTimeMat]';
DataFinal = [Variables; DataCollect];
FileName = [SubjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
xlswrite(FileName, DataFinal);
