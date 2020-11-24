%% Initilize screens
%AssertOpenGL %compatible version of psychtoolbox with GL
KbName('UnifyKeyNames');
[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails

%To fit on every screen
rect= Screen(screenNumber, 'Rect'); 
resolution= Screen('Resolution', screenNumber);
hz=Screen('FrameRate', screenNumber); %creer une frequence dimage

%% Get subject name and run number (prompt to get the SubjectName & runNumber before the start of the experiment)
subjectName = input('Enter participant code: ','s');
if isempty(subjectName)
  subjectName = 'trial';
end
runNumber = input('Enter the run Number: ','s');
if isempty(runNumber)
  runNumber = 'trial';
end

%% Display a grey screen
couleur_ecran=[100 100 100];%Ecran gris 
[w, rect]=Screen('OpenWindow',screenNumber, couleur_ecran); 
% xCenter = round(rect(3)/2);
% yCenter = round(rect(4)/2);

%% Escape key
% This program waits for the user to press the return key
[secs, keyCode, deltaSecs] = KbWait(-1,2);
Escape_key=KbName('Escape');
[a, v, keyCode]=KbCheck;
if any (keyCode(Escape_key));
    sca
end

%% Display instructions
welcometext = ['Vous aller devoir effectuer une tâche arythmétique :',...
    char(10), char(10),'Prenez le chiffre 1022 et soustrayez 13, puis soustrayez encore 13, et ainsi de suite.', char(10), ...
    char(10),'A chaque fois, vous n''aurez que 7.5 secondes pour repondre.'];
welcometext2 = ['Il est donc important que vous soyez rapide et précis, puisque s''il y a une erreur, vous devrez recommencer à 1022.'];

DrawFormattedText(w, sprintf(welcometext),'center','center',[0 0 0]);
Screen('Flip', w);

% This program waits for the user to press the return key
[secs, keyCode, deltaSecs] = KbWait([], 2);

DrawFormattedText(w, welcometext2,'center','center',[0 0 0]);
Screen('Flip', w);

%% force to exit
% WaitSecs(5)
% sca

%% Creates stimulus
% array = 1009:-13:-70; %toutes les reponses possibles de 1009 a -70; vecteur de 84 elements
% 
% for idx = 1:length(array);
% position = num2str(array(idx));
% end

%% Calcul mental 


% [string,terminatorChar] = GetEchoString(window,msg,x,y,[textColor],[bgColor],[useKbCheck=0],[deviceIndex],[untilTime=inf],[KbCheck args...]);
part_resp = str2num(GetEchoString2(w, msg, xCenter, yCenter, [0 0 0],[], 1, []));

pas = 13;
duration_max = 7.5;

% part_resp = input('1022-13 :');
msg1 = ['bonne reponse'];
msg2 = ['mauvaise reponse, veuillez recommencer au debut.'];
msg3 = ['time out! veuillez recommencer au debut.'];
 
compteur = 1022;
tic
while true 
    
    b = toc;
    
    if part_resp == compteur-13 && (duration_max-b) > 0
       compteur=compteur-13;
       tic
        disp(msg1)
        part_resp = input([num2str(compteur) '-13 :']);      
        
     elseif (duration_max-b) == 0 || (duration_max-b) < 0
         
        disp(msg3)
        compteur = 1022;
        tic
        part_resp = input([num2str(compteur) '-13 :']);   
        
    elseif isempty(part_resp)
        part_resp = timeinput(duration_max,'1022');
        compteur = 1022;
        tic
        disp(msg2)
        part_resp = input([num2str(compteur) '-13 :']);
    else 
        compteur = 1022;
        tic
        disp(msg2)
        part_resp = input([num2str(compteur) '-13 :']);
    end
end