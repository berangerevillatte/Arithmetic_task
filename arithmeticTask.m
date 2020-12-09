function dataFinal = arithmeticTask()
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
% KbName('UnifyKeyNames');
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
Screen('TextSize', windowPtr, 30);
instruct = ['Vous allez devoir effectuer une tâche arithmétique.',newline, ...
    'Prenez le chiffre 1022 et soustrayez 13, puis soustrayez encore 13, et ainsi de suite.', ...
    newline,'À chaque fois, vous n''aurez que 7.5 secondes pour répondre.', ...
    newline,newline,newline,newline,'Pour continuer, appuyez sur une touche'];
instruct2 = ['Il est donc important que vous soyez rapide et précis, puisque', ...
    ' s''il y a une erreur, vous devrez recommencer à 1022.',newline,newline,newline,newline, ...
    'Appuyez sur une touche pour debuter'];
instructTout = ['Le temps est ecoule! veuillez recommencer du debut.'];
%% Keyboard
KbName('UnifyKeyNames');
kbDevID = []; 
%KbName PTB3 : In the case of labels such as “5”, which appears on two keys, the name “5” designates the “5” key on the numeric keypad and “5%” designates the QWERTY “5” key.
possibleKeys = [KbName('ESCAPE'),KbName('RETURN'), KbName('BackSpace'), KbName('1'),KbName('1!'), ...
    KbName('2'),KbName('2@'),KbName('3'),KbName('3#'),KbName('4'),KbName('4$'), ...
    KbName('5'),KbName('5%'),KbName('6'),KbName('6^'),KbName('7'),KbName('7&'), ...
    KbName('8'),KbName('8*'),KbName('9'),KbName('9('),KbName('0'),KbName('0)'),];
keyList = zeros(256,1); %https://stackoverflow.com/questions/45961412/using-kbqueuecheck-to-continuously-check-for-device-input
keyList(possibleKeys) = 1;

