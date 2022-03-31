function [int,label] = f_Cmdl_Select_Item(high,low,descr)
%F_CMDL_SELECT_ITEM - Request the user to select an integer. Manage selection out of 
%                        boundaries and can optionally display a description for each integer 
%                        within the interval [low,high]
%
% SYNOPSIS: [int,label] = f_Cmdl_Select_Item(high,low,descr)
%
% INPUTS:
%    high - Selected number must be smaller or equal to this number.
%     low - (optional) Selected number must be greater or equal to this number. Default=1
%   descr - (optional) Cell array of descriptions associated to each integer in the 
%           interval [low,high]. Default=none
%
% OUTPUTS:
%     int - A valid integer within the requested limits
%   label - The description associated with the selected choice
%
% Required files:
%
%
% EXAMPLES:
%
%
% REMARKS:
%   TODO: add an option to assign aliases to answers
% See also 
%
% Copyright Tomy Aumont

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created with:
%   MATLAB ver.: 9.10.0.1669831 (R2021a) Update 2 on
%    Microsoft Windows 10 Home Version 10.0 (Build 19042)
%
% Author:     Tomy Aumont
% Work:       
% Email:      tomy.aumont@umontreal.ca
% Website:    
% Created on: 06-Jul-2021
% Revised on:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int = [];
label = [];

warning('off', 'backtrace')
warning('DEPRECATED: Function is no longer supported. Use f_Cmdl_Select_Item(...) instead.')
warning('on', 'backtrace')


% Parse/check inputs
if nargin==1
    if iscellstr(high) || isstring(high)
        % 1st argument is a lsit of item's description to select
        descr = high;
        if isstring(high)
            high = 1;
        else
            high = numel(descr);
        end
    end
    low = 1;
end
if isempty(low), low=1; end
if high<low
    error('"high" value (%d) must be greater than "low" value (%d)!', high, low)
end
nChoices = high - low + 1;
if nargin<3 && ~exist('descr','var'), descr = []; end
if ~isempty(descr) && (numel(descr) ~= nChoices)
    error('"descr" must have (high-low+1)=%d elements or none, you gave %d', nChoices, numel(descr))
end

% Request selection
sf_Display_Choices(high,low,descr)
iChoice = input('  Your choice: ', 's');
if isempty(iChoice)
    return; % Select default if pressed ENTER without values
end
while (~isnan(str2double(iChoice)) && (str2double(iChoice)<low || str2double(iChoice)>high) || ...
        isnan(str2double(iChoice)) && ~ismember(iChoice, descr))
    fprintf(2, 'Answer must be in the interval [%d-%d] or [%s]\n', low, high, strjoin(descr, '|'))
    sf_Display_Choices(high, low, descr)
    iChoice = input('  Your choice: ', 's');
    if isempty(iChoice), iChoice = low; end % Select default if pressed ENTER without values
end

% Assign outputs
if isnan(str2double(iChoice))
    % Answer is member of the description choices, not a number.
    [~, int] = ismember(iChoice, descr);
    label = iChoice;
else
    % Answer is a number, not part of the description choices
    int = str2double(iChoice);
    if ~isempty(descr)
        label = descr{int};
    else
        label = [];
    end
end

end % main end

function sf_Display_Choices(high,low,descr)
    % Display choice descriptions
    fprintf('Select a number [%d-%d] (default=%d)\n',low,high,low)
    if ~isempty(descr)
        for iC = low:high
            fprintf('\t%d. %s\n',iC, descr{iC});
        end
    end
end