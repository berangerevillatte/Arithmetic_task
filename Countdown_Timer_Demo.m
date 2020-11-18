% Clear the workspace and the screen
close all;
clearvars;
sca

% Randomly seed the random number generation
rng('shuffle');

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Skip sync tests for demo purposes only
Screen('Preference', 'SkipSyncTests', 1);

% Get the screen numbers
screens = Screen('Screens');

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black
gray = GrayIndex(screenNumber);

% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, gray);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% We set the text size to be nice and big here
Screen('TextSize', window, 300);

% Get the nominal framerate of the monitor. For this simple timer we are
% going to change the counterdown number every second. This means we
% present each number for "frameRate" amount of frames. This is because
% "framerate" amount of frames is equal to one second. Note: this is only
% for a very simple timer to demonstarte the principle. You can make more
% accurate sub-second timers based on this.
nominalFrameRate = Screen('NominalFrameRate', window);

% Our timer is going to start at 10 and count down to 0. Here we make a
% list of the number we are going to present on each frame. This way of
% doing things is just for you to see what is going on more easily. You
% could eliminate this step completely by simply keeping track of the time
% and updating the clock appropriately, or by clever use of the Screen Flip command
% However, for this simple demo, this should work fine
presSecs = [sort(repmat(1:10, 1, nominalFrameRate), 'descend') 0];

% We change the color of the number every "nominalFrameRate" frames
colorChangeCounter = 0;

% Randomise a start color
color = rand(1, 3);

% Here is our drawing loop
for i = 1:length(presSecs)

    % Convert our current number to display into a string
    numberString = num2str(presSecs(i));

    % Draw our number to the screen
    DrawFormattedText(window, numberString, 'center', 'center', color);

    % Flip to the screen
    Screen('Flip', window);

    % Decide if to change the color on the next frame
    colorChangeCounter = colorChangeCounter + 1;
    if colorChangeCounter == nominalFrameRate
        color = rand(1, 3);
        colorChangeCounter = 0;
    end

end

% Wait a second before closing the screen
WaitSecs(1);

% Clear the screen
close all;
clear all;
sca