clear all
addpath('lib', 'resource')

f_SaveCommandWindow

%% Lists of tasks and instructions.
% Every task must have a corresponding instruction in the same order.
% The general instruction is automatically added at the begining of the instruction array after the
% task selection for this run.
TskList = ["MentalTrain", "Rest_PreNoiseTsk", "NoiseTsk",...
           "Rest_PreMentalTsk", "MentalTsk", "Rest_PreEndTsk"];

InstList = ["Inst_MentalTrain", "Inst_Rest_PreNoiseTsk", "Inst_NoiseTsk", ...
            "Inst_Rest_PreMentalTsk", "Inst_MentalTsk", "Inst_Rest_PreEndTsk"];

%% Define constants for Train and Task
instructDur = 3; %30 [seconds]
restDur = 3; %6*60 [seconds]
noiseDur = 5*60+2; % [seconds]
stepTout = 7.5; % max time allocated per trial [seconds]

%Train constants
startCountTrain = 1158;
trainTout = 30; % Train duration = 30 secs

%Task constants
startCountTsk = 1022; % Usually 1022 (TSST) but too many participants have already done the Tsk
subtract = 13;
tskTout = 6*60; % Tsk duration = 6 min


f_SaveCommandWindow

%% Lists of tasks and instructions.
% Every task must have a corresponding instruction in the same order.
% The general instruction is automatically added at the begining of the instruction array after the
% task selection for this run.
TskList = ["MentalTrain", "Rest_PreNoiseTsk", "NoiseTsk",...
           "Rest_PreMentalTsk", "MentalTsk", "Rest_PreEndTsk"];

InstList = ["Inst_MentalTrain", "Inst_Rest_PreNoiseTsk", "Inst_NoiseTsk", ...
            "Inst_Rest_PreMentalTsk", "Inst_MentalTsk", "Inst_Rest_PreEndTsk"];

%% Define constants for Train and Task
instructDur = 60; %30 [seconds]
restDur = 6*60; %6*60 [seconds]
noiseDur = 5*60+2; % [seconds]
stepTout = 7.5; % max time allocated per trial [seconds]

%Train constants
startCountTrain = 1158;
trainTout = 30; % Train duration = 30 secs

%Task constants
startCountTsk = 1022; % Usually 1022 (TSST) but too many participants have already done the Tsk
subtract = 13;
tskTout = 5*60; % Tsk duration = 6 min


%% Ask for subject code and language
subID = input('Entrez le code du participant : ','s');
if isempty(subID)
  subID = 'test';
end

possibleLang = {'fr','en'};
[~, lang] = f_Cmdl_Select_Item(possibleLang);
if isempty(lang) || ~ismember(lang, possibleLang)
    lang = 'fr';
end

enable_lsl = strcmp(AskYesNo('Voulez-vous activer LSL?'), 'yes');

if enable_lsl
    questionText = {'Avez-vous ouvert LabRecorder ?';
                    'Si non, ouvrez-le maintenant.';
                    '';
                    'Appuyez-sur ''non'' fermera le programme'};
    isOK = questdlg(questionText, 'Verification', 'Oui', 'Non', 'Oui');
    if isempty(isOK) || strcmp(isOK, 'Non')
        return
    end
    
    %% Set the LSL LabRecorder to defined experiment settings
    lsl_output_dir = fullfile(pwd, 'lsl_data');
    lr = tcpclient('localhost', 22345);  % default port: 22345
    try
        fopen(lr);
    catch ME
        if strcmp(ME.identifier, 'MATLAB:fopen:InvalidInput')
            fprintf(2, ['Suggested fix: Verify if LSL streams are ', ...
                        'running and try again (ECG, GSR, ARP)\n\n'])
        end
        rethrow(ME)
    end
    fprintf(lr, 'select all');
    fprintf(lr, ['filename {root:' lsl_output_dir '}'...
                '{template:Subj-%p.xdf}' ...
                '{Participant:' subID '}' ...
                '{task:Arithmetic} ' ...
                '{Acquisition:ARP-Shimmer}' ...
                '{Session:1}' ...
                '{run:1}' ...
                '{modality:Audio-ECG-GSR}']); 
end

% Selection of task to execute during this run
[idx, tf] = listdlg('PromptString', 'Select the task(s) to execute:', 'ListString', TskList);
if ~tf
    disp('User exits')
    return
else
    TskList = TskList(idx);
    InstList = InstList(idx);
end
InstList = ["Inst_General", InstList]; % always keep the general instructions


%% Initialize screens and keyboards
[windowPtr, rect, xCenter, yCenter] = InitializePTB([0 0 0]);


%% Initialize infos for numeric scale
actionKeys = GetAvailableKbKeys();

% import audio file
[y, fs] = audioread('birds.wav');


%% Main experiment loop
i=1;
j=1;
k=1;
wantToQuit = false;
tskresults = [];
data = [];

disp(datestr(now,'yyyy-mm-dd HH:MM:SS.FFF'))
expTini = GetSecs;
disp(['timestamps: Start | expTini=' num2str(expTini, '%.6f')])

%% ===== START RECORDING LSL STREAMS =====
if enable_lsl
    fprintf(lr, 'start');
end

