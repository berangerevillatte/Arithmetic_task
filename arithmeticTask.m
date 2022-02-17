
function dataFinal = arithmeticTask()
%% This silent arithmetic task has been developed as an effective stressor for EEG or every experiment where 
% participants have to remain still and silent (2020)
%
% For more information, see README.md file at https://github.com/berangerevillatte/Arithmetic_task
%
% authors : Berangere Villatte <berangere.villatte@umontreal.ca>, Charlotte Bigras <charlotte.bigras@umontreal.ca> 
% & Frederik Desaulniers <frederik.desaulniers@umontreal.ca>

clear all;
%% Ask for language preference
language = input('English / Français ? [E/F] ','s');
if (strcmp(language,'E')|| strcmp(language,'e')) == 1 
    inEnglish = 1;
else
    inEnglish = 0;
end

%% Ask for subject code
if inEnglish
    subjectCode = input('Enter the participant code: ','s');
else
    subjectCode = input('Entrez le code du participant : ','s');
end
if isempty(subjectCode)
  subjectCode = 'trial';
end

%% Ask for operating system (Mac? Linux? Windows?)
if inEnglish
    OSType = input('Are you using MacOS? [Y/N] ','s');
else
    OSType = input('Etes-vous sur MacOS ? [Y/N] ','s');
end
if (strcmp(OSType,'Y')|| strcmp(OSType,'y')) == 1 
    Screen('Preference','TextRenderer',0);
end

%% Ask for duration of the task in seconds
if inEnglish
    taskToutMsgs = 'The standard task lasts 300secs. For a practice, the recommended time = 30 sec. Otherwise, press esc to stop the task manually.';
else
    taskToutMsgs = 'La tache standard dure 300secs. Pour un essai, temps conseille = 30 secs. Sinon, appuyez sur echap pour arreter la tache manuellement.';
end
disp(taskToutMsgs);
if inEnglish
    taskTout = str2num(input('What is the duration of the task (secs)? [Default=300] : ','s'));
else
    taskTout = str2num(input('Quelle est la duree de la tache (secs)? [Default=300] : ','s'));
end
if (isempty(taskTout))
    taskTout = 300;
end

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

%% Compute main session parameters
maxTrials = taskTout; % Max number of trials a person could reasonably give within the time limit
startCount = 1022; % Starting number for arithmetic task
subtract = 13; % step size subtraction
trialTout = 7.5; % max time allocated per trial

%% Give instructions
Screen('TextSize', windowPtr, 30);
if inEnglish
    msgs{1} = ['You will have to do an arithmetic task.', newline, ...
        sprintf('Take the number %d and subtract %.d, then subtract another 13, and so on.', startCount, subtract), ...
        newline,sprintf('Each time, you will only have %.1f seconds to respond.', trialTout), ...
        newline,newline,newline,newline,'To continue, press any key'];
else
    msgs{1} = ['Vous allez devoir effectuer une tÃ¢che arithmetique.', newline, ...
        sprintf('Prenez le chiffre %d et soustrayez %.d, puis soustrayez encore 13, et ainsi de suite.', startCount, subtract), ...
        newline,sprintf('Ã€ chaque fois, vous n''aurez que %.1f secondes pour rÃ©pondre.', trialTout), ...
        newline,newline,newline,newline,'Pour continuer, appuyez sur une touche'];
end
DrawFormattedText(windowPtr,msgs{1},'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2); % Press any key to continue to next screen

if inEnglish
    msgs{2} = ['It is therefore important that you are quick and precise, since ', ...
        sprintf('if there is an error, you will have to start over at %d.', startCount),newline,newline,newline,newline, ...
        'Press any key to start'];
else
    msgs{2} = ['Il est donc important que vous soyez rapide et precis, puisque', ...
        sprintf(' s''il y a une erreur, vous devrez recommencer a %d.', startCount),newline,newline,newline,newline, ...
        'Appuyez sur une touche pour debuter'];
end
DrawFormattedText(windowPtr,msgs{2},'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2); % Press any key to continue to next screen

%% Initialize participant answer data structure
data(1:maxTrials) = struct('Step',NaN,'Accuracy',NaN,'partResp',NaN,'RT',NaN);
data(1).Step = 1;

%% Initialize other variables
escIsDown = false;
isTaskTout = false;
taskTimer = 0; 
taskIni = GetSecs;
ntrials = 0; % Initialize count and iterations
timestamps = [""];
ntrialsStr4timestamps = [""];
%% Experiment loop
    while ~isTaskTout && ~escIsDown % Experiment loop
        ntrials = ntrials +1;
        timestamps(end+1) = datestr(now,'HH:MM:SS.FFF'); 
        ntrialsStr4timestamps(end+1) = num2str(ntrials);
        [data,escIsDown] = arithTrials(data, windowPtr, xCenter, yCenter, ntrials, trialTout, startCount, subtract, inEnglish);
        %% Update Timer, check if task time is up    
        taskTimer = GetSecs - taskIni;% Update timer, check if time is up
        if (taskTimer >= taskTout), isTaskTout = true; end
    end

%% Extract best value
data = data(1:ntrials);
[maxStep, maxpartResp] = getMaxStep(data);
if inEnglish
    endMsg = [' Task completed. '];
else
    endMsg = [' Epreuve terminee. '];
end
DrawFormattedText(windowPtr,endMsg,'center', 'center', 255);
if inEnglish
    DrawFormattedText(windowPtr,['Best score: ' num2str(maxpartResp)],'center', yCenter+150, 255); % Show best value to screen
else
    DrawFormattedText(windowPtr,['Meilleur score : ' num2str(maxpartResp)],'center', yCenter+150, 255); % Show best value to screen
end
Screen('Flip', windowPtr, [], []);
WaitSecs(4);

sca;
ListenChar(0); %  stop listening for keyboard input
KbQueueRelease([]); % Releases queue-associated resources

%% save data
fileName = [subjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
dataDir = [pwd filesep 'DATA' filesep];
if ~isfolder(dataDir), mkdir(dataDir); end 

matPath = fullfile(dataDir,sprintf('%s.mat', fileName));
excelPath = fullfile(dataDir, sprintf('%s.xlsx', fileName));
csvPath = fullfile(dataDir, sprintf('%s.csv', fileName));

save(matPath, 'data'); 
writetable(struct2table(data), excelPath);
writetable(array2table([timestamps.',ntrialsStr4timestamps.'],'VariableNames',{'Timestamps','TrialNumber'}), csvPath);

end

function [maxStep, maxpartResp] = getMaxStep(data)
    maxStepCandidate = max([data.Step]); % The highest step reached
    idxMaxCandidate = find([data.Step] == maxStepCandidate); % Idx of all trials where subject reached that highest step
    if find([data(idxMaxCandidate).Accuracy] == true) % If any of those was good
        maxStep = maxStepCandidate; % That's the highest he went
        maxpartResp = data(idxMaxCandidate).partResp;
    elseif maxStepCandidate == 1 % The subject got all answers wrong
        maxStep = NaN;
    else
        maxStep = maxStepCandidate - 1; % Then his highest is the max - 1, since
                                        % he necessarily got the previous
                                        % one right
        maxpartResp = data(idxMaxCandidate-1).partResp;
    end
end
