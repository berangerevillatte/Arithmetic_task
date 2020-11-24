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

Screen('Flip', w);



% %% 
% Essai boucle
% msg1 = ['Bonne reponse']; %positive feedback
% msg2 = ['Mauvaise reponse. Veuillez recommencer du debut.']; %negative feedback
% cor = imread('correct.png');
% incor = imread('incorrect.png');

% for i=1022:-13:-70;
%     part_resp=input([num2str(i) '-13 : ']);
%    if part_resp == i -13;
%         disp(msg1)
%         figure, imshow(cor); %ok
%    else
%         disp(msg2)
%         imshow(incor); %ok
%         for i=1022:-13:-70;
%             part_resp=input([num2str(i) '-13 : ']);
%            if part_resp == i -13; 
%                 disp(msg1)
%                 imshow(cor);
%             else
%                 disp(msg2)
%                 imshow(incor); %ok
%                 for i=1022:-13:-70;
%                     part_resp=input([num2str(i) '-13 : ']);
%                    if part_resp == i -13;
%                         disp(msg1)
%                         imshow(cor);
%                     else
%                         disp(msg2)
%                         imshow(incor);
%                    end 
%                 end
%            end
%         end
%    end
% end

%% autre essai (comment revenir a 1022?)
    
clear all

clc

msg1 = ['Bonne reponse']; %positive feedback

msg2 = ['Mauvaise reponse. Veuillez recommencer du debut.']; %negative feedback

 

depart = 1022;

pas = -13;

fin = -70; 

while true   

    for i = depart:pas:fin;

    position = 1:85;     

    % answer = str2num(part_resp);

    part_resp = input([num2str(i) '-13 :']);

    bonne_rep = i-13;

    accuracy(position) = bonne_rep == part_resp;

  

%  accuracy(i) = part_resp == i(bonne_rep);

%  accuracy = part_resp >= i(bonne_rep) | part_resp < i(bonne_rep);

         if accuracy(position) == 1

                disp(msg1)                

         else

                disp(msg2)             

 end

end

end
end

% output = [' ', string];
% participantreponse = GetEchoString(w, output, 'center', 'center', [0 0 0], [], [], [])
% answer = str2num(participantreponse)
% 
% bonnereponse = 1009
% 
% bonnereponse == answer
% 
% answer = str2num('1009'); bonnereponse = 1009;
% accuracy(1) = bonnereponse == answer
% answer 
% 



        