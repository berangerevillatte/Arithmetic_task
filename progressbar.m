n = 500;
progBar = ProgressBar(n,'computing…');
for tmp = 1:n
progBar(tmp);
pause(.01)
end