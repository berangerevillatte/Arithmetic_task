
clear all
clc
%Assign value from an input string to specific vector positions

SubjectCode = input('Enter participant code: ','s');
if isempty(SubjectCode)
  SubjectCode = 'trial';
end
% %% Create a vector of zeros
% x = zeros(1,5);
% i = 0;
% for i = 1:5
%     i = i+1;
%     x(i) = input('enter a number');
% end
% x = x(1:i)
% 
% FileName = [SubjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
% xlswrite(FileName, x)

%% Calcul mental
% [string,terminatorChar] = GetEchoString(window,msg,x,y,[textColor],[bgColor],[useKbCheck=0],[deviceIndex],[untilTime=inf],[KbCheck args...]);
part_resp = input('1022 - 13 :');
pas = 13;
duration_max = 7.5;

% part_resp = input('1022-13 :');
msg1 = ['bonne reponse'];
msg2 = ['mauvaise reponse, veuillez recommencer au debut.'];
msg3 = ['time out! veuillez recommencer au debut.'];

x = zeros(1,5);
i = 0;
compteur = 1022;
i = 1:300;
tic
while true 
    
    b = toc;
    
    if part_resp == compteur-13 & (duration_max-b) > 0
       compteur=compteur-13;
       x(i) = 1;
       i = i+1;
       
       tic
       disp(msg1)
       part_resp = input([num2str(compteur) '-13 :']);      
        
     elseif (duration_max-b) == 0 || (duration_max-b) < 0
         
        disp(msg3)
        compteur = 1022;
        x(i) = 0;
        i = i+1;

        tic
        part_resp = input([num2str(compteur) '-13 :']);   
        
    else 
        compteur = 1022;
        x(i) = 0;
%         i = i+1;
        
        tic
        disp(msg2)
%         part_resp = input([num2str(compteur) '-13 :']);
        break;        
    end
end

x = x(1:i);

FileName = [SubjectCode,'_', datestr(now,'dd-mm-yyyy')]; 
xlswrite(FileName, x)