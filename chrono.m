function chronometre = chrono(w, duration_max, x, y, color, textsize)
%%
nominalFrameRate = Screen('NominalFrameRate', w);

presSecs = [sort(repmat(1:duration_max, 1, nominalFrameRate), 'descend') 0];


% Here is our drawing loop
for i = 1:length(presSecs)

    % Convert our current number to display into a string
    numberString = num2str(presSecs(i));

    % Draw our number to the screen
    Screen('TextSize', w, textsize);
    DrawFormattedText(w, numberString, x, y, color);

    % Flip to the screen
    Screen('Flip', w);

end