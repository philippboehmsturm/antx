
%% SET PATHS For freiburg tools
% setpath or setpath(1)    : SETS PATHS For freiburg tools
% setpath(0)                       :REMOVES PATHS For freiburg tools

function setpath(arg)

warning off;
 
if exist('arg')==0; arg=1; end

if arg==1
    addpath(genpath(fullfile(pwd,'matlab', 'matlab_new')))
    addpath(genpath(fullfile(pwd,'matlab', 'diffusion')))
    addpath(genpath(fullfile(pwd,'matlab', 'spm8')))
    
    addpath( fullfile(pwd, 'allen'))
    addpath( fullfile(pwd, 'fiberViewer3D'))
    addpath( fullfile(pwd, 'AMA'))
    
%     disp('PATHS of freiburg-tools added to pathlist');
    disp('..PATHS:  [matlabToolsFreiburg] added to matlab-path >> useful GUIS: AMA_gui2 , atlasbrowser , fiberViewer3D  , Startgui_fv3d');

else
    
    rmpath(genpath(fullfile(pwd,'matlab', 'matlab_new')))
    rmpath(genpath(fullfile(pwd,'matlab', 'diffusion')))
    rmpath(genpath(fullfile(pwd,'matlab', 'spm8')))
    
    rmpath( fullfile(pwd, 'allen'))
    rmpath( fullfile(pwd, 'fiberViewer3D'))
    rmpath( fullfile(pwd, 'AMA'))
    
       disp('PATHS of freiburg tools removed from pathlist');
    
end

warning on;

%% gui main function
%atlas:     atlasbrowser(allen): BrAt_StartGui
% ama:             automaticMouseAnalyzer  : AMA_gui2      
% visualization:  fiberViewer3D
% Startgui_fv3d:  fmri+restingState netzwerke


% k=dir(pwd);
% k(1:2)=[];
% k([k(:).isdir]==0)=[];
% 
% for i=1:length(k)
%     addpath(genpath(pwd,k(i).name));
% end
