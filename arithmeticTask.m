
function dataFinal = arithmeticTask()
%% Arithmetic task developped for the course PSY6976, Universite de Montreal, 2020 
%
% For more information, see README.md file at https://github.com/berangerevillatte/Arithmetic_task
%
% authors : Berangere Villatte <berangere.villatte@umontreal.ca> & Charlotte Bigras <charlotte.bigras@umontreal.ca>

clear all;
%% Ask for subject code
subjectCode = input('Entrez le code du participant : ','s');
if isempty(subjectCode)
  subjectCode = 'trial';
end

%% Ask for operating system (Mac? Linux? Windows?)
OSType = input('Etes-vous sur MacOS ? [Y/N] ','s');
if (strcmp(OSType,'Y')|| strcmp(OSType,'y')) == 1 
    Screen('Preference','TextRenderer',0);
end

%% Ask for duration of the task in seconds
taskToutMsgs = 'La tache standard dure 300secs. Pour un essai, temps conseille = 30 secs. Sinon, appuyez sur echap pour arreter la tache manuellement.';
disp(taskToutMsgs);
taskTout = str2num(input('Quelle est la duree de la tache (secs)? [Default=300] : ','s'));
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
msgs{1} = ['Vous allez devoir effectuer une tâche arithmetique.', newline, ...
    sprintf('Prenez le chiffre %d et soustrayez %.d, puis soustrayez encore 13, et ainsi de suite.', startCount, subtract), ...
    newline,sprintf('À chaque fois, vous n''aurez que %.1f secondes pour répondre.', trialTout), ...
    newline,newline,newline,newline,'Pour continuer, appuyez sur une touche'];
DrawFormattedText(windowPtr,msgs{1},'center', 'center', 255);
Screen('Flip', windowPtr);
[secs, keyCode, deltaSecs] = KbWait([], 2); % Press any key to continue to next screen

msgs{2} = ['Il est donc important que vous soyez rapide et precis, puisque', ...
    sprintf(' s''il y a une erreur, vous devrez recommencer a %d.', startCount),newline,newline,newline,newline, ...
    'Appuyez sur une touche pour debuter'];
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

%% Experiment loop
    while ~isTaskTout && ~escIsDown % Experiment loop
        ntrials = ntrials +1;
        [data,escIsDown] = arithTrials(data, windowPtr, xCenter, yCenter, ntrials, trialTout, startCount, subtract);
        %% Update Timer, check if task time is up    
        taskTimer = GetSecs - taskIni;% Update timer, check if time is up
        if (taskTimer >= taskTout), isTaskTout = true; end
    end

%% Extract best value
data = data(1:ntrials);
[maxStep, maxpartResp] = getMaxStep(data);

endMsg = [' Epreuve terminee. '];
DrawFormattedText(windowPtr,endMsg,'center', 'center', 255);
DrawFormattedText(windowPtr,['Meilleur score : ' num2str(maxpartResp)],'center', yCenter+150, 255); % Show best value to screen
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

save(matPath, 'data'); 
writetable(struct2table(data), excelPath);

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
