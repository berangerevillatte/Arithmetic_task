
function [InstrMkr, TskMkr, EndMkr, data, wantToQuit] = ArithmeticTask(windowPtr, startCount, subtract, taskTout, stepTout, instTout, xCenter, yCenter, subID, lang, quitKeyCode)

% duree tache, 1er nombre, subtract, 1er nombre aleatoire a chaque step =0, duree instructions
    %% Silent arithmetic task developped to induce acute stress for psychophysiological assessement, suitable for EEG, MEG or ARP
    % For more information, see README.md file at https://github.com/berangerevillatte/Arithmetic_task
    % authors : Berangere Villatte <berangere.villatte@umontreal.ca>, Charlotte
    % Bigras <charlotte.bigras@umontreal.ca> & Frederik Desaulniers <frederik.desaulniers@umontreal.ca>


    %% MENTAL_TSK instructions
    % instructions are timed : 1 min
    Screen('TextSize', windowPtr, 30);

    mentalTxtTout = 1.5;
    isInstTout = false;
    isMentalTxtTout = false;
    
    maxStep = taskTout; % Max number of step a person could reasonably go within the time limit

    timer = 0;
    timerTini = GetSecs(); % Initialize time for each trials   
    InstrMkr = GetSecs;
    TskMkr = [];
    EndMkr = [];
    data = [];
    wantToQuit = false;

    while ~isInstTout % 1 minute
        while ~isMentalTxtTout
            DrawFormattedText(windowPtr, ShowInstruct(lang, 1, startCount, subtract, stepTout), 'center', 'center', 255); % specific instructions for rest period 1
            Screen('Flip', windowPtr);
            
            %check if time is over
            timer = GetSecs - timerTini;        
            if (timer >= mentalTxtTout), isMentalTxtTout = true; end            
            
            if QuitRequested(quitKeyCode)
                wantToQuit = true;
                return
            end

        end
        
        rectColor = [107, 161, 255];
        PrintTimer(windowPtr, timer, instTout, rectColor)
        
        DrawFormattedText(windowPtr, ShowInstruct(lang, 2, startCount, subtract, stepTout), 'center', 'center', 255); % specific instructions for rest period 1
        Screen('Flip', windowPtr);        
        
        %check if time is over
        timer = GetSecs() - timerTini;        
        if (timer >= instTout), isInstTout = true; end   
        
        if QuitRequested(quitKeyCode)
            wantToQuit = true;
            EndMkr = GetSecs;
            return
        end
    end
    

    %% Initialize participant answer data structure
    data(1).Step = 1;

    %% Initialize other variables
    escIsDown = false;
    isTaskTout = false;
    taskTimer = 0; 
    taskIni = GetSecs;
    ntrials = 0; % Initialize count and iterations
    realTime = GetSecs;
    
    TskMkr = GetSecs;

    %% Experiment loop
    while ~isTaskTout && ~wantToQuit % Experiment loop
        ntrials = ntrials +1;
        data(ntrials).realTime = GetSecs;
        data(ntrials).elTime = data(ntrials).realTime - GetSecs;
        [data, wantToQuit] = ArithTrials(data, windowPtr, xCenter, yCenter, ntrials, stepTout, startCount, subtract);
        
        %% Update Timer, check if task time is up    
        taskTimer = GetSecs - taskIni; % Update timer, check if time is up
        if (taskTimer >= taskTout), isTaskTout = true; end
        
        if wantToQuit || QuitRequested(quitKeyCode)
            wantToQuit = true;
            EndMkr = GetSecs;
            return
        end
    end
        
    EndMkr = GetSecs;
    
    %% Extract best value
    value = data(1:ntrials);
    [~, maxpartResp] = getMaxStep(value);

    endMsg = [' Epreuve terminee. '];
    DrawFormattedText(windowPtr,endMsg,'center', 'center', 255);
    DrawFormattedText(windowPtr,['Meilleur score : ' num2str(maxpartResp)],'center', yCenter+150, 255); % Show best value to screen
    Screen('Flip', windowPtr, [], []);
    WaitSecs(4);

    ListenChar(0); %  stop listening for keyboard input
    KbQueueRelease([]); % Releases queue-associated resources

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
