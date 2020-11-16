%code de VILLATTE, Berangere et BIGRAS, Charlotte

AssertOpenGL %version compatible de psychtoolbox avec GL

screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails

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
%Dessiner un rectangle coin haut gauche
%x1=rect(3)/4;
%y1=rect(4)/4;
%x2=x1*3;
%y2=y1*3;
%afficher sur ecran bleu
%Screen('FillRect', w,[255 255 255], [x1, y1, x2, y2]);

welcometext = ['Vous aller devoir effectuer une tâche arythmétique :', char(10), char(10),'Prenez le chiffre 1022 et soustrayez 13, puis soustrayez encore 13, et ainsi de suite.', char(10), char(10),'A chaque fois, vous n''aurez que 7.5 secondes pour repondre.'];

%xCenter = round(rect(3)/2);
%yCenter = round(rect(4)/2);

screen_Center = [rect(3), rect(4)]/2
DrawFormattedText(w, welcometext,'center','center',[0 0 0]);
Screen('Flip', w);

%This program waits for the user to press the return key
[secs, keyCode, deltaSecs] = KbWait([], 2);

welcometext2 = ['Il est donc important que vous soyez rapide et précis, puisque s''il y a une erreur, vous devrez recommencer à 1022.'];
screen_Center = [rect(3), rect(4)]/2
DrawFormattedText(w, welcometext2,'center','center',[0 0 0]);
Screen('Flip', w);
%[normBoundsRect, offsetBoundsRect]= Screen('TextBounds', w, [welcometext], xCenter, yCenter);
%offsetX = (offsetBoundsRect(3)-offsetBoundsRect(1))/2;
%offsetY = (offsetBoundsRect(4)-offsetBoundsRect(2))/2;
%Screen('DrawText', w, [welcometext], xCenter-offsetX, yCenter-offsetY);

[secs, keyCode, deltaSecs] = KbWait([],2);
escapeKey=KbName('ESCAPE');
[a, v, keyCode]=KbCheck;
if any (keyCode(escapeKey));
    sca
end
%%laisser a la fin


sca;
%% txt logfiles
if ~exist('logfiles','dir') % ~: not
    mkdir('logfiles')
end

EventTxtLogFile = fopen(fullfile('logfiles',[subjectName,'_run_',runNumber,'_Events.txt']),'w');    %fopen: open file
 fprintf(EventTxtLogFile,'%18s %18s %18s %18s %18s %18s %18s %18s %18s \n',...  %fprintf : write formated dated to txt file
     'EventNumber','Condition','Coherence','Onset','End','Duration','CorrectResponse','SubjectResponse','isCorrectResponse'); %18s means 18 characters space

 %% %% Save the results
%save([SubjName,'.mat'])
save(fullfile('logfiles',[subjectName,'_run_',runNumber,'_all.mat']))   

save(fullfile('logfiles',[subjectName,'_run_',runNumber,'.mat']),...
'Cfg','conditions','eventCoherence','eventDurations','eventEnds',...
'eventOnsets','responseTime','eventResponse','correctResponses','isCorrectResponse') 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 