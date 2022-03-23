function ProgressBar = PrintTimer(windowPtr, timer, trialTout, rectColor)
% Adds a progress bar showing the time left in the frame buffer of windowPtr
%trialTimer is GetSecs - trialTini; were trialTini is the initial GetSecs
%at each trial start
%trialTout is maximum given time for a trial
    if nargin<4 || isempty(rectColor)
        rectColor = [256,0,0];
    end
    
    penWidth = 5;
    rectW = 300;
    rectH = 50;
    rectWtime = round(rectW*(timer/trialTout));
    rectOutline = [0, 0, rectW, rectH];
    rectProgress = [0, 0, rectWtime, rectH];
    Screen('FrameRect', windowPtr, rectColor, rectOutline, penWidth);
    Screen('FillRect', windowPtr, rectColor, rectProgress);
    
end