function output = timeinput(t,default_string)
% TIMEINPUT
% Input arguments:  
% t - time delay
% default_string - string which is returned if nothing is entered
%
% Examples:
% If a string is expected
%   x = timeinput(20,'no input')
% If a number is expected
%   x = str2num(timeinput(20,'1'))
%    

if nargin == 1
   default_string = '';
end
% Creating a figure
h = figure('CloseRequestFcn','','Position',[500 500 200 50],'MenuBar','none',...
    'NumberTitle','off','Name','Please insert...');
% Creating an Edit field
hedit = uicontrol('style','edit','Units','pixels','Position',[10 15 180 20],'callback','uiresume','string',default_string);
% Defining a Timer object
T = timer('Name','mm', ...
   'TimerFcn','uiresume', ...
   'StartDelay',t, ...
   'ExecutionMode','singleShot');
% Starting the timer
start(T)
uiwait(h)
% Defining the return value
output = get(hedit,'String');
% Deleting the figure
delete(h)
% Stopping and Deleting the timer
stop(T)
delete(T)
end