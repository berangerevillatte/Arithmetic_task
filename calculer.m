function calcul = calculer(position)
%%
%AssertOpenGL %version compatible de psychtoolbox avec GL
KbName('UnifyKeyNames');
[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
screens=Screen('screens'); %repere les ecrans
screenNumber=max(screens); %cherche ecran secondaire
Screen('Preference', 'SkipSyncTests', 1);  % put 1 if the sync test fails

%Pour s'adapter a  tous les ecrans
rect= Screen(screenNumber, 'Rect'); 
resolution= Screen('Resolution', screenNumber);
hz=Screen('FrameRate', screenNumber); %creer une frequence dimage
couleur_ecran=[100 100 100];%Ecran gris 
[w, rect]=Screen('OpenWindow',screenNumber, couleur_ecran); 
Screen('TextSize', w,[50]);
xCenter = round(rect(3)/2);
yCenter = round(rect(4)/2);

    % Creates stimulus
array = 1009:-13:-70; %toutes les reponses possibles de 1009 a -70; vecteur de 84 elements

for idx = 1:length(array);
position = num2str(array(idx));
end

output = [' ', string];
participantreponse = GetEchoString(w, output, 'center', 'center', [0 0 0], [], [], [])

msg1 = ['Bonne reponse']; %positive feedback
msg2 = ['Mauvaise reponse. Veuillez recommencer du début.']; %negative feedback

if participantreponse == '1009';
   
    Screen('DrawText', w, msg1, xCenter, yCenter, [0 0 0],[],[],[]);
else 
    Screen('DrawText', w, msg2, xCenter, yCenter, [0 0 0],[],[],[]);
end
Screen('Flip', w);
Screen('CloseAll')
end



