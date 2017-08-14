function varargout = tbxvol_changeSPM(bch)
% Change path names or byte order of image files in SPM structure
% FORMAT tbxvol_changeSPM(bch)
% ======
% Input arguments:
% bch.srcspm  - file name of SPM.mat files to change
% bch.chpaths - which paths to change: one of
%               - .dpaths - data files
%               - .apaths - analysis files
%               - .bpaths - both
%               - .npaths - none
%                 .{d,a,b}paths.oldpath - path component to be replaced OR
%                 - "auto" automatically determine component
%                 - "ask"  automatically determine component, but ask before
%                   replacing
%               - .{d,a,b}paths.newpath - path component to be inserted OR
%                 - "auto" automatically determine component
%                 - "ask"  automatically determine component, but ask before
%                   replacing
% bch.swap    - swap byte order code of volume datatypes
%
% For all absolute references in SPM.xY occurences of oldpath are
% replaced by newpath (using Matlab strrep). This will only work if the
% overall structure of the file tree has not changed (i.e. moving an
% entire analysis dir will work, but not renaming each individual
% subject). In addition, byte order information of mapped files can be
% changed without touching other file information (such as scaling,
% dimensions etc).
% The new SPM struct is saved to the original SPM.mat file. A copy of the
% original SPM.mat is kept in the same directory under the filename
% SPM.mat.save.
% Multiple SPM.mat file names can be given, and the same string
% replacement will be done for all of them.
%
% This function is part of the volumes toolbox for SPM5. For general help
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_changeSPM.m 714 2010-07-30 14:28:55Z glauche $

rev = '$Revision: 714 $';
funcname = 'Change SPM.mat paths';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

load(bch.srcspm{1});
% save a copy
[newp n e] = fileparts(bch.srcspm{1});
save_cfg=fullfile(newp, [n e '.save']);
if spm_matlab_version_chk('7') < 0
    save(save_cfg, '-mat', 'SPM');
else
    save(save_cfg, '-mat', '-V6', 'SPM');
end;

chpaths = fieldnames(bch.chpaths);
if ~strcmp(chpaths{1},'npaths')
    if isfield(SPM,'swd')
        oldp = SPM.swd;
    else
        if iscell(SPM.xY.P)
            [oldp n e v] = spm_fileparts(SPM.xY.P{1});
        else
            [oldp n e v] = spm_fileparts(SPM.xY.P(1,:));
        end;
    end;
    
    % try to be smart in finding leading path differences
    % first, tokenise paths
    ot={};
    [op ot{end+1}] = fileparts(oldp);
    while ~isempty(ot{end})
        [op ot{end+1}] = fileparts(op);
    end;
    ot=ot(1:end-1);
    nt={};
    [np nt{end+1}] = fileparts(newp);
    while ~isempty(nt{end})
        [np nt{end+1}] = fileparts(np);
    end;
    nt=nt(1:end-1);
    
    commp='';
    for k=1:min(numel(nt),numel(ot))
        if strcmp(nt{k},ot{k})
            commp=fullfile(nt{k},commp);
        else
            break;
        end;
    end;
    oldp = strrep(oldp,commp,'');
    newp = strrep(newp,commp,'');
    
    switch bch.chpaths.(chpaths{1}).oldpath
        case 'ask',
            bch.chpaths.(chpaths{1}).oldpath = spm_input('Replace path component','!+1','s',oldp);
        case 'auto',
            bch.chpaths.(chpaths{1}).oldpath = oldp;
    end;
    switch bch.chpaths.(chpaths{1}).newpath
        case 'ask',
            bch.chpaths.(chpaths{1}).newpath = spm_input('Insert path component','!+1','s',newp);
        case 'auto',
            bch.chpaths.(chpaths{1}).newpath = newp;
    end;
    if strcmp(chpaths{1},'dpaths')||strcmp(chpaths{1},'bpaths')
        if iscell(SPM.xY.P)
            oldP=SPM.xY.P;
        else
            oldP=cellstr(SPM.xY.P);
        end;
        
        newP = cell(size(oldP));
        for k=1:numel(oldP)
            fprintf('Old file name: %s\n', oldP{k});
            newP{k}=strrep(oldP{k},bch.chpaths.(chpaths{1}).oldpath,...
                bch.chpaths.(chpaths{1}).newpath);
            SPM.xY.VY(k).fname=strrep(SPM.xY.VY(k).fname,...
                bch.chpaths.(chpaths{1}).oldpath,...
                bch.chpaths.(chpaths{1}).newpath);
            fprintf('New file name: %s\n', newP{k});
        end
        if iscell(SPM.xY.P)
            SPM.xY.P=newP;
        else
            SPM.xY.P=char(newP);
        end;
    end;
    if strcmp(chpaths{1},'apaths')||strcmp(chpaths{1},'bpaths')
        % strip paths from SPM analysis files
        try
            [p n e v] = spm_fileparts(SPM.xVol.VRpv.fname);
            SPM.xVol.VRpv.fname = [n e v];
        end;
        for cb = 1:numel(SPM.Vbeta)
            try
                [p n e v] = spm_fileparts(SPM.Vbeta(cb).fname);
                SPM.Vbeta(cb).fname = [n e v];
            end;
        end;
        try
            [p n e v] = spm_fileparts(SPM.VResMS.fname);
            SPM.VResMS.fname = [n e v];
        end;
        try
            [p n e v] = spm_fileparts(SPM.xM.VM.fname);
            SPM.xM.VM.fname = [n e v];
        end;
        for cc = 1:numel(SPM.xCon)
            try
                [p n e v] = spm_fileparts(SPM.xCon(cc).Vcon.fname);
                SPM.xCon(cc).Vcon.fname = [n e v];
            end
            try
                [p n e v] = spm_fileparts(SPM.xCon(cc).Vspm.fname);
                SPM.xCon(cc).Vspm.fname = [n e v];
            end
        end;
        % replace SPM.swd with path to SPM.mat
        [p n e v] = spm_fileparts(bch.srcspm{1});
        SPM.swd = p;
    end;
end;
if bch.swap
    try
        SPM.xVol.VRpv = swaporder(SPM.xVol.VRpv);
    end;
    try
        SPM.Vbeta = swaporder(SPM.Vbeta);
    end;
    try
        SPM.VResMS = swaporder(SPM.VResMS);
    end;
    try
        SPM.xM.VM = swaporder(SPM.xM.VM);
    end
    try
        for cc = 1:numel(SPM.xCon)
            try
                SPM.xCon(cc).Vcon = swaporder(SPM.xCon(cc).Vcon);
            end;
            try
                SPM.xCon(cc).Vspm = swaporder(SPM.xCon(cc).Vspm);
            end;
        end;
    end;
    for k = 1:numel(SPM.xY.VY)
        SPM.xY.VY(k) = swaporder(SPM.xY.VY(k));
    end;
end;

if spm_matlab_version_chk('7') < 0
    save(bch.srcspm{1},'SPM','-append');
else
    save(bch.srcspm{1},'SPM','-append','-V6');
end;

function Vo=swaporder(V)
Vo=V;
for k=1:numel(V)
    if isfield(Vo,'dt')
        Vo.dt(2) = ~Vo.dt(2);
    else
        warning(['File %s:\n Pre-SPM5-style SPM.mat. No byte ' ...
            'swapping applied.\n'], Vo.fname);
    end;
end;