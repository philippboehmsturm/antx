


function loadspmmouse

 mtlbfolder = which('spmmouse');
    sprts = findstr(mtlbfolder,filesep);
    mtlbfolder=fullfile(mtlbfolder(1:sprts(end)),'mouse-C57.mat');
    spmmouse('load',mtlbfolder);