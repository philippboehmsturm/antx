function spm_dicom_query

f=findobj(0,'tag',mfilename);
if ishandle(f)
    clf(f,'reset');
    set(f,'units','normalized','tag',mfilename, 'position',[.1 .25 .8 .5]);
else
    f=figure('units','normalized','tag',mfilename, 'position',[.1 .25 ...
        .8 .7], 'name',[spm('ver') ': DICOM query'], ...
        'numbertitle','off', 'resize','off');
end;
l=uicontrol('style','listbox', 'units','normalized', ...
    'position',[.1 .55 .8 .4], 'tag',[mfilename 'patbox'], 'max',2,...
    'fontname','bitstream vera sans mono', 'callback',@addto_selbox);

l=uicontrol('style','text', 'string','PatName Filter', 'units','normalized', ...
    'position',[.1 .50 .1 .04]);
l=uicontrol('style','edit', 'string','.*', 'units','normalized', ...
    'position',[.2 .50 .1 .04], 'tag',[mfilename 'PatNamefilt'], ...
    'callback',@filter_fill_patbox);
l=uicontrol('style','text', 'string','PatID Filter', 'units','normalized', ...
    'position',[.3 .50 .1 .04]);
l=uicontrol('style','edit', 'string','.*', 'units','normalized', ...
    'position',[.4 .50 .1 .04], 'tag',[mfilename 'PatIDfilt'], ...
    'callback',@filter_fill_patbox);

l=uicontrol('style','text', 'string','StudyName Filter', 'units','normalized', ...
    'position',[.1 .45 .1 .04]);
l=uicontrol('style','edit', 'string','.*', 'units','normalized', ...
    'position',[.2 .45 .1 .04], 'tag',[mfilename 'StuNamefilt'], 'enable','off', ...
    'callback',@filter_fill_patbox);
l=uicontrol('style','text', 'string','StudyDate Filter', 'units','normalized', ...
    'position',[.3 .45 .1 .04]);
l=uicontrol('style','edit', 'string','.*', 'units','normalized', ...
    'position',[.4 .45 .1 .04], 'tag',[mfilename 'StuDatefilt'], 'enable','off', ...
    'callback',@filter_fill_patbox);
l=uicontrol('style','text', 'string','StudyTime Filter', 'units','normalized', ...
    'position',[.5 .45 .1 .04]);
l=uicontrol('style','edit', 'string','.*', 'units','normalized', ...
    'position',[.6 .45 .1 .04], 'tag',[mfilename 'StuTimefilt'], 'enable','off', ...
    'callback',@filter_fill_patbox);

l=uicontrol('style','text', 'string','SequenceName Filter', 'units','normalized', ...
    'position',[.1 .4 .1 .04]);
l=uicontrol('style','edit', 'string','.*', 'units','normalized', ...
    'position',[.2 .4 .1 .04], 'tag',[mfilename 'SeqNamefilt'], 'enable','off', ...
    'callback',@filter_fill_patbox);
l=uicontrol('style','text', 'string','ProtocolName Filter', 'units','normalized', ...
    'position',[.3 .4 .1 .04]);
l=uicontrol('style','edit', 'string','.*', 'units','normalized', ...
    'position',[.4 .4 .1 .04], 'tag',[mfilename 'ProNamefilt'], 'enable','off', ...
    'callback',@filter_fill_patbox);

l=uibuttongroup('Title','Detail Level', 'units','normalized', ...
    'position',[.1 .31 .6 .07], 'tag',[mfilename 'level'], ...
    'SelectionChangeFcn',@update_fill_patbox);
lpat=uicontrol('parent',l, 'style','radio', 'string','Subject/Project', ...
    'units','normalized', 'position',[0 .05 1/3 .95]);
lpat=uicontrol('parent',l, 'style','radio', 'string','Study/Examination', ...
    'units','normalized', 'position',[1/3 .05 1/3 .95]);
lpat=uicontrol('parent',l, 'style','radio', 'string','Series', ...
    'units','normalized', 'position',[2/3 .05 1/3 .95]);
