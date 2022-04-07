function [InstMkr, TskMkr, EndMkr, wantToQuit] = RestPeriod(windowPtr, instructDur, restDur, lang, quitKeyCode)

    %default:   Instructions = 30s
    %           Rest = 6*60s
    %           Sound = 10s before next instruction

    if isempty(instructDur)
        instructDur = 30; % display instructions during 1 minute (60s)     
    end
    if isempty(restDur)
        restDur = 6*60; % rest period lasts 6 min
    end

    Screen('TextSize', windowPtr, 30);

    isInstrucTout = false;
    isRestTout = false;
    isSoundTout = false;

    timer = 0;
    restTini = GetSecs; % Initialize time for each trials
    InstMkr = restTini;
    TskMkr = [];
    EndMkr = [];
    wantToQuit = false;

    while ~isInstrucTout  
        iN = 6; %instruction number
        
        DrawFormattedText(windowPtr, ShowInstruct(lang, iN), 'center', 'center', 255); % specific instructions for rest period 1
        Screen('Flip', windowPtr);
        
        %print timer
        rectColor = [107, 161, 255];
        PrintTimer(windowPtr, timer, instructDur, rectColor)
            
        timer = GetSecs - restTini;  %check if time is over    
        if (timer >= instructDur), isInstrucTout = true; end

        if QuitRequested(quitKeyCode)
            wantToQuit = true;
            EndMkr = GetSecs;
            return
        end
        
    end
    
    TskMkr = GetSecs;
        
    while ~isRestTout
        iN = 7; %instruction number
        
        DrawFormattedText(windowPtr, ShowInstruct(lang, iN), 'center', 'center', 255); % specific instructions for rest period 1
        Screen('Flip', windowPtr);
        
        timer = GetSecs - restTini;  %check if time is over 
        if (timer >= instructDur+restDur), isRestTout = true; end
   
        if QuitRequested(quitKeyCode)
            wantToQuit = true;
            EndMkr = GetSecs;
            return
        end
    end
    
    EndMkr = GetSecs;
    
end