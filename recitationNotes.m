fullscreen = get(0,'ScreenSize');

text(0.6,20000, ['put a string vector here' num2Str(anumbertoadd)].....) %for annotations. first two arguments specify the position on the plot corresponding to axis values you have
    %can use ratios of maximum lengths of axes

axis tight %force it to align all the way to the edge of the window

%ylim gives limit of y axis