function [data, escIsDown] = ArithFunction2(data, windowPtr, x, y, ntrial, startCount, step, trialTout)
 
% step is step size substraction
% trialTout is max response time per trial
count = startCount; % starting number 
msg = ['Entrez votre reponse'];
msg2 = ['Le temps est ecoule! veuillez recommencer du debut.'];

%% Keyboard
try
    KbName('UnifyKeyNames');
    ListenChar(-1); % Allows concurrent use of ListenChar for character suppression, while at the same time using keyboard queues for character and key input.
possibleKeys = [KbName('ESCAPE'),KbName('RETURN'), KbName('delete'), KbName('1'), ...
    KbName('2'),KbName('3'),KbName('4'), ...
    KbName('5'),KbName('6'),KbName('7'), ...
    KbName('8'),KbName('9'),KbName('0')];
keyList = zeros(256,1); %https://stackoverflow.com/questions/45961412/using-kbqueuecheck-to-continuously-check-for-device-input
keyList(possibleKeys) = 1;
KbQueueCreate([],keyList); % Only capture keys specified in keyList 
KbQueueFlush(); 
KbQueueStart();
temp = [];

% Initialize time for total experimentation
startExp = GetSecs;    

    GetSecs;  
    responseTime = 0;
    initTimeResp = GetSecs; % Initialize time for each trials
    GetSecs;
    %responseTime = GetSecs - initTimeResp;
    enterIsDown = false;
    escIsDown   = false;
    isTrialTout = false;
    startEquation = sprintf('%d - %d', startCount, step);

    while (~isTrialTout && ~enterIsDown && ~escIsDown) %loop to get keyboard string input
    [keyIsDown,firstPress,~,~,~] = KbQueueCheck();  %iskeyDown? creates a vector of pressed keys
    if keyIsDown %is a key is pressed
        whichKey = KbName(find(firstPress, 1)); %which key was first pressed in the keyList
        switch whichKey
            case 'ESCAPE'
                escIsDown = true; % ends the while loop and the experiment
                KbQueueRelease();
            case 'RETURN'
                enterIsDown = true; % ends the while loop and goes to feedback
                KbQueueRelease();
            case 'delete' % backspace
                if ~isempty(temp) % as in GetEchoString to erase numbers 
                    temp = temp(1:length(temp)-1);
                end
            case {'1'}
                temp = [temp '1'];
            case {'2'}
                temp = [temp '2'];
            case {'3'}
                temp = [temp '3'];
            case {'4'}
                temp = [temp '4'];
            case {'5'}
                temp = [temp '5'];
            case {'6'}
                temp = [temp '6'];
            case {'7'}
                temp = [temp '7'];
            case {'8'}
                temp = [temp '8'];
            case {'9'}
                temp = [temp '9'];
            case {'01'}
                temp = [temp '0'];
            otherwise
                error ('not a valid number')
        end
    end
    
    %% Print string number to screen
    output = [' ', temp]; % as in GetEchoString
    partResp = str2double(temp);
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,output, 'center', 'center', 255);
    if data(ntrial).accuracy == 0 %% Print starting equation
        DrawFormattedText(windowPtr,startEquation,'center', (y-50), 255);
    end
    Screen('Flip', windowPtr, [], []);
    responseTime = GetSecs() - initTimeResp;
    trialTimer = GetSecs() - trialTini;
    if (trialTimer >= trialTout), isTrialTout = true; 
    end
    end
    
    %% Feedback and recording of data
    % check accuracy
    
    if partResp == (startCount - (partResp(ntrial).equation*step)) % good answer
        accuracy = 1;
        % Save data in matrices
        data(ntrial).partResp = partResp;
        data(ntrial).rt = responseTime;
        data(ntrial).accuracy = accuracy;
        data(ntrial+1).step = data(ntrial).step +1;
        % positive feedback on screen
        color=[80 220 100];
        halfSizeDot = 5;
        fixRect = [x-halfSizeDot y-halfSizeDot x+halfSizeDot y+halfSizeDot];
        Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form

    elseif partResp ~= (startCount - (partResp(ntrial).equation*step)) % wrong answer
        accuracy = 0;
        % Save data in matrices
        answ(ntrial+1).step = 1; % Start from beginning
        data(ntrial).partResp = partResp;
        data(ntrial).rt = [data.rt, responseTime];
        data(ntrial).accuracy = accuracy;
        
        % negative feedback on screen
        color=[250 10 10];
        halfSizeDot =50;
        fixRect = [x-halfSizeDot y-halfSizeDot x+halfSizeDot y+halfSizeDot];
        Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form

    elseif isTrialTout
        accuracy = 0;
        % Save data in matrices
        answ(ntrial+1).step = 1; % Start from beginning
        data(ntrial).partResp = partResp;
        data(ntrial).rt = responseTime;
        data(ntrial).accuracy = accuracy;
        
        % Time out feedback on screen
        DrawFormattedText(windowPtr,msg2,'center', 'center', 255);
    end
        Screen('Flip', windowPtr, [], []);
        WaitSecs(1);
    
catch ME
    sca;
    KbQueueRelease();
    ListenChar(0);
end

KbQueueRelease();
ListenChar(0);

%% save data

% dataLabels = ["Equation" "Participant response" "Accuracy" "Reaction Time"];
% dataCollect = [equationMat; partRespMat; partResp; reactionTimeMat]';
% dataFinal = [dataLabels; dataCollect];
 %%dataFinal = data(1:ntrial)
% if saveData == 1
%     fileName = [subjectCode,'_trial_', datestr(now,'dd-mm-yyyy')]; 
% elseif saveData == 0
% fileName = [subjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
% end

end



