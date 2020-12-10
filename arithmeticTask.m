
function dataFinal = arithmeticTask()
%% Ask for subject code
subjectCode = input('Entrer le code du participant : ','s');
if isempty(subjectCode)
  subjectCode = 'trial';
end

%% Ask for operating system (Mac? Linux? Windows?)
OSType = input('Êtes-vous sur MacOS ? [Y/N] ','s');
if (strcmp(OSType,'Y')|| strcmp(OSType,'y')) == 1 
    Screen('Preference','TextRenderer',0);
end

%% Ask for duration of the task in seconds
taskDuration = str2num(input('Quelle est la durée de la tâche (secs)? : ','s'));

%% Initialize screens and keyboards
AssertOpenGL %compatible version of psychtoolbox with GL
screens=Screen('screens'); % locate screens
screenNumber=max(screens); % search secondary screen
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails

%% To fit on every screen
screenColor=[100 100 100];% background screen color is grey
[windowPtr, rect] = Screen('OpenWindow',screenNumber, screenColor);

%define center of screens
xCenter = round(rect(3)/2);
yCenter = round(rect(4)/2);

%% Give instructions
Screen('TextSize', windowPtr, 30);
msgs{1} = ['Vous allez devoir effectuer une tâche arithmétique.',newline, ...
    'Prenez le chiffre 1022 et soustrayez 13, puis soustrayez encore 13, et ainsi de suite.', ...
    newline,'À chaque fois, vous n''aurez que 7.5 secondes pour répondre.', ...
    newline,newline,newline,newline,'Pour continuer, appuyez sur une touche'];
DrawFormattedText(windowPtr,msgs{1},'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2); % Press any key to continue to next screen

msgs{2} = ['Il est donc important que vous soyez rapide et précis, puisque', ...
    ' s''il y a une erreur, vous devrez recommencer à 1022.',newline,newline,newline,newline, ...
    'Appuyez sur une touche pour débuter'];
DrawFormattedText(windowPtr,msgs{2},'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2); % Press any key to continue to next screen

%% Compute main session parameters
maxTrials = taskDuration; % Max number of trials a person could reasonably give within the time limit
startCount = 1022; % Starting number for arithmetic task
subtract = 13; % step size subtraction
trialTout = 7.5; % max time allocated per trial

%% Initialize participant answer data structure
data(1:maxTrials) = struct('Step',NaN,'Accuracy',NaN,'partResp',NaN,'RT',NaN);
data(1).Step = 1;

%% Initialize other variables
escIsDown = false;
isTaskTout = false;
taskTimer = 0; 
taskIni = GetSecs;
ntrials = 0; % Initialize count and iterations

%% Experiment loop
    while ~isTaskTout && ~escIsDown % Experiment loop
        ntrials = ntrials +1;
        [data,escIsDown] = arithTrials(data, windowPtr, xCenter, yCenter, ntrials, trialTout, startCount, subtract, msgs);
        %% Update Timer, check if task time is up    
        taskTimer = GetSecs - taskIni;% Update timer, check if time is up
        if (taskTimer >= taskDuration), isTaskTout = true; end
    end

endMsg = [' Epreuve terminée. '];
DrawFormattedText(windowPtr,endMsg,'center', 'center', 255);
Screen('Flip', windowPtr, [], []);
WaitSecs(2);

sca;
ListenChar(0); %  stop listening for keyboard input
KbQueueRelease([]); % Releases queue-associated resources

%% save data
fileName = [subjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
dataDir = [pwd filesep 'DATA' filesep];
if ~isfolder(dataDir), mkdir(dataDir); end 

matPath = fullfile(dataDir,sprintf('%s.mat', fileName));
excelPath = fullfile(dataDir, sprintf('%s.xlsx', fileName));

save(matPath, 'data'); 
writetable(struct2table(data), excelPath);

end