clc
clear all
%% Calcul mental
% [string,terminatorChar] = GetEchoString(window,msg,x,y,[textColor],[bgColor],[useKbCheck=0],[deviceIndex],[untilTime=inf],[KbCheck args...]);
% part_resp = input('1022 - 13 :');
pas = 13;
duration_max = 7.5;

part_resp = input('1022-13 :');
msg1 = ['bonne reponse'];
msg2 = ['mauvaise reponse, veuillez recommencer au debut.'];
msg3 = ['time out! veuillez recommencer au debut.'];


Task_duration = 300; % min 1sec
% x = zeros(1,5); %create a vector of zeros (at least the min number of trials)
% i = 0; %the first iteration starts at 0
compteur = 1022; 
trials=0;
for trials = 1:Task_duration
    tic
    trials = trials+1;
    %maximum of trials, 1 per second for 5min (300 sec)

    while (GetSecs-StartSecs) < duration_max
        if part_resp == compteur-13
            compteur = compteur-13;
            answer(trials) = 1;
%             trials = trials+1;
            disp(msg1)
            part_resp = input([num2str(compteur) '-13 :']);
             
        else
            disp(msg2)

            compteur = 1022;
    %         trials = trials+1;
            answer(trials) = 0;
            part_resp = input([num2str(compteur) ' - 13 :']);
        end 
    end
    
    while (GetSecs-StartSecs) == duration_max || (GetSecs-StartSecs) > duration_max
        disp(msg3)

        compteur = 1022;
%         trials = trials+1;
        answer(trials)= 0;
        part_resp = input([num2str(compteur) '- 13 :']);

    end
end
