function [data,escIsDown] = arithTrials(data, windowPtr, xCenter, yCenter, ntrials, trialTout, startCount, subtract, msgs)

%% Keyboard
KbName('UnifyKeyNames'); 
%KbName PTB3 : In the case of labels such as “5”, which appears on two keys, the name “5” designates the “5” key on the numeric keypad and “5%” designates the QWERTY “5” key.
possibleKeys = [KbName('ESCAPE'),KbName('RETURN'), KbName('BACKSPACE'), KbName('DELETE') KbName('1'),KbName('1!'), ... % delete to erase with Mac
    KbName('2'),KbName('2@'),KbName('3'),KbName('3#'),KbName('4'),KbName('4$'), ...
    KbName('5'),KbName('5%'),KbName('6'),KbName('6^'),KbName('7'),KbName('7&'), ...
    KbName('8'),KbName('8*'),KbName('9'),KbName('9('),KbName('0'),KbName('0)'),];
keyList = zeros(256,1); %https://stackoverflow.com/questions/45961412/using-kbqueuecheck-to-continuously-check-for-device-input
keyList(possibleKeys) = 1;

%% Experiment loop
try
ListenChar(-1); % Allows concurrent use of ListenChar for character suppression, while at the same time using keyboard queues for character and key input.
KbQueueCreate([], keyList); % Only capture keys specified in keyList

temp = [];
enterIsDown = false;
escIsDown = false;
isTrialTout = false;

KbQueueStart();

trialTimer = 0;
trialTini = GetSecs(); % Initialize time for each trials

startEquation = sprintf('%d - %d', startCount, subtract);

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
            case {'backspace', 'delete'} % delete
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
    %% Print timer on screen
    printTimer(windowPtr,trialTimer,trialTout);
    %% Print string number to screen
    output = [' ', 'Reponse : ', temp]; % as in GetEchoString
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr, output, 'center', 'center', 255);

   if data(ntrials).Step == 1 %% Print starting equation
    DrawFormattedText(windowPtr,startEquation,'center', (yCenter-50), 255);
   end
    Screen('Flip', windowPtr, [], []);

    trialTimer = GetSecs() - trialTini; % Update timer, check if time is up
    if (trialTimer >= trialTout), isTrialTout = true; end
end

%% Evaluate participant's response      
goodAnsw = startCount - data(ntrials).Step*subtract;
if isTrialTout % Ran out of time before giving answer
    data(ntrials+1).Step = 1; % Start from beginning
    data(ntrials).Accuracy   = false;
    color=[250 10 10]; halfSizeDot =50;
    DrawFormattedText(windowPtr,'Temps ecoule !','center', yCenter-100, 255);        % Time out feedback on screen

elseif enterIsDown && (str2double(temp) ~= goodAnsw) % Gave wrong answer
    data(ntrials+1).Step = 1; % Start from beginning
    data(ntrials).Accuracy = false;
    data(ntrials).RT = trialTimer;
    data(ntrials).partResp = str2double(temp);
    color=[250 10 10]; halfSizeDot =50;            % negative feedback on screen

elseif enterIsDown && (str2double(temp) == goodAnsw) % Gave good answer
    data(ntrials+1).Step = data(ntrials).Step + 1;
    data(ntrials).Accuracy = true;
    data(ntrials).RT = trialTimer;
    data(ntrials).partResp = str2double(temp);
    color=[80 220 100]; halfSizeDot = 5;            % positive feedback on screen
end

fixRect = [xCenter-halfSizeDot yCenter-halfSizeDot xCenter+halfSizeDot yCenter+halfSizeDot]; % Feedback dimension and position on screen
Screen('FillOval', windowPtr, color, fixRect); % positive feedback color and oval form
Screen('Flip', windowPtr, [], []);
WaitSecs(1);     

catch ME
    ListenChar(0); %  stop listening for keyboard input
    KbQueueRelease([]); % Releases queue-associated resources
end
end 

function ProgressBar = printTimer(windowPtr,trialTimer,trialTout)
% Adds a progress bar showing the time left in the frame buffer of windowPtr
%trialTimer is GetSecs - trialTini; were trialTini is the initial GetSecs
%at each trial start
%trialTout is maximum given time for a trial
    rectColor = [256,0,0];
    penWidth = 5;
    rectW = 300;
    rectH = 50;
    rectWtime = round(rectW*(trialTimer/trialTout));
    rectOutline = [0, 0, rectW, rectH];
    rectProgress = [0, 0, rectWtime, rectH];
    Screen('FrameRect', windowPtr, rectColor, rectOutline, penWidth);
    Screen('FillRect', windowPtr, rectColor, rectProgress);
end
