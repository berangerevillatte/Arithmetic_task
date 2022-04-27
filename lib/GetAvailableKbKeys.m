function varargout = GetAvailableKbKeys()
%F_GET_AVAILABLE_KBKEYS

KbName('UnifyKeyNames');

spaceKey = KbName('space');
escapeKey = KbName('ESCAPE');
cancelKey = KbName('c');

% Restrict KbCheck et al. functions to only these keys
RestrictKeysForKbCheck([spaceKey, escapeKey, cancelKey]);

% Assign output in requested format
if nargout==1
    varargout = {struct('next', spaceKey, 'quit', escapeKey, 'cancel', cancelKey)};
elseif nargout==3
    varargout = {spaceKey, escapeKey, cancelKey};
end
