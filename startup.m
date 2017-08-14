function startup

% drawnow;pause(1);

antpath='o:\antx'  ;%replace path with yours

clc
disp(['<a href="matlab: cd(''' antpath ''');antlink">' 'add paths of [ANT-TBX]' '</a>' ' this adds all paths of ANT-Toolbox']);
disp('    ..if done: move to your mouse-data-folder, than type "ant" and load/create the study-project');
disp(['   ..to remove path of [ANT-TBX] from matlab path list type antlink(0)']);