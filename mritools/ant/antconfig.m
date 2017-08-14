

function varargout=antconfig(showgui,varargin)

% varargin : with parameter-pairs
% currently:
%    'parameter'  'default'  ...load default parameter (i.e. overrides global "an" struct )
%        otherwise use an struct
%      'savecb' 'yes'/'no'   ...show save checkbox, default is 'yes'
% antconfig(1,'parameter','default','savecb','no')
% antconfig(1,'parameter','default')
% antconfig(1)





if  exist('showgui')~=1 ; showgui=1; end

%% additional parameters
para=struct();
if ~isempty(varargin)
    para=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
end

if isfield(para,'parameter') && strcmp(getfield(para,'parameter'),'default') ==1
    an=struct();
else
    global an
end




[pant r]=   antpath;


p={...
'inf99'      '*** CONFIGURATION PARAMETERS   ***              '                         '' ''
'inf100'     '==================================='                          '' ''
'inf1'       '% DEFAULTS         '  '' ''
'project'    'NEW PROJECT'   'PROJECTNAME OF THE STUDY (arbitrary tag)'    ''
'datpath'    '<MANDATORY TO FILL>'   'studie''s datapath, MUST BE be specified, and named "dat", such as "c:\b\study1\dat" '  'd'
'voxsize'     [.07 .07 .07]   'voxelSize (default is [.07 .07 .07])'    cellfun(@(a) {repmat(a,1,3)},   {' .01' ' .03' ' .05' ' .07'}')
'inf2'       '% WARPING         '                                    ''  ''
'wa.refTPM'      r.refTPM           'c1/c2/c3-compartiments (reference)' ,'mf'
'wa.ano'         r.ano 'reference anotation-image' 'f'
'wa.avg'         r.avg 'reference structural image' 'f'
'wa.fib'         r.fib 'reference fiber image' 'f'
'wa.refsample'  r.refsample 'a sample image in reference space' 'f'
'wa.create_gwc'         1         'create overlay gray-white-csf-image (recommended for visualization) ' 'b'
'wa.create_anopcol'     1         'create pseudocolor anotation file (recommended for visualization) ' 'b'
'wa.cleanup'            1         'delete unused files in folder' 'b'
'wa.usePCT'             2         'use Parallel Computing toolbox (0:no/1:SPMD/2:parfor) ' {1,2,3}
'wa.usePriorskullstrip' 1         'use a priori skullstripping'  'b'
% 'wa.autoreg'            1         'automatic registration (0:manual, 1:automatic)' 'b'
'wa.elxParamfile'     {...
which('Par0025affine.txt');
which('Par0033bspline_EM2.txt')}  'ELASTIX Parameterfile'  'mf'
'wa.elxMaskApproach'        1        'currently the only approach available (will be more soon)'    ''
'wa.tf_ano'                 1        'create "ix_ANO.nii" (template-label-image)                       in MOUSESPACE (inverseTrafo)'     'b'
'wa.tf_anopcol'             1        'create "ix_ANOpcol.nii" (template-pseudocolor-label-image label) in MOUSESPACE (inverseTrafo)'     'b'
'wa.tf_avg'                 1        'create "ix_AVGT.nii" (template-structural-image)                 in MOUSESPACE (inverseTrafo)'     'b'
'wa.tf_refc1'               1        'create "ix_refIMG.nii" (template-grayMatter-image)               in MOUSESPACE (inverseTrafo)'     'b'
'wa.tf_t2'                  1        'create "x_t2.nii" (mouse-t2-image)                         in TEMPLATESPACE (forwardTrafo)'     'b'
'wa.tf_c1'                  1        'create "x_c1t2.nii" (mouse-grayMatter-image)               in TEMPLATESPACE (forwardTrafo)'     'b'
'wa.tf_c2'                  1        'create "x_c2t2.nii" (mouse-whiteMatter-image)              in TEMPLATESPACE (forwardTrafo)'     'b'
'wa.tf_c3'                  1        'create "x_c3t2.nii" (mouse-CSF-image)                      in TEMPLATESPACE (forwardTrafo)'     'b'
'wa.tf_c1c2mask'            1        'create "x_c1c2mask.nii" (mouse-gray+whiteMatterMask-image) in TEMPLATESPACE (forwardTrafo)'     'b'
};


p2=paramadd(p,an);%add/replace parameter

if showgui==1
    
    if isfield(para,'savecb') && strcmp(getfield(para,'savecb'),'no') ==1
        cb1string='';
    else
        cb1string='save settings as studie''s confogfile';
    end
    
%     [m z a params]=paramgui(p2,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .6 .5 ],...
%         'title','SETTINGS','pb1string','OK','cb1string','save settings as studie''s confogfile');
    
    figpos=[0.1688    0.3000    0.8073    0.6111];
    [m z a params]=paramgui(p2,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',figpos,...
        'title','SETTINGS','pb1string','OK','cb1string',cb1string);
    
    if params.cb1==1
        [fi, pa] = uiputfile(fullfile(pwd,'*.m'), 'save as configfile (example "project_study1")');
        if pa~=0
            pwrite2file(fullfile(pa,fi),m);
        end
    end
else
    z=[];
    for i=1:size(p2,1)
        eval(['z.' p2{i,1} '=' 'p2{' num2str(i) ',2};']);
    end
    
end

%% aditional variables
z.templatepath=fullfile(fileparts(z.datpath),'templates');
z.ls=struct2list(z);
try;
   z.mdirs=an.mdirs ;
end

an=z;
%set Listbox-2
ls=an.ls;
ls(regexpi2(ls,'^\s*z.inf\d'))=[];
ls(regexpi2(ls,'^\s*z.mdirs'))=[];
ls=regexprep(ls,'^\s*z.','');
set(findobj(findobj('tag','ant'),'tag','lb2'),'string',ls);


try
    varargout{1}=m;
end

try
    varargout{2}=z;
end
try
    varargout{3}=a;
end
try
    varargout{4}=params;
end