l=uicontrol('style','pushbutton', 'string','Update List', 'callback', ...
    @update_fill_patbox, 'units','normalized', 'position',[.7 .31 .2 .07]);

l=uicontrol('style','listbox', 'units','normalized', ...
    'position',[.1 .1 .8 .2], 'tag',[mfilename 'selbox'], 'max',2,...
    'fontname','bitstream vera sans mono', 'callback',@rmfrom_selbox, ...
    'string',{}, 'userdata',{});

l=uicontrol('style','popup', 'string',{'SPM DICOM import (Fast)', 'SPM DICOM import (Expert)'}, 'callback', ...
    @get_selected_files, 'units','normalized', 'position',[.1 .05 ...
    .15 .05], 'tag',[mfilename 'button']);
l=uicontrol('style','popup', 'string',{'DTI DICOM import (Fast)', 'DTI DICOM import (Expert)', 'DICOM Copy Tool'}, 'callback', ...
    @get_selected_files, 'units','normalized', 'position',[.3 .05 ...
    .15 .05], 'tag',[mfilename 'button']);
l=uicontrol('style','pushbutton', 'string','Export dirnames', 'callback', ...
    @get_selected_files, 'units','normalized', 'position',[.5 .05 ...
    .15 .05], 'tag',[mfilename 'button']);
l=uicontrol('style','pushbutton', 'string','Cancel', 'callback', ...
    @cancel, 'units','normalized', 'position',[.7 .05 ...
    .2 .05], 'tag',[mfilename 'button']);
update_fill_patbox;

function update_fill_patbox(varargin)
spm('pointer','watch');
query_database;
filter_patbox;
fill_patbox;
spm('pointer','arrow');

function filter_fill_patbox(varargin)
spm('pointer','watch');
filter_patbox;
fill_patbox;
spm('pointer','arrow');

function filter_patbox(varargin)
set(findobj(0, 'tag',[mfilename 'patbox']),'value',1, ...
    'string',{'Filtering results', 'Please wait...'});
drawnow;
ud  =get(findobj(0, 'tag',[mfilename 'patbox']),'userdata');
lvls=get(get(findobj(0, 'tag',[mfilename 'level']),'children'));
lvl =find(cat(1,lvls.Value));
hser = [findobj(0,'tag',[mfilename 'SeqNamefilt']),...
    findobj(0,'tag',[mfilename 'ProNamefilt'])];
hstu = [findobj(0,'tag',[mfilename 'StuNamefilt']),...
    findobj(0,'tag',[mfilename 'StuDatefilt']),...
    findobj(0,'tag',[mfilename 'StuTimefilt'])];
hpat = [findobj(0,'tag',[mfilename 'PatNamefilt']),...
    findobj(0,'tag',[mfilename 'PatIDfilt'])];

IDCOLS=ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS;
ud.sel = ~cellfun(@isempty,regexp(ud.vals(:,IDCOLS+1),get(hpat(1),'string'),'once')) & ...
    ~cellfun(@isempty,regexp(ud.vals(:,IDCOLS+2),get(hpat(2),'string'),'once'));
if lvl < 3
    ud.sel = ud.sel & ...
        ~cellfun(@isempty,regexp(ud.vals(:,IDCOLS+ud.PATCOLS+1), get(hstu(1),'string'), 'once')) & ...
        ~cellfun(@isempty,regexp(ud.vals(:,IDCOLS+ud.PATCOLS+2), get(hstu(2),'string'), 'once')) & ...
        ~cellfun(@isempty,regexp(ud.vals(:,IDCOLS+ud.PATCOLS+3), get(hstu(3), 'string'),'once'));
    if lvl < 2
        ud.sel = ud.sel & ...
            ~cellfun(@isempty,regexp(ud.vals(:,IDCOLS+ud.PATCOLS+ud.STUCOLS+2), get(hser(1),'string'), 'once')) & ...
            ~cellfun(@isempty,regexp(ud.vals(:,IDCOLS+ud.PATCOLS+ud.STUCOLS+3), get(hser(2),'string'), 'once'));
    end