%% Give instructions
DrawFormattedText(windowPtr,instruct,'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2); % Press any key to continue to next screen
DrawFormattedText(windowPtr,instruct2,'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2); % Press any key to continue to next screen

%% Compute main session parameters
startCount = 1022; % Starting number for arithmetic task
step = 13; % step size subtraction
trialTout = 7.5; % max time allocated per trial
%% Initialize participant answer data structure
% Create matrix to store data
stepMat = NaN(1,taskDuration); % step # in chain of equations. After a wrong answer, step of next answer resets to 1
stepMat(1) = 1; % First trial is necessarily step 1.
partRespMat = NaN(1,taskDuration); % numerical response provided
accuracyMat = NaN(1,taskDuration); %logical value indicating whether the answer is correct
reactionTimeMat = NaN(1,taskDuration); %reaction time

%% Initialize other variables
escIsDown = false;
isTaskTout = false;
taskTimer = 0; 
taskIni = GetSecs();
ntrials = 0; % Initialize count and iterations

%% Experiment loop
try
    while (taskTimer < taskDuration) && ~escIsDown % Experiment loop
        ntrials = ntrials +1;
      
        % Initialize time for total experimentation
        responseTime = 0;
        GetSecs;

        ListenChar(-1); % Allows concurrent use of ListenChar for character suppression, while at the same time using keyboard queues for character and key input.
        KbQueueCreate(kbDevID, keyList); % Only capture keys specified in keyList
        
        temp = [];
        enterIsDown = false;
        escIsDown = false;
        isTrialTout = false;
        
        KbQueueStart();
        
        trialTimer = 0;
        trialTini = GetSecs(); % Initialize time for each trials
        
        startEquation = sprintf('%d - %d', startCount, step);

        while (~isTrialTout && ~enterIsDown && ~escIsDown) %loop to get keyboard string input
            [pressed,firstPress,~,~,~] = KbQueueCheck();  %iskeyDown? creates a vector of pressed keys
            if pressed %if a key is pressed
                whichKey = lower(KbName(find(firstPress, 1))); %which key was first pressed in the keyList
                switch whichKey
                    case 'escape'
                        escIsDown = true; % ends the while loop and the experiment
                        KbQueueRelease();
                    case 'return'
                        enterIsDown = true; % ends the while loop and goes to feedback
                        KbQueueRelease();
                    case 'delete' % backspace
                        if ~isempty(temp) % as in GetEchoString to erase numbers
                            temp = temp(1:length(temp)-1);
                        end
                    case {'1', '1!'}
                        temp = [temp '1'];
                    case {'2', '2@'}
                        temp = [temp '2'];
                    case {'3', '3#'}
                        temp = [temp '3'];
                    case {'4', '4$'}
                        temp = [temp '4'];
                    case {'5', '5%'}
                        temp = [temp '5'];
                    case {'6', '6^'}
                        temp = [temp '6'];
                    case {'7', '7&'}
                        temp = [temp '7'];
                    case {'8', '8*'}
                        temp = [temp '8'];
                    case {'9', '9('}
                        temp = [temp '9'];
                    case {'0', '0)'}
                        temp = [temp '0'];
                    otherwise
                        error ('not a valid number');
                end
            end
            
            %% Print string number to screen
            output = [' ', temp] % as in GetEchoString
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr, output, 'center', 'center', 255);
           if stepMat(ntrials) == 1 %% Print starting equation
            DrawFormattedText(windowPtr,startEquation,'center', (yCenter-50), 255);
            end
            Screen('Flip', windowPtr, [], []);
            
            trialTimer = GetSecs() - trialTini; % Update timer, check if time is up
            if (trialTimer >= trialTout), isTrialTout = true; end
        end
        
        %% Feedback and recording of data
        % check accuracy
        
        goodAnsw = startCount - stepMat(ntrials)*step;
        if isTrialTout % Ran out of time before giving answer
            stepMat(ntrials+1) = 1; % Start from beginning
            accuracyMat(ntrials)   = false;
            reactionTimeMat(ntrials) = NaN;
            DrawFormattedText(windowPtr,instructTout,'center', 'center', 255);        % Time out feedback on screen
        elseif enterIsDown && (str2double(temp) ~= goodAnsw) % Gave wrong answer
            stepMat(ntrials+1) = 1; % Start from beginning
            accuracyMat(ntrials) = false;
            reactionTimeMat(ntrials) = trialTimer;
            partRespMat(ntrials) = str2double(temp);
            % negative feedback on screen
            color=[250 10 10];
            halfSizeDot =50;
            fixRect = [xCenter-halfSizeDot yCenter-halfSizeDot xCenter+halfSizeDot yCenter+halfSizeDot];
            Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form
        elseif enterIsDown && (str2double(temp) == goodAnsw)
            stepMat(ntrials+1) = stepMat(ntrials) + 1;
            accuracyMat(ntrials) = true;
            reactionTimeMat(ntrials) = trialTimer;
            partRespMat(ntrials) = str2double(temp);
            % positive feedback on screen
            color=[80 220 100];
            halfSizeDot = 5;
            fixRect = [xCenter-halfSizeDot yCenter-halfSizeDot xCenter+halfSizeDot yCenter+halfSizeDot];
            Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form
        end
        Screen('Flip', windowPtr, [], []);
        WaitSecs(1);     
          
    taskTimer = GetSecs() - taskIni;% Update timer, check if time is up
    if (taskTimer >= taskDuration), isTaskTout = true;
    end
    
    end
  
catch ME
    ListenChar(0); %  stop listening for keyboard input
    KbQueueRelease([]); % Releases queue-associated resources
end

endMsg = [' Epreuve terminée. '];
DrawFormattedText(windowPtr,endMsg,'center', 'center', 255);
Screen('Flip', windowPtr, [], []);
WaitSecs(2);

sca;
ListenChar(0); %  stop listening for keyboard input
KbQueueRelease([]); % Releases queue-associated resources

%% save data
dataLabels = ["Equation" "Participant response" "Accuracy" "Reaction Time"];
dataCollect = [stepMat; partRespMat; accuracyMat; reactionTimeMat]';
dataFinal = [dataLabels; dataCollect];
fileName = [subjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
save((sprintf('DATA/%s.mat', fileName)), 'dataFinal');
xlswrite((sprintf('DATA/%s.xls', fileName)), dataFinal);
end

