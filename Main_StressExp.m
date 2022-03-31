clear all
addpath('lib')

%% Ask for subject code and language
subID = input('Entrez le code du participant : ','s');
if isempty(subID)
  subID = 'test';
end

possibleLang = {'fr','en'};
lang = f_Cmdl_Select_Item(possibleLang);
if isempty(lang) || ~ismember(lang, possibleLang)
    lang = 'fr';
end

% isNoise = input('Y a t''il une tâche de bruit? Oui=true (défaut); Non=false');
enableNoiseTask = strcmp(AskYesNo('Y a t''il une tâche de bruit? (défaut=Oui)'), 'yes');

questionText = {'Avez-vous ouvert LabRecorder ?'; 'Si non, ouvrez-le maintenant.'};
isOK = questdlg(questionText, 'Verification', 'Oui', 'Non', 'Oui');
if strcmp(isOK, 'Non')
    return
end

%% Set the LSL LabRecorder to defined experiment settings
lsl_output_dir = fullfile(pwd, 'lsl_data');
lr = tcpclient('localhost', 22345);  % default port: 22345
fopen(lr);
fprintf(lr, 'select all');
fprintf(lr, ['filename {root:' lsl_output_dir '}'...
            '{template:Subj-%p.xdf}' ...
            '{Participant:' subID '}' ...
            '{task:Arithmetic} ' ...
            '{Acquisition:ARP-Shimmer}' ...
            '{Session:1}' ...
            '{run:1}' ...
            '{modality:Audio-ECG-GSR}']); 


%% Initialize screens and keyboards
[windowPtr, rect, xCenter, yCenter] = InitializePTB([0 0 0]);

%% Initialize infos for numeric scale
actionKeys = GetAvailableKbKeys();

%% Define constants for Train and Task
instructDur = 3; %30
restDur = 3; %6*60
noiseDur = 5*60+2;
stepTout = 7.5; % max time allocated per trial

%Train constants
startCountTrain = 1158;
trainTout = 30; % Train duration = 30 secs

%Task constants
startCountTsk = 1022; % Usually 1022 (TSST) but too many participants have already done the Tsk before
subtract = 13;
tskTout = 6*60; % Tsk duration = 6 min

% initialize some values
isExpOver = false;

% import audio file
[y, fs] = audioread('birds.wav');

%% Lists of tasks and instructions
TskList = ["MentalTrain", "Rest_PreNoiseTsk", "NoiseTsk",...
    "Rest_PreMentalTsk", "MentalTsk", "Rest_PreEndTsk"];

InstList = ["Inst_General", "Inst_MentalTrain", ...
    "Inst_Rest_PreNoiseTsk", "Inst_NoiseTsk", "Inst_Rest_PreMentalTsk", ...
    "Inst_MentalTsk", "Inst_Rest_PreEndTsk"];

if ~enableNoiseTask
    Tsk2rm = ["Rest_PreNoiseTsk", "NoiseTsk"];
    Inst2rm = ["Inst_Rest_PreNoiseTsk", "Inst_NoiseTsk"];
    TskList = TskList(~contains(TskList, Tsk2rm));
    InstList = InstList(~contains(InstList, Inst2rm));
end

%% Main experiment loop
i=1;
j=1;
k=1;
expTini = GetSecs; 
fprintf(lr, 'start');  % TODO: A placer au debut de la tache apres les instruction principales
while ~isExpOver
    % General instructions (no timer)
    Screen('TextSize', windowPtr, 30);
    
    giNList = [3, 4, 5];
    if enableNoiseTask, giNList(1) = 11; end %general instructions to display on screen
    
    for giN = giNList
        DrawFormattedText(windowPtr, ShowInstruct(giN), 'center', 'center', 255); % general instructions #1
        Screen('Flip', windowPtr);
        KbWait([], 2); 
    end    
    
    for tsk = TskList
        
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
                TineOut = noiseDur; %Margin 2s to ensure noise is over before next instruct
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
            [InstMkr, TskMkr, EndMkr] = RestPeriod(windowPtr, instructDur, TimeOut);
            sound(y, fs); % bird signal for the end of rest period

        elseif isArith
            [InstMkr, TskMkr, EndMkr, tskresults] = ArithmeticTask(windowPtr, startCount, subtract, TimeOut, stepTout, instructDur, xCenter, yCenter, subID);
        
        elseif enableNoiseTask
            [InstMkr, TskMkr, EndMkr] = NoiseTask(instructDur, TimeOut, windowPtr, iN);

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
        else
            data.Task = tskresults;
        end

    end
   
    DrawFormattedText(windowPtr, ShowInstruct(9), 'center', 'center', 255); % general instructions #3 ask for questions 
    Screen('Flip', windowPtr);
    [secs, keyCode] = KbWait([], 2);
    
    isExpOver = strcmp(AskYesNo('Voulez-vous terminer la tache?'), 'yes');
end
sca
fprintf(lr, 'stop');  % TODO: Verifier que c'est bien ici la fin de l'enregistrement

%% save Time Markers

dataDir = [pwd filesep 'DATA' filesep];
if ~isfolder(dataDir), mkdir(dataDir); end 

DataName = {'TimeMkr', 'Train', 'stressScore', 'Task'};
for i = 1:length(DataName)
    excelPath = fullfile(dataDir, sprintf('%s_data_%s_%s.xlsx', subID, ...
        datestr(now,'yyyymmdd'), DataName{i}));
    writetable(struct2table(data.(DataName{i})), excelPath);
end

matPath = fullfile(dataDir,sprintf('%s_data_%s.mat', subID, ...
    datestr(now,'yyyymmdd')));
save(matPath, 'data');