end
set(findobj(0, 'tag',[mfilename 'patbox']),'userdata',ud);

function query_database(varargin)
set(findobj(0,'tag',[mfilename 'patbox']), 'value',1,...
    'string',{'Database query in progress', 'Please wait...'});
drawnow;
level={'--serieslevel','--studylevel','--patientlevel'}; % Level uis are read out in
% order opposite to creation
query_util='/apps/ctn-dicom/scripts/dicom_query';
lvls=get(get(findobj(0, 'tag',[mfilename 'level']),'children'));
lvl = logical(cat(1,lvls.Value));

[s result]=system(sprintf('%s %s --all',query_util,level{lvl}));

% get column numbers
ud.PATIDCOLS=0;
ud.PATCOLS=0;
ud.STUIDCOLS=0;
ud.STUCOLS=0;
ud.SERIDCOLS=0;
ud.SERCOLS=0;
ud.IMACOLS=0;

[tok result] = strtok(result,char(10));
while ~isempty(strfind(tok,'COLS='))
    try
        eval(['ud.' tok ';']);
        [tok result] = strtok(result,char(10));
    catch
        break;
    end
end

fmtstr=['|' repmat('%s',1,ud.PATIDCOLS+ud.PATCOLS+...
    ud.STUIDCOLS+ud.STUCOLS+ud.SERIDCOLS+ud.SERCOLS+ud.IMACOLS)];

[tok result]  = strtok(result,char(10));

ud.vals = textscan(result, fmtstr, 'delimiter','|', 'whitespace','');
ud.vals = deblank(cat(2,ud.vals{:}));

% trim vals to equal length per column
for k = (ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+1):size(ud.vals,2)
    tmp = strvcat(strcat(ud.vals(:,k),'.'));
    for l = 1:size(ud.vals,1)
        ud.vals{l,k} = strrep(tmp(l,:),' ','.');
    end;
end;
ud.sel = true(size(ud.vals,1),1);
set(findobj(0,'tag',[mfilename 'patbox']),'userdata',ud);


function fill_patbox(varargin)
set(findobj(0,'tag',[mfilename 'patbox']),...
    'string',{'Formatting results', 'Please wait...'});
drawnow;
stuindent='->';
serindent='--->';
imaindent='----->';

lvls=get(get(findobj(0, 'tag',[mfilename 'level']),'children'));
lvl =find(cat(1,lvls.Value));
hser = [findobj(0,'tag',[mfilename 'SeqNamefilt']) findobj(0,'tag',[mfilename 'ProNamefilt'])];
hstu = [findobj(0,'tag',[mfilename 'StuNamefilt']),...
    findobj(0,'tag',[mfilename 'StuDatefilt']),...
    findobj(0,'tag',[mfilename 'StuTimefilt'])];
switch lvl
    case 1
        set(hser,'enable','on');
        set(hstu,'enable','on');
    case 2
        set(hser,'enable','off');
        set(hstu,'enable','on');
    case 3
        set(hser,'enable','off');
        set(hstu,'enable','off');
end;
ud = get(findobj(0,'tag',[mfilename 'patbox']),'userdata');
set(findobj(0,'tag',[mfilename 'patbox']), 'value',[]);


cstr = 1;
patlast=0;
stulast=0;
serlast=0;
vals = ud.vals(ud.sel,:);
ud.str=cell(4*size(vals,1),1);
ud.uid=cell(4*size(vals,1),1);
ud.valind=zeros(4*size(vals,1),1);
for k=1:size(vals,1)
    if patlast == 0 || ~all(cellfun(@isequal,...
            vals(k,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+(1:ud.PATCOLS)),...
            vals(patlast,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+(1:ud.PATCOLS))))
        ud.str{cstr} = strrep(sprintf('%s ', vals{k,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
            (1:ud.PATCOLS)}),char(65533),'_');
        ud.uid(cstr) = {vals(k,1:ud.PATIDCOLS)};
        ud.valind(cstr) = k;
        patlast = k;
        cstr = cstr+1;
    end;
    if ud.STUCOLS
        if  stulast == 0 || ~all(cellfun(@isequal,...
                vals(k,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
                ud.PATCOLS+(1:ud.STUCOLS)),...
                vals(stulast,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
                ud.PATCOLS+(1:ud.STUCOLS))))
            cval = vals(k,:);
            timeval=str2double(regexprep(cval{ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
                ud.PATCOLS+3},'^(\.*)([0-9].*[0-9])(\.*)$','$2'));
            timestr=sprintf('%02d:%02d',floor(timeval/3600),floor(rem(timeval/60,60)));
            cval{ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+ud.PATCOLS+3}=timestr;
            ud.str{cstr} = strrep(sprintf('%s ', stuindent,...
                cval{ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
                ud.PATCOLS+(1:ud.STUCOLS)}),char(65533),'_');
            ud.uid(cstr) = {vals(k,1:(ud.PATIDCOLS+ud.STUIDCOLS))};
            ud.valind(cstr) = k;
            stulast = k;
            cstr = cstr+1;
        end;
    end;
    if ud.SERCOLS
        if serlast == 0 || ~all(cellfun(@isequal,...
                vals(k,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
                ud.PATCOLS+ud.STUCOLS+(1:ud.SERCOLS)),...
                vals(serlast,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
                ud.PATCOLS+ud.STUCOLS+(1:ud.SERCOLS))))
            ud.str{cstr} = strrep(sprintf('%s ', serindent,...
                vals{k,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
                ud.PATCOLS+ud.STUCOLS+(1:ud.SERCOLS)}),char(65533),'_');
            ud.uid(cstr) = {vals(k,1:(ud.PATIDCOLS+ud.STUIDCOLS+ ...
                ud.SERIDCOLS))};
            ud.valind(cstr) = k;
            serlast = k;
            cstr = cstr+1;
        end;
    end;
    if ud.IMACOLS
        tmpstr=sprintf('%s ', imaindent, ...
            vals{k,ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS+...
            ud.PATCOLS+ud.STUCOLS+ud.SERCOLS+(1:ud.IMACOLS)});
        ud.str{cstr} = strrep(tmpstr,char(65533),'_');
        ud.uid(cstr) = {vals(k,1:(ud.PATIDCOLS+ud.STUIDCOLS+ud.SERIDCOLS))};
        ud.valind(cstr) = k;
        cstr = cstr+1;
    end;
end;
if cstr == 1
    ud.str = {'No hits in database.'};
    ud.uid = {};
    ud.valind = [];
else
    ud.str = ud.str(1:(cstr-1));
    ud.uid = ud.uid(1:(cstr-1));
    ud.valind = ud.valind(1:(cstr-1));
end
set(findobj(0,'tag',[mfilename 'patbox']), 'string',ud.str,'userdata',ud);

function addto_selbox(varargin)
ud  =get(findobj(0,'tag',[mfilename 'patbox']),'userdata');
sel2=get(findobj(0,'tag',[mfilename 'patbox']),'value');

uid1=get(findobj(0,'tag',[mfilename 'selbox']),'userdata');
str1=get(findobj(0,'tag',[mfilename 'selbox']),'string');
uid=[uid1(:); ud.uid(sel2)]';
str=[str1(:); ud.str(sel2)]';
set(findobj(0,'tag',[mfilename 'selbox']),'string',str, 'userdata',uid, 'value',[]);

function rmfrom_selbox(varargin)
sel=get(findobj(0,'tag',[mfilename 'selbox']),'value');
uid=get(findobj(0,'tag',[mfilename 'selbox']),'userdata');
str=get(findobj(0,'tag',[mfilename 'selbox']),'string');
set(findobj(0,'tag',[mfilename 'selbox']),'value',[]);
nsel=setdiff(1:numel(uid),sel);
if ~isempty(nsel)
    set(findobj(0,'tag',[mfilename 'selbox']),'userdata',uid(nsel), 'string',str(nsel));
else
    set(findobj(0,'tag',[mfilename 'selbox']),'userdata',{}, 'string',{});
end

function get_selected_files(varargin)
set(findobj(0,'tag',[mfilename 'button']),'Enable','off');
spm('pointer','watch');
uid=get(findobj(0,'tag',[mfilename 'selbox']),'userdata');
cmd = get(gcbo,'string');
if iscell(cmd)
    % popup menu
    cmd = cmd{get(gcbo, 'value')};
end;

patidstr='';
stuinsuidstr='';
serinsuidstr='';

for k=1:numel(uid)
    switch numel(uid{k})
        case 1,
            patidstr=sprintf('PatientLevel.PatID="%s" OR %s', ...
                deblank(uid{k}{1}), patidstr);
        case 2,
            stuinsuidstr=sprintf('StudyLevel.StuInsUID="%s" OR %s', ...
                deblank(uid{k}{2}), stuinsuidstr);
        case 3,
            serinsuidstr=sprintf('SeriesLevel.SerInsUID="%s" OR %s', ...
                deblank(uid{k}{3}), serinsuidstr);
    end;
end;

querystr = ['select distinct SerPath='...
    'substring(InstanceTable.Path, 1, char_length(InstanceTable.Path) -'...
    ' charindex( ''/'', reverse(InstanceTable.Path))) from InstanceTable, ImageLevel, SeriesLevel ' ...
    '%s where SeriesLevel.SerInsUID = ImageLevel.SerParent and '...
    'ImageLevel.SOPInsUID = InstanceTable.ImageUID and (%s)'];
isqlstr = ['export LANG=C\n'...
    'export LC_ALL=C\n'...
    'export SYBASE=/apps/sybase\n'...
    'cat <<EOF|/apps/sybase/OCS-12_5/bin/isql -U fbidicom -P fbidicom -S FBIDICOM -H fbidicom -w 10000 -D DicomImage\n'...
    'set nocount on\n%s\ngo\nEOF\n'];
dirs={};
if ~isempty(patidstr)
    patidstr=sprintf(['(%s) and StudyLevel.PatParent=PatientLevel.PatID and '...
        'SeriesLevel.StuParent=StudyLevel.StuInsUID'],patidstr(1:end-3));
    patidtables=', StudyLevel, PatientLevel';
    querypatid=sprintf(querystr, patidtables, patidstr);
    [s w]=system(sprintf(isqlstr,querypatid));
    tmp=textscan(w,'%s','delimiter',char(10));
    dirs=[dirs(:); tmp{1}(3:end)]';
end;

if ~isempty(stuinsuidstr)
    stuinsuidstr=sprintf(['(%s) and '...
        'SeriesLevel.StuParent=' ...
        'StudyLevel.StuInsUID'],stuinsuidstr(1:end-3));
    stuinsuidtables=', StudyLevel';
    querystuinsuid=sprintf(querystr, stuinsuidtables, stuinsuidstr);
    [s w]=system(sprintf(isqlstr,querystuinsuid));
    tmp=textscan(w,'%s','delimiter',char(10));
    dirs=[dirs(:); tmp{1}(3:end)]';
end;

if ~isempty(serinsuidstr)
    queryserinsuid=sprintf(querystr,'',serinsuidstr(1:end-3));
    [s w]=system(sprintf(isqlstr,queryserinsuid));
    tmp=textscan(w,'%s','delimiter',char(10));
    dirs=[dirs(:); tmp{1}(3:end)]';
end;

