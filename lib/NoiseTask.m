function [InstMkr, TskMkr, EndMkr, wantToQuit] = NoiseTask(instructDur, noiseDur, windowPtr, iN, lang, quitKeyCode)

    %default:   Instructions = 30s
    %           Rest = 6*60s
    %           Sound = 10s before next instruction

    if isempty(instructDur)
        instructDur = 30; % display instructions during 1 minute (60s)     
    end
    if isempty(noiseDur)
        noiseDur = 5*60+5; % Noise lasts 5 min, +5 seconds after to ensure noise is off before next instructions
    end
    
    Screen('TextSize', windowPtr, 30);

    isInstrucTout = false;
    isNoiseTout = false;

    timer = 0;
    noiseTini = GetSecs; % Initialize time for each trials
    InstMkr = noiseTini;
    TskMkr = [];
    EndMkr = [];
    wantToQuit = false;
    
    while ~isInstrucTout  
        
        DrawFormattedText(windowPtr, ShowInstruct(lang, iN), 'center', 'center', 255); % specific instructions for rest period 1
        Screen('Flip', windowPtr);
        
        %print timer
        rectColor = [107, 161, 255];
        PrintTimer(windowPtr, timer, instructDur, rectColor)
            
        timer = GetSecs() - noiseTini;  %check if time is over    
        if (timer >= instructDur), isInstrucTout = true; end

        if QuitRequested(quitKeyCode)
            wantToQuit = true;
            EndMkr = GetSecs;
            return
        end
    end
    TskMkr = GetSecs;
    
    while ~isNoiseTout
        iN = 8;
        DrawFormattedText(windowPtr, ShowInstruct(lang, iN), 'center', 'center', 255); % specific instructions for rest period 1
        Screen('Flip', windowPtr);
        
        timer = GetSecs() - noiseTini;  %check if time is over 
        if (timer >= instructDur+noiseDur), isNoiseTout = true; end

        if QuitRequested(quitKeyCode)
            wantToQuit = true;
            EndMkr = GetSecs;
            return
        end
    end   
    EndMkr = GetSecs;
    
end