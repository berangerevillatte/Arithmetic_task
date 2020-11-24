%code de VILLATTE, Berangere et BIGRAS, Charlotte

AssertOpenGL %version compatible de psychtoolbox avec GL
% KbName('UnifyKeyNames');
screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails
KbName('UnifyKeyNames');

%Pour s'adapter a  tous les ecrans
rect= Screen(screenNumber, 'Rect'); 
resolution= Screen('Resolution', screenNumber);
hz=Screen('FrameRate', screenNumber); %creer une frequence dimage

% Get subject name and run number (prompt to get the SubjectName & runNumber before the start of the experiment)
subjectName = input('Enter participant code: ','s');
if isempty(subjectName)
  subjectName = 'trial';
end
runNumber = input('Enter the run Number: ','s');
if isempty(runNumber)
  runNumber = 'trial';
end

% Display instructions
couleur_ecran=[100 100 100];%Ecran gris 
[w, rect]=Screen('OpenWindow',screenNumber, couleur_ecran); 
Screen('TextSize', w,[50]);

welcometext = ['Vous aller devoir effectuer une tâche arythmétique :', char(10), char(10),'Prenez le chiffre 1022 et soustrayez 13, puis soustrayez encore 13, et ainsi de suite.', char(10), char(10),'A chaque fois, vous n''aurez que 7.5 secondes pour repondre.'];

%xCenter = round(rect(3)/2);
%yCenter = round(rect(4)/2);

%screen_Center = [rect(3), rect(4)]/2 
DrawFormattedText(w, welcometext,'center','center',[0 0 0]);
Screen('Flip', w);

%This program waits for the user to press the return key
[secs, keyCode, deltaSecs] = KbWait([], 2);

welcometext2 = ['Il est donc important que vous soyez rapide et précis, puisque s''il y a une erreur, vous devrez recommencer à 1022.'];
DrawFormattedText(w, welcometext2,'center','center',[0 0 0]);
Screen('Flip', w);

%This program waits for the user to press the return key
[secs, keyCode, deltaSecs] = KbWait(-1,2);
escapeKey=KbName('ESCAPE');
[a, v, keyCode]=KbCheck;
if any (keyCode(escapeKey));
    sca
end

WaitSecs(10);
sca

%% 
%local functions
%%
