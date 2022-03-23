function [windowPtr, rect, xCenter, yCenter] = InitializePTB(screenColor)
%% Initialize screens and keyboards
%     Ask for operating system (Mac? Linux? Windows?)
%     OSType = input('Etes-vous sur MacOS ? Y/N : ','s');
%     if upper(OSType) == 'Y' 
%         Screen('Preference','TextRenderer',0);
%     end

    if ismac
        Screen('Preference','TextRenderer',0);
    end
        

    AssertOpenGL; %compatible version of psychtoolbox with GL
    screens = Screen('screens'); % locate screens
    
    screenNumber = max(screens); % search secondary screen
    Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails

    %To fit on every screen
    if isempty(screenColor)
        screenColor = [0 0 0];% background screen color is black
    end
    
    [windowPtr, rect] = Screen('OpenWindow', screenNumber, screenColor);
    
    %define center of screens
    xCenter = round(rect(3)/2);
    yCenter = round(rect(4)/2);