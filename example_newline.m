AssertOpenGL;
screens=Screen('Screens');
screenNumber=max(screens);

HideCursor;
ListenChar(2);

[windowPtr,rect]=Screen('OpenWindow',screenNumber);
Screen('TextSize', windowPtr, 100);

possibleKeys = 'qal';
exitKey = 'q';
temp = [];
FlushEvents('keyDown');
startSecs = GetSecs;
while ~strcmp(temp, exitKey)
    [secs, keyCode, deltaSecs] = KbWait([], 2);
    temp = KbName(keyCode);
    whichKey = strfind(possibleKeys, temp);
    if ~isempty(whichKey);
        Screen('DrawText', windowPtr, temp, 200, 200, [0 0 0]);
        Screen('DrawText', windowPtr, sprintf('%.2f', secs-startSecs), 300, 300, [0 0 0]);
        Screen('Flip', windowPtr);
        FlushEvents('keyDown');
    end
end
WaitSecs(6);
sca;
ShowCursor;
ListenChar(0);