function [cancel, answer, nextStim] = GetKbInstruct(lang, actionKeys)
% KbName('UnifiyKeyNames');
% actionKeys.next = 'SPACE';

if strcmpi(lang, 'en')

    if ~isempty(actionKeys.next)
        nextStim = sprintf('Press %s to validate answer', upper(KbName(actionKeys.next)));
    else
        nextStim = '';
    end
    answer = 'Click to give an answer';
    cancel = 'Change Answer: C';

elseif strcmpi(lang, 'fr')

    if ~isempty(actionKeys.next)
        nextStim = sprintf('Appuyez sur %s pour valider la reponse', upper(KbName(actionKeys.next)));
    else
        nextStim = '';
    end
    answer = 'Cliquez pour donner une réponse';
    cancel = 'Changer la Réponse: C';
    
else
    error('%s : Unknown language "%s"', mfilename, lang)
end

end