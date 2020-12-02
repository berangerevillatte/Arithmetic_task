%% Instructions
Screen('TextSize', windowPtr, 30);
Screen('TextFont', windowPtr , 'Times New Roman Bold');
Inst_1 = ['Vous allez effectuer une tâche de calcul mental.'];
DrawFormattedText(windowPtr,Inst_1,'center', yCenter-300, 255);
Screen('Flip', windowPtr, [], 1);

Screen('TextFont', windowPtr , 'Times New Roman');
% Inst_1 = ['Vous allez effectuer une tâche de calcul mental.';

Inst_2 = ['Instruction : Vous devrez toujours soustraire le même nombre. Vous avez 5 minutes pour arriver à 0'];
DrawFormattedText(windowPtr,Inst_2, 'center', yCenter-200, 255);
Screen('Flip', windowPtr, [], 1);

Inst_3 = ['Par exemple :'];
DrawFormattedText(windowPtr,Inst_3, xCenter-200, 'center', 255);
Screen('Flip', windowPtr, [], 1);

Screen('TextSize', windowPtr, 50);
Screen('TextFont', windowPtr , 'Times New Roman Bold');
Inst_4 = ['1078 - 17 ?' ,newline, 'Réponse : 1061'];
DrawFormattedText(windowPtr,Inst_4, xCenter, 'center', 255);
Screen('Flip', windowPtr, [], 1);

Screen('TextSize', windowPtr, 30);
Screen('TextFont', windowPtr , 'Times New Roman');
Inst_5 = ['puis soustrayez encore 17, puis encore 17, et ainsi de suite.'];
DrawFormattedText(windowPtr,Inst_5, 'center', yCenter+100, 255);
Screen('Flip', windowPtr, [], 1);

Screen('TextSize', windowPtr, 50);
Screen('TextFont', windowPtr , 'Times New Roman Bold');
Inst_6 = ['Réponse : 1044',newline,'Réponse : 1027',newline,'...etc.'];
DrawFormattedText(windowPtr,Inst_6, xCenter-100, yCenter+200, 255);
Screen('Flip', windowPtr, [], 1);

Screen('TextSize', windowPtr, 30);
Screen('TextFont', windowPtr , 'Times New Roman');
Inst_7 = ['A chaque fois, vous n''aurez que 7.5 secondes pour repondre.',...
    newline,newline,'Le but est d''arriver à 0. Vos reponses seront enregistrées.',newline,newline,...
    newline,newline,'Pour continuez, appuyer sur "Entrer"'];
DrawFormattedText(windowPtr,Inst_7, 'center', yCenter+300, 255);
Screen('Flip', windowPtr, [], 1);

KbTriggerWait(KbName('return'), []);

Inst_8 = ['Il est donc important que vous soyez rapide et précis',newline,'puisque s''il y a une erreur, vous devrez recommencer au début.'...
    ,newline,newline,newline,newline,...
    'Appuyez sur "Entrer" pour débuter l''entrainement de 1 minute'];
DrawFormattedText(windowPtr,Inst_8, 'center', 'center', 255);
Screen('Flip', windowPtr);

KbTriggerWait(KbName('return'), []);

% 
% 
% fixRect2 = [rect(3)/2 yCenter-500 xCenter+225 yCenter-290];
%     Screen('fillRect', windowPtr, 255, fixRect2);
%     Screen('flip', windowPtr, 1, 1);