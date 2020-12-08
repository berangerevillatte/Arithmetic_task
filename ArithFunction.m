function ArithmeticTask = ArithFunction(windowPtr, x, y,TaskDuration, StartCount, Step, RT, SaveData)
 
%% Calcul mental 
step = Step; %soustraction
MaxRT = RT; %temps de reponse maximum par trial
count = StartCount;
msg = ['Entrez votre reponse'];

message{2} = ['Mauvaise reponse, veuillez recommencer du debut.'];
message{3} = ['Temps écoulé ! veuillez recommencer du debut.'];

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
ii = 0;
RespIndicator = min(PartRespMat);

% Initialize time for each trials and total experimentation
InitTimeResp = GetSecs;
StartExp = GetSecs;    

for ii = 1:TaskDuration
 
    GetSecs;
    
    %message de depart
    Screen('TextSize', windowPtr, 50);
    DrawFormattedText(windowPtr,[num2str(StartCount) '-' num2str(step)],'center', (y-50), 255);
    Screen('Flip', windowPtr, [], 1);
    
    FlushEvents('keyDown'); % Flush GetChar queue to remove stale characters
        
%     Screen('TextSize', windowPtr, 30);
%     DrawFormattedText(windowPtr,num2str(RespIndicator),'right', (y-300), 255);
%     Screen('Flip', windowPtr, [], 1);
    
    InitTimeResp = GetSecs;
    part_resp = str2num(GetEchoString2(windowPtr, msg, x, y, 255,[], 1, [], GetSecs+MaxRT));
    GetSecs;
    RT = GetSecs - InitTimeResp;
    
%     ii = ii+1;
    
    while (GetSecs - StartExp) < TaskDuration

    % GetSecs;
        if part_resp == (count-step) % bonne réponse

            % Save data in matrices
            AnswerMat(ii) = 1;
            ReactionTimeMat(ii) = RT;
            PartRespMat(ii) = part_resp;
            EquationMat(ii) = [num2str(count) '-' num2str(step)] ;

            % positive feedback on screen
            color=[80 220 100];
            half_size_dot =5;
            fixRect = [x-half_size_dot y-half_size_dot x+half_size_dot y+half_size_dot];
            Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form
            Screen('Flip', windowPtr, [], []);
            WaitSecs(1); % feeback presented for 1sec

            FlushEvents('keyDown'); % Reset previous events
            
            % Show best response indicator
%             Screen('TextSize', windowPtr, 30);
%             DrawFormattedText(windowPtr,num2str(RespIndicator),x+300, y-300, 255);
%             Screen('Flip', windowPtr, [], 1);
            
            % Record reaction time
            InitTimeResp = GetSecs;
            part_resp = str2num(GetEchoString2(windowPtr, msg, x, y, 255,[], 1, [], GetSecs+MaxRT));
            GetSecs;
            RT = GetSecs - InitTimeResp;

            % Go to next iteration and reset count
            ii = ii+1;
            count = count - step;


        elseif part_resp ~= (count-step) % mauvaise rep

            % Save data in matrices
            AnswerMat(ii) = 0;
            ReactionTimeMat(ii) = RT;
            PartRespMat(ii) = part_resp;
            EquationMat(ii) = [num2str(count) '-' num2str(step)] ;

            % negative feedback on screen
            color=[250 10 10];
            half_size_dot =50;
            fixRect = [x-half_size_dot y-half_size_dot x+half_size_dot y+half_size_dot];
            Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form
            Screen('Flip', windowPtr, [], []);
            WaitSecs(1); % msg presented for 1sec

            % Returns the first input string
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr,[num2str(StartCount) '-' num2str(step)],'center', (y-50), 255);
            Screen('Flip', windowPtr, [], 1);

            FlushEvents('keyDown'); % reset all events
            
            % Show best response indicator
