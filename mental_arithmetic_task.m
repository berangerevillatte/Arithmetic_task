AssertOpenGL

screens=Screen('screens'); %repère les écrans
screenNumber=max(screens); %cherche écran secondaire

%Pour s'adapter à tous les écrans
[width_in_mm, height_in_mm]=Screen('DisplaySize', screenNumber);
resolution= Screen('Resolution', screenNumber);
pixel_in_mm = width_in_mm/resolution.width;
hz=Screen('FrameRate', screenNumber);

% ouvre l'écran. Mettre la couleur en Red Green Blue [RGB]
couleur_ecran=[49 140 231];%Ecran bleu 
[windowPtr, rect]=Screen('OpenWindow',screenNumber, couleur_ecran); 
%Determiner dimension et position du rectangle
fromH=resolution.width/4;
fromV=resolution.height/4;
toH=fromH*3;
toV=fromV*3;
%Dessiner un rectangle coin haut gauche
Screen('FillRect', windowPtr, [0 255 0], [fromH, fromV, toH, toV]);
Screen('Flip', windowPtr);
Screen('Preference', 'SkipSyncTests', 1); 
WaitSecs(3);
sca;
%fonction sur écran secondaire mais pas principal même en changeant l.4 
%avec screenNumber=min(screens);