dirs=deblank(dirs);
close(findobj(0,'tag',mfilename));
spm('pointer','arrow');
switch lower(cmd)
    case {'spm dicom import (fast)','spm dicom import (expert)'}
        switch lower(spm('ver'))
            case {'spm5','spm8','spm8b'}
                jtmp.fbi_dicom=struct('data',struct('dirs',{dirs}), ...
                    'outdir','<UNDEFINED>');
                jobs{1}.tools={jtmp};
                fg = spm_figure('findwin','Graphics');
                if ~isempty(fg) && ishandle(fg)
                    figure(fg);
                end
                if strcmpi(cmd,'spm dicom import (fast)') == 1 && any(strcmpi(spm('ver'),{'spm8','spm8b'}))
                    spm_jobman('serial',jobs);
                else
                    spm_jobman('interactive',jobs);
                end;
            case 'spm2'
                addpath(fullfile(spm('dir'),'toolbox','DICOM'));
                fg = spm_figure('findwin','Interactive');
                if ~isempty(fg) && ishandle(fg)
                    figure(fg);
                end
                spm_DICOM(dirs);
        end;
    case {'dti dicom import (fast)','dti dicom import (expert)'}
        switch lower(spm('ver'))
            case {'spm8','spm8b'}
                jobs = cell(1,numel(dirs)+3);
                jobs{1}.cfg_basicio.cfg_named_dir.name = 'Output Directory';
                jobs{1}.cfg_basicio.cfg_named_dir.dirs = {'<UNDEFINED>'};
                jobs{2}.cfg_basicio.cfg_named_input.name = 'Save Hardi (1 = yes, 0 = no)';
                jobs{2}.cfg_basicio.cfg_named_input.input = '<UNDEFINED>';
                outdir(1) = cfg_dep;
                outdir(1).sname = 'Named Directory Selector: Output Directory(1)';
                outdir(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1});
                outdir(1).src_output = substruct('.','dirs', '{}',{1});
                shardi(1) = cfg_dep;
                shardi(1).sname = 'Named Input: Save Hardi (1 = yes, 0 = no)';
                shardi(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1});
                shardi(1).src_output = substruct('.','input');
                for k = 1:numel(dirs)
                    jobs{2*k-1+2}.spm.tools.fbi_dicom_dti=struct('dirs',{dirs(k)}, ...
                        'outdir',outdir);
                    rawdep(k) = cfg_dep;
                    rawdep(k).src_exbranch = substruct('.','val', '{}',{2*k-1+2}, '.','val', '{}',{1}, '.','val', '{}',{1});
                    rawdep(k).src_output = substruct('.','files');
                    jobs{2*k+2}.dtijobs.tensor.filename = rawdep(k);
                    jobs{2*k+2}.dtijobs.tensor.hardi = shardi;
                end
                jobs{end+1}.cfg_basicio.file_move.files = rawdep;
                jobs{end}.cfg_basicio.file_move.action.delete = false;
                if strcmpi(cmd,'dti dicom import (fast)') == 1
                    spm_jobman('serial',jobs);
                else
                    spm_jobman('interactive',jobs);
                end;
            otherwise
                error('Unsupported SPM version');
        end
    case 'dicom copy tool'
        % need to run one dicom_copy_tool per subject
        subj = cell(size(dirs));
        stud = cell(size(dirs));
        for k=1:numel(dirs)
            [subj{k} n e] = fileparts(dirs{k});
            stud{k} = [n e];
        end;
        [usubj unused ind] = unique(subj);
        if numel(usubj)>1
            sts=questdlg(sprintf(['You have selected %d subjects. DICOM Copy Tool ' ...
                'has to be called for each subject separately. ' ...
                'Do you want to proceed?'],numel(usubj)), ...
                'Multiple subjects selected', 'Copy', 'Cancel', 'Copy');
            if strcmp(sts,'Cancel')
                assignin('base','dcmdirs',dirs);
                fprintf('\nNames of data directories saved into workspace variable ''dcmdirs''.\n');
                fprintf('DICOM Copy Tool will not be started.\n');
                return;
            end
        end;
        for k=1:numel(usubj)
            dicom_copy_tool;
            dicom_copy_model('set', 'makeDir', 1);
            dicom_copy_model('set', 'efilmDir', usubj{k});
            cstud = stud(ind==k);
            for l=1:numel(cstud)
                dicom_copy_model('set', 'setSourceDir', cstud{l})
            end;
            dicom_copy_model('set','ATsorting',1);
            waitfor(findobj('tag','dicom_copy_figure'));
        end;
    case 'export dirnames'
        assignin('base','dcmdirs',dirs);
        fprintf('\nNames of data directories saved into workspace variable ''dcmdirs''.\n');
end;

function cancel(varargin)
close(findobj(0,'tag',mfilename));