%             RespIndicator = min(PartRespMat);
%             Screen('TextSize', windowPtr, 30);
%             DrawFormattedText(windowPtr,num2str(RespIndicator),x+300, y-300, 255);
%             Screen('Flip', windowPtr, [], 1);

            % Record reaction time
            InitTimeResp = GetSecs;
            part_resp = str2num(GetEchoString2(windowPtr, msg, x, y, 255,[], 1, [], GetSecs+MaxRT));
            GetSecs;
            RT = GetSecs - InitTimeResp;

            % Go to next iteration and reset count
            ii = ii+1;
            count = StartCount;


        elseif (isempty(part_resp)) & (RT < MaxRT) %empty response 

            ReactionTimeMat(ii) = NaN;
            AnswerMat(ii) = 0;
            PartRespMat(ii) = NaN;
            EquationMat(ii) = [num2str(count) '-' num2str(step)] ;

            % Negative feedback on screen
            color=[250 10 10];
            half_size_dot =50;
            fixRect = [x-half_size_dot y-half_size_dot x+half_size_dot y+half_size_dot];
            Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form
            Screen('Flip', windowPtr, [], []);
            WaitSecs(1);

            % Reinitilize count
            count = StartCount;

            % Returns the first input string
            Screen('TextSize', windowPtr, 50);
            DrawFormattedText(windowPtr,[num2str(StartCount) '-' num2str(step)],'center', (y-50), 255);
            Screen('Flip', windowPtr, [], 1);

            FlushEvents('keyDown');
           
            % Show best response indicator
%             RespIndicator = min(PartRespMat);
%             Screen('TextSize', windowPtr, 30);
%             DrawFormattedText(windowPtr,num2str(RespIndicator),x+300, y-300, 255);
%             Screen('Flip', windowPtr, [], 1);
            
            % Ask for response
            InitTimeResp = GetSecs;
            part_resp = str2num(GetEchoString2(windowPtr, msg, x, y, 255,[], 1, [], GetSecs+MaxRT));
            GetSecs;
            RT = GetSecs - InitTimeResp;

            % Go to next iteration and reset count
            ii = ii+1;
            count = StartCount;

        else % Timeout

            ReactionTimeMat(ii) = 7.50;
            AnswerMat(ii) = 0;
            PartRespMat(ii) = NaN;
            EquationMat(ii) = [num2str(count) '-' num2str(step)] ;

            % Negative feedback on screen
            Screen('TextSize', windowPtr, 80);
            DrawFormattedText(windowPtr,message{3},'center', 'center', 255);
            Screen('Flip', windowPtr);
            WaitSecs(1);
            
%             color=[250 10 10];
%             half_size_dot =50;
%             fixRect = [x-half_size_dot y-half_size_dot x+half_size_dot y+half_size_dot];
%             Screen('FillOval', windowPtr, color, fixRect);%positive feedback color and oval form
%             Screen('Flip', windowPtr, [], []);
%             WaitSecs(1);

            % Reinitialize count
            count = StartCount;

            % Returns the first input string
            Screen('TextSize', windowPtr, 65);
            DrawFormattedText(windowPtr,[num2str(StartCount) '-' num2str(step)],'center', (y-50), 255);
            Screen('Flip', windowPtr, [], 1);

            FlushEvents('keyDown'); % reset all events
            
            % Show best response indicator
%             RespIndicator = min(PartRespMat);
%             Screen('TextSize', windowPtr, 30);
%             DrawFormattedText(windowPtr,[num2str(RespIndicator) ' ' ,newline,'Résultat moyen des participants : 8'],x+300, y-300, 255);
%             Screen('Flip', windowPtr, [], 1);

            % Ask for response
            InitTimeResp = GetSecs;
            part_resp = str2num(GetEchoString2(windowPtr, msg, x, y, 255,[], 1, [], GetSecs+MaxRT));
            GetSecs;
            RT = GetSecs - InitTimeResp;

            % Go to next iteration and reset count
            ii = ii+1;
            count = StartCount;

        end
    end
    
break;
end

end


