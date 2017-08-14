
%% link ANT-TOOLBOX
% antlink or antlink(1) to setpath of ANT-TBX
% antlink(0) to remove path of ANT-TBX

function antlink(arg)

if exist('arg')~=1
    arg=1;
end

if arg==1 %addPath
    pa=pwd;
    addpath(genpath(fullfile(pa,'freiburgLight', 'matlab', 'diffusion' ,'common')))
    addpath(genpath(fullfile(pwd,'freiburgLight', 'matlab', 'spm8')))
    addpath(genpath(fullfile(pa,'freiburgLight', 'allen')))
    
    cd(fullfile(pa,'mritools'));
    dtipath;
    cd(pa)
elseif arg==0  %remove path
    
    try
        warning off
        dirx=fileparts(fileparts(fileparts(which('ant.m'))));
        rmpath(genpath(dirx));
        disp('tom..and [ANT] removed from pathList');
        cd(dirx);
    end
    
    
end


%% OLDER VERSION
% pa=pwd;
% cd(fullfile(pa,'matlabToolsFreiburg'));
% setpath
% 
% cd(fullfile(pa,'mritools'));
% dtipath
% 
% cd(pa)

