function calcul = calculer(position)
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
   
    Screen('DrawText', w, msg1, 'center', 'center', [0 0 0],[],[],[]);
else 
    Screen('DrawText', w, msg2, 'center', 'center', [0 0 0],[],[],[]);
end
Screen('Flip', w);
Screen('CloseAll')
end


%% Essai boucle
% msg1 = ['Bonne reponse']; %positive feedback
% msg2 = ['Mauvaise reponse. Veuillez recommencer du debut.']; %negative feedback
% 
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
% msg1 = ['Bonne reponse']; %positive feedback
% msg2 = ['Mauvaise reponse. Veuillez recommencer du debut.']; %negative feedback
% 
% depart=1022;
% pas=-13;
% fin=-70;
% i=depart:pas:fin;
% part_resp=input('your answer :');
% 
% accuracy(1) = part_resp == i-13;
% accuracy(0) = part_resp >= i-13 | part_resp < i-13;
% 
% i=depart:pas:fin;
% 
% while  true 
%     accuracy = 1
% %     if part_resp == i-13;
%     disp(msg1) 
%     if accuracy = 0 
%         disp(msg2)
%     end
% end
% 
% %% "rih
% msg1 = ['Bonne reponse']; %positive feedback
% msg2 = ['Mauvaise reponse. Veuillez recommencer du debut.']; %negative feedback
% 
% 
% depart = 1022;
% pas = -13;
% fin = -70;
% i=depart:pas:fin;
% 
% 
% % % output = [' ', string];
% % % participantreponse = GetEchoString(w, output, 'center', 'center', [0 0 0], [], [], [])
% % %  answer = str2num(participantreponse)
%  
% part_resp = input('1022-13')
%  accuracy(1) = part_resp == i-13;
%  accuracy(0) = part_resp >= i-13 | part_resp < i-13;
% 
% 
%  while true 
%     if accuracy = 1
%         disp(msg1) ;
%     elseif accuracy = 0
%         disp(msg2);
%     end
% end
% 
% 
% 
% clear all
% clc
% msg1 = ['Bonne reponse']; %positive feedback
% msg2 = ['Mauvaise reponse. Veuillez recommencer du debut.']; %negative feedback
%  
% depart = 1022;
% pas = -13;
% fin = -70;
% bonne_rep=depart-13;
% part_resp = input([num2str(depart) '-13 :']);
% 
% depart;
% 
% while true
%     part_resp = input([num2str(depart) '-13 :']);
% 
% i = depart:pas:fin;
% position = 1:length(i);
% % bonne_rep = i-13;
% % end
% 
% accuracy(position) = bonne_rep == part_resp;
% 
%       
% %     for i = depart:pas:fin;
% %     position = 1:length(i);     
%     % answer = str2num(part_resp);
%     %  accuracy(i) = part_resp == i(bonne_rep);
% %  accuracy = part_resp >= i(bonne_rep) | part_resp < i(bonne_rep);
%          if accuracy(position) == 1
%                 disp(msg1)
%                 depart=depart-13;
%                 part_resp = input([num2str(depart) '-13 :']);
%          else
%                 disp(msg2)
%                 depart;
%  end
% end


%% Selon conseil Simon, revenir à 0 dans while loop
compteur = 1022;
part_resp = input('1022-13 :');
% correct = part_resp == compteur-13;
% incorrect = part_resp >= compteur-13 | part_resp < compteur-13;
msg1 = ['bonne reponse'];
msg2 = ['mauvaise reponse, veuillez recommencer au debut.'];

compteur = 1022;
while true 
    if part_resp == compteur-13
        compteur=compteur-13;
        disp(msg1)
        part_resp = input([num2str(compteur) '-13 :']);
elseif part_resp >= compteur-13 || part_resp < compteur-13;
    disp(msg2)
    compteur = 1022;
    part_resp = input([num2str(compteur) '-13 :']);
end
end
end
