function [label_L, label_R, scale_title] = GetScaleLabel(scale_type, lang)
%F_GET_SCALE_LABELS - Select the scale min/max labels and title
%
% SYNOPSIS: [label_L, label_R, scale_title] = f_Get_Scale_Labels(scale_type, lang);
%
% INPUTS:
%    scale_type - The type of scale to get label for. See f_Get_Scoring_Scale()
%          lang - Language to return the labels in. Cna be 'fr' or 'en'
%
% OUTPUTS:
%       label_L - Label to put on the left of the slider
%       label_R - Label to put on the right of the slider
%   scale_title - Title to the slider scale
%
% Required files:
%
%
% EXAMPLES:
%
%
% REMARKS:
%
% See also f_Get_Scoring_Scale
%
% Copyright Tomy Aumont

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created with:
%   MATLAB ver.: 9.12.0.1832598 (R2022a) Prerelease on
%    Microsoft Windows 10 Home Version 10.0 (Build 19042)
%
% Author:     Tomy Aumont
% Work:       
% Email:      tomy.aumont@umontreal.ca
% Website:    
% Created on: 19-Jan-2022
% Revised on:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch lower(scale_type)
    case 'appreciation'
        if strcmpi(lang, 'en')
            label_L = 'Pleasant';
            label_R = 'Unpleasant';
            scale_title = ['Evaluate your ' upper(scale_type)];
        elseif strcmpi(lang, 'fr')
            label_L = 'Plaisant';
            label_R = 'Déplaisant';
            scale_type = 'APPRÉCIATION';
            scale_title = ['Évaluez votre ' scale_type];
        else
            error('%s : Unknown language "%s"', mfilename, lang)
        end

    case 'intensity'
        if strcmpi(lang, 'en')
            label_L = 'Inaudible';
            label_R = 'Too loud';
            scale_title = ['Evaluate ' upper(scale_type)];
        elseif strcmpi(lang, 'fr')
            label_L = 'Inaudible';
            label_R = 'Trop fort';
            scale_type = 'INTENSITÉ';
            scale_title = ['Évaluez l''' scale_type];
        else
            error('%s : Unknown language "%s"', mfilename, lang)
        end
    
    case 'stress'
        if strcmpi(lang, 'en')
                label_L = ['Not stressed at all (0)'];
                label_R = ['Extremely stressed (10)'];
                scale_title = ['Evaluate your stress level for the last 5 minutes'];
        elseif strcmpi(lang, 'fr')
                label_L = ['Pas du tout stressé (0)'];
                label_R = ['Extrêmement stressé (10)'];
                scale_title = ['Évaluez votre niveau de STRESS durant les 5 dernières minutes:'];
        else
                error('%s : Unknown language "%s"', mfilename, lang)
        end
end