%% ===== BEGING TASKS =====
while ~wantToQuit
    % General instructions (no timer)
    Screen('TextSize', windowPtr, 30);
    
    giNList = [3, 4, 5];
    if any(contains(TskList, 'noise', 'IgnoreCase', true))
        giNList(1) = 11;
    end %general instructions to display on screen
    
    for giN = giNList
        DrawFormattedText(windowPtr, ShowInstruct(lang, giN), 'center', 'center', 255); % general instructions #1
        Screen('Flip', windowPtr);
        f_Wait_KbKeyPress([actionKeys.next, actionKeys.quit])
    end    
    
    for tsk = TskList
        repeatLoop = true; % Make sure to start loop
        while repeatLoop && ~QuitRequested(actionKeys.quit)
            isArith = false;
            isTrain = false;
            isRest = false;
            
            switch tsk
                case 'MentalTrain'
                    str = 'Entrainement au calcul mental...(%.ds)\n';
                    startCount = startCountTrain;
                    TimeOut = trainTout;
                    isArith = true;
                    isTrain = true;
                    
                case 'Rest_PreNoiseTsk'
                    str = 'Période de repos...(%.ds)\n';
                    TimeOut = restDur;
                    isRest = true;
                    
                case 'NoiseTsk'
                    str = 'Écoute du bruit...(%.ds)\n';
                    TimeOut = noiseDur; %Margin 2s to ensure noise is over before next instruct
                    iN = 10;
                    
                case 'Rest_PreMentalTsk'
                    str = 'Période de repos...(%.ds)\n';
                    TimeOut = restDur;
                    isRest = true;
                                
                case 'MentalTsk'
                    str = 'Calcul mental...(%.ds)\n';
                    startCount = startCountTsk;
                    TimeOut = tskTout; 
                    isArith = true;
                    
                case 'Rest_PreEndTsk'
                    str = 'Période de repos...(%.ds)\n';
                    TimeOut = restDur;
                    isRest = true;       
            end
            
            fprintf(str, TimeOut);
            
            if isRest
                [InstMkr, TskMkr, EndMkr, wantToQuit] = RestPeriod(windowPtr, instructDur, TimeOut, lang, actionKeys.quit);
                disp(['timestamps: Rest | InstMkr=' num2str(InstMkr, '%.6f')])
                disp(['timestamps: Rest | TskMkr=' num2str(TskMkr, '%.6f')])
                disp(['timestamps: Rest | EndMkr=' num2str(EndMkr, '%.6f')])
                if ~wantToQuit
                    sound(y, fs); % bird signal for the end of rest period
                end
            
            elseif isArith
                [InstMkr, TskMkr, EndMkr, tskresults, wantToQuit] = ArithmeticTask(windowPtr, startCount, subtract, TimeOut, stepTout, instructDur, xCenter, yCenter, subID, lang, actionKeys.quit);
                disp(['timestamps: Arith | InstMkr=' num2str(InstMkr, '%.6f')])
                disp(['timestamps: Arith | TskMkr=' num2str(TskMkr, '%.6f')])
                disp(['timestamps: Arith | EndMkr=' num2str(EndMkr, '%.6f')])
    
            elseif any(contains(TskList, 'noise', 'IgnoreCase', true))
                [InstMkr, TskMkr, EndMkr, wantToQuit] = NoiseTask(instructDur, TimeOut, windowPtr, iN, lang, actionKeys.quit);
                disp(['timestamps: Noise | InstMkr=' num2str(InstMkr, '%.6f')])
                disp(['timestamps: Noise | TskMkr=' num2str(TskMkr, '%.6f')])
                disp(['timestamps: Noise | EndMkr=' num2str(EndMkr, '%.6f')])
            end
            
            if wantToQuit
                break
            end

            [score, ~, ~] = GetSliderFeedback('stress', [1 1 1], windowPtr, xCenter, yCenter, actionKeys, lang);
            
            data.stressScore(k).Task = tsk;
            data.stressScore(k).Score = score;
            k=k+1;
    
            if j==1
                data.TimeMkr(i).Tsk = InstList(j);
                data.TimeMkr(i).SegmentStartRefExpOnset = expTini;
                data.TimeMkr(i).SegmentEndRefExpOnset = InstMkr;
            end
            
            i=i+1;
            j=j+1;
            
            data.TimeMkr(i).Tsk = InstList(j);
            data.TimeMkr(i).SegmentStartRefExpOnset = InstMkr;
            data.TimeMkr(i).SegmentEndRefExpOnset = TskMkr;
            
            i=i+1;
            data.TimeMkr(i).Tsk = tsk;
            data.TimeMkr(i).SegmentStartRefExpOnset = TskMkr;
            data.TimeMkr(i).SegmentEndRefExpOnset = EndMkr;
            
            if isTrain
                data.Train = tskresults;
                repeatLoop = strcmp(AskYesNo('Recommancer l''entrainement ?'), 'yes');
            else
                data.Task = tskresults;
                repeatLoop = false;  % Only training can be repeated
            end
        end
        if wantToQuit
            break
        end
    end
    if wantToQuit
        break
    end

    DrawFormattedText(windowPtr, ShowInstruct(lang, 9), 'center', 'center', 255); % general instructions #3 ask for questions 
    Screen('Flip', windowPtr);
    [secs, keyCode] = KbWait([], 2);
    
    wantToQuit = strcmp(AskYesNo('Voulez-vous terminer la tache?'), 'yes');
end
sca


%% ===== STOP RECORDING LSL STREAMS =====
if enable_lsl, fprintf(lr, 'stop'); end


%% save Time Markers
if ~isempty(data)
    dataDir = [pwd filesep 'DATA' filesep];
    if ~isfolder(dataDir), mkdir(dataDir); end 
    
    DataName = {'TimeMkr', 'Train', 'stressScore', 'Task'};
    dtNowStr = datestr(now, 'yyyymmdd');
    for i = 1:length(DataName)
        excelPath = fullfile(dataDir, sprintf('%s_data_%s_%s.xlsx', subID, dtNowStr, DataName{i}));
        writetable(struct2table(data.(DataName{i})), excelPath);
    end
    
    matPath = fullfile(dataDir,sprintf('%s_data_%s.mat', subID, dtNowStr));
    save(matPath, 'data');
end

diary off % Stop recording command window
