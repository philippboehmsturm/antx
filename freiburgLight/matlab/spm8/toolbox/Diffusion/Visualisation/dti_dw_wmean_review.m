function varargout = dti_dw_wmean_review(cmd,varargin)
% Compare image series to (weighted) means using a GUI

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            spm('pointer','watch');
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            % set up GUI & registry
            spm_figure('Clear','Graphics');
            fg    = spm_figure('FindWin','Graphics');
            ud.V  = spm_vol(char(job.osrcimgs));
            ud.mV = spm_vol(char(job.msrcimgs));
            ud.sV = spm_vol(char(job.ssrcimgs));
            ud.hReg = axes('Visible','off', 'Parent',fg); % dummy axes for registry
            xyz = spm_XYZreg('RoundCoords',[0;0;0],ud.V(1).mat,ud.V(1).dim'); % align initial coordinates
            spm_XYZreg('InitReg',ud.hReg,ud.V(1).mat,ud.V(1).dim',xyz);
            tmp = ud.V(1).mat\[xyz;1];
            ud.cp = [1 round(tmp(3))];
            ud.ax = axes('Parent',fg, 'Position',[0.03 0.51 0.87 0.48]);
            ud.im = imagesc(scaletocmap(rand(ud.V(1).dim(3),numel(job.osrcimgs))), 'Parent', ud.ax, 'HitTest','off');
            set(ud.ax,'ButtondownFcn',@summary_review, 'Tag',mfilename, ...
                'xgrid','on', 'xminorgrid','on', 'xminortick','on', ...
                'xcolor',[.7 .7 .7], 'gridlinestyle','-.')
            ud.cb = axes('Parent',fg, 'Position',[.92 .51 .03 .48]);
            setup_cm(ud.ax,fg,job.summaryopts);
            spm_XYZreg('Add2Reg',ud.hReg,ud.ax,@xyz_register);
            % get DTI information
            extbch.ltol = 1;
            extbch.dtol = 0;
            extbch.sep  = 0;
            extbch.srcimgs = job.osrcimgs;
            extbch.ref.refscanner = 1;
            extbch.saveinf = 0;
            ud.dti = dti_extract_dirs(extbch);
            % difference summary
            ud.sx  = zeros(ud.V(1).dim(3), numel(job.osrcimgs));
            ud.px  = zeros(ud.V(1).dim(3), numel(job.osrcimgs));
            ud.npx = zeros(ud.V(1).dim(3), numel(job.osrcimgs));
            ud.dx  = zeros(ud.V(1).dim(3), numel(job.osrcimgs));
            ud.ndx = zeros(ud.V(1).dim(3), numel(job.osrcimgs));
            % image intensity range
            ud.win = zeros(numel(job.osrcimgs), 2);
            spm_progress_bar('init',numel(job.osrcimgs),'Images processed');
            for k = 1:numel(job.osrcimgs)
                X = reshape(spm_read_vols([ud.V(k) ud.mV(k)]), [prod(ud.V(1).dim(1:2)), ud.V(1).dim(3) 2]);
                ud.sx(:,k)  = sum(diff(X,[],3).^2); % sum of squared differences
                tmppx       = abs(1-X(:,:,1)./X(:,:,2));
                tmppx(~isfinite(tmppx)) = 0;
                ud.px(:,k)  = sum(tmppx); % sum of relative differences
                ud.npx(:,k) = sum(tmppx>job.threshopts.pthresh);
                sdX         = sqrt(reshape(spm_read_vols(ud.sV(k)), [prod(ud.V(1).dim(1:2)), ud.V(1).dim(3)]));
                tmpdx       = abs(diff(X,[],3)./sdX);
                tmpdx(~isfinite(tmpdx)) = 0;
                ud.dx(:,k)  = sum(tmpdx);
                ud.ndx(:,k) = sum(tmpdx>job.threshopts.sdthresh);
                ud.win(k,:) = [min(X(:)) max(X(:))]; % image intensity window
                spm_progress_bar('set', k);
            end
            spm_progress_bar('clear');
            % precomputed min/max (per image)
            ud.msx  = [min(ud.sx); max(ud.sx)];
            ud.mpx  = [min(ud.px); max(ud.px)];
            ud.mnpx = [min(ud.npx); max(ud.npx)];
            ud.mdx  = [min(ud.dx); max(ud.dx)];
            ud.mndx = [min(ud.ndx); max(ud.ndx)];
            % save userdata
            set(ud.ax, 'Userdata',ud);
            % summary display
            summary_display(ud);
            % summary colorbar display
            summary_cb_display(ud);
            % image display
            image_display(ud);
            % highlight current slice
            highlight_cs(ud);
            if nargout > 0
                varargout{1} = out;
            end
            spm('pointer','arrow');
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = cfg_dep;
            dep = dep(false);
            % determine outputs, return cfg_dep array in variable dep
            varargout{1} = dep;
        case 'check'
            if ischar(varargin{1})
                subcmd = lower(varargin{1});
                subjob = varargin{2};
                str = '';
                switch subcmd
                    % implement checks, return status string in variable str
                    otherwise
                        cfg_message('unknown:check', ...
                            'Unknown check subcmd ''%s''.', subcmd);
                end
                varargout{1} = str;
            else
                cfg_message('ischar:check', 'Subcmd must be a string.');
            end
        case 'defaults'
            if nargin == 2
                varargout{1} = local_defs(varargin{1});
            else
                local_defs(varargin{1:2});
            end
        otherwise
            cfg_message('unknown:cmd', 'Unknown command ''%s''.', cmd);
    end
else
    cfg_message('ischar:cmd', 'Cmd must be a string.');
end

function varargout = local_defs(defstr, defval)
persistent defs;
if isempty(defs)
    % initialise defaults
    defs.summaryopts.summary  = 5;
    defs.summaryopts.mapping  = 2;
    defs.summaryopts.grouping = 2;
    defs.threshopts.pthresh   = .2;
    defs.threshopts.sdthresh  = 2;
end
if ischar(defstr)
    % construct subscript reference struct from dot delimited tag string
    tags = textscan(defstr,'%s', 'delimiter','.');
    subs = struct('type','.','subs',tags{1}');
    try
        cdefval = subsref(defs, subs);
    catch
        cdefval = [];
        cfg_message('defaults:noval', ...
            'No matching defaults value ''%s'' found.', defstr);
    end
    if nargin == 1
        varargout{1} = cdefval;
    else
        defs = subsasgn(defs, subs, defval);
    end
else
    cfg_message('ischar:defstr', 'Defaults key must be a string.');
end

function job = local_getjob(job)
if ~isstruct(job)
    cfg_message('isstruct:job', 'Job must be a struct.');
end

function [im,mx,mn,opts] = summary_display_info(ud,imsel)
opts.summary  = find(strcmp(get(findobj(0,'-regexp','tag','dti_dw_wmean_review_summary'),'checked'),'on'));
opts.mapping  = find(strcmp(get(findobj(0,'-regexp','tag','dti_dw_wmean_review_mapping'),'checked'),'on'));
opts.grouping = find(strcmp(get(findobj(0,'-regexp','tag','dti_dw_wmean_review_grouping'),'checked'),'on'));
switch opts.summary
    case 1 % nvox > percent difference thresh
        im = ud.npx(:,imsel);
        mm = ud.mnpx;
    case 2 % sum percent difference
        im = ud.px(:,imsel);
        mm = ud.mpx;
    case 3 % sum squared difference
        im = ud.sx(:,imsel);
        mm = ud.msx;
    case 4 % nvox > standard difference thresh
        im = ud.ndx(:,imsel);
        mm = ud.mndx;
    case 5 % sum standard difference
        im = ud.dx(:,imsel);
        mm = ud.mdx;
end
switch opts.mapping
    case 1 % log
        im = log(im);
        mm = log(mm);
    case 2 % linear
end
switch opts.grouping
    case 1 % per image
        mx = mm(2,imsel);
        mn = mm(1,imsel);
    case 2 % per b value
        mx = zeros(1,numel(imsel));
        mn = zeros(1,numel(imsel));
        for k = 1:numel(ud.dti.ub)
            sel = ud.dti.ubj==k;
            mx(sel(imsel)) = max(mm(2,sel));
            mn(sel(imsel)) = min(mm(1,sel));
        end
    case 3 % all images
        mx = max(mm(2,:))*ones(1,numel(imsel));
        mn = min(mm(1,:))*ones(1,numel(imsel));
end

function summary_display(ud)
[im,mx,mn] = summary_display_info(ud,1:size(ud.dx,2));
mx = repmat(mx, size(im,1),1);
mn = repmat(mn, size(im,1),1);
im = (im-mn)./(mx-mn);
set(ud.im,'cdata',scaletocmap(im));

function summary_cb_display(ud)
[im,mx,mn,opts] = summary_display_info(ud,ud.cp(1));
switch opts.mapping
    case 1 % log
        labels = exp([mn mx]);
    case 2 % linear
        labels = [mn mx];
end
sp = min(1,(mx-mn)/20);
imagesc(scaletocmap((mn:sp:mx)'),'parent',ud.cb);
yl = get(ud.cb,'ylim');
set(ud.cb,'xtick',[],'ydir','normal','ytick',yl,'ytickl',labels,'yaxisl','right')
highlight_cb(ud);

function image_display(ud)
spm_orthviews('Reset');
spm_orthviews('Image',ud.V(ud.cp(1)),[0.01 0.01 .48 .49]);
spm_orthviews('Image',ud.mV(ud.cp(1)),[.51 0.01 .48 .49]);
spm_orthviews('interp',0);
spm_orthviews('space',1);
spm_orthviews('window',1:2,ud.win(ud.cp(1),:));
spm_orthviews('register',ud.hReg);
spm_orthviews('addcontext');

function xyz_register(cmd, varargin)
% spm_XYZreg 'SetCoords' callback
spm('pointer','watch');
ax = varargin{2};
ud = get(ax, 'userdata');
tmp = round(ud.V(ud.cp(1)).mat\[varargin{1};1]);
if tmp(3) ~= ud.cp(2)
    ud.cp(2) = tmp(3);
    % update slice display
    highlight_cs(ud);
end
set(ax,'userdata',ud);
spm('pointer','arrow');

function summary_review(ob,ev)
% ButtonDownFcn for image axis
if strcmp(get(gcbf,'selectiontype'),'normal')
    spm('pointer','watch');
    ud = get(ob, 'userdata');
    ocp = ud.cp;
    ud.cp = round(get(ob, 'currentpoint'));
    ud.cp = ud.cp(1,1:2); % keep row/column
    if ocp(1) ~= ud.cp(1)
        image_display(ud);
        summary_cb_display(ud);
    end
    if any(ocp ~= ud.cp)
        % update slice display
        % reposition to same (x,y) voxel as in previous slice
        oposvx = ud.V(ud.cp(1)).mat\[spm_orthviews('pos');1];
        posmm  = ud.V(ud.cp(1)).mat*[oposvx(1:2); ud.cp(2);1];
        spm_XYZreg('SetCoords',posmm(1:3),ud.hReg,ud.ax);
        highlight_cs(ud);
    end
    set(ob,'userdata',ud);
    spm('pointer','arrow');
end

function summary_map_group(tag, varargin)
% Context menu callback
% Toggle 'checked' property of selected menu item, unset others
ud = get(findobj(spm_figure('GetWin','Graphics'),'tag',mfilename),'userdata');
set(findobj(spm_figure('GetWin','Graphics'),'tag',[mfilename '_' lower(tag)]),'checked','off');
set(gcbo,'checked','on');
summary_display(ud);
summary_cb_display(ud);

function image_blobs(tag, varargin)
% Context menu callback
% Add blobs to mean image display
global st
ud = get(findobj(spm_figure('FindWin','Graphics'),'tag',mfilename),'UserData');
[X1 xyz] = spm_read_vols(ud.V(ud.cp(1)));
X2       = spm_read_vols(ud.mV(ud.cp(1)));
spm_orthviews('rmblobs',2);
switch lower(tag)
    case 'diff'
        dVOL     = (X1-X2).^2;
        xyz      = st.vols{2}.mat\[xyz;ones(1,size(xyz,2))];
        spm_orthviews('addcolouredblobs',2,xyz(1:3,:),dVOL(:),st.vols{2}.mat,[1 0 0],'Squared difference');
        spm_orthviews('AddColourBar',2,1);
    case 'std'
        Xs       = sqrt(spm_read_vols(ud.sV(ud.cp(1))));
        dVOL     = abs(X1-X2)./Xs;
        dVOL(Xs==0)  = 0;
        dVOL(dVOL>4) = 4;
        sel      = dVOL(:)>1;
        if any(sel)
            xyz      = st.vols{2}.mat\[xyz(:,sel);ones(1,sum(sel))];
            dVOL     = dVOL(sel);
            spm_orthviews('addblobs',2,xyz(1:3,:),dVOL(:),st.vols{2}.mat,'Standard difference');
            st.vols{2}.blobs{1}.min = 1;
        end
end
spm_orthviews('redraw',2)

function setup_cm(ax,fg,opts)
cm = uicontextmenu('parent',fg);
cm1 = uimenu(cm, 'Label','Difference Summary');
tag = 'summary';
cm2(5) = uimenu(cm1, 'Label','Sum standard Differences', 'Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
cm2(4) = uimenu(cm1, 'Label','#vox > Standard Difference Threshold', 'Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
cm2(3) = uimenu(cm1, 'Label','Sum squared Differences', 'Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
cm2(2) = uimenu(cm1, 'Label','Sum percent Differences', 'Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
cm2(1) = uimenu(cm1, 'Label','#vox > Percent Difference Threshold', 'Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
set(cm2(opts.(tag)),'checked','on');
cm1 = uimenu(cm,'label','Intensity Mapping');
tag = 'mapping';
cm2(2) = uimenu(cm1,'label','Linear','Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
cm2(1) = uimenu(cm1,'label','Log','Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
set(cm2(opts.(tag)),'checked','on');
cm1 = uimenu(cm,'label','Image Grouping');
tag = 'grouping';
cm2(3) = uimenu(cm1,'label','All Data','Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
cm2(2) = uimenu(cm1,'label','Per b-Value','Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
cm2(1) = uimenu(cm1,'label','Per Image','Callback',@(ob,ev)summary_map_group(tag,ob,ev),'tag',[mfilename '_' tag]);
set(cm2(opts.(tag)),'checked','on');
cm1 = uimenu(cm,'label','Overlay');
uimenu(cm1,'label','Squared Difference','Callback',@(ob,ev)image_blobs('diff',ob,ev));
uimenu(cm1,'label','Standard Difference','Callback',@(ob,ev)image_blobs('std',ob,ev));
set(ax,'Uicontextmenu',cm)

function highlight_cs(ud)
% highlight current slice/volume location
hold(ud.ax,'on');
delete(findobj(ud.ax,'tag','highlight'));
line(ud.cp(1)+[-.5 -.5 +.5 +.5 -.5], ud.cp(2)+[-.5 +.5 +.5 -.5 -.5], 'parent',ud.ax, 'color','w', 'linewidth',3, 'tag','highlight','hittest','off');
hold(ud.ax,'off');
highlight_cb(ud);

function highlight_cb(ud)
% highlight current slice value in color bar
[im,mx,mn] = summary_display_info(ud,ud.cp(1));
im = im(ud.cp(2));
hold(ud.cb,'on');
delete(findobj(ud.cb,'tag','highlight'));
yl = get(ud.cb,'ylim');
im = (yl(2)-yl(1))*(im-mn)./(mx-mn)+yl(1);
line(get(ud.cb,'xlim'), [im im], 'parent',ud.cb, 'color','w', 'linewidth',3, 'tag','highlight','hittest','off');
hold(ud.cb,'off');

function rgb = scaletocmap(ind)
tmpf = figure('visible','off');
tmpax = axes('parent',tmpf);
cmap = colormap(tmpax,'jet');
delete(tmpf);
ind=round(63*(ind-min(ind(:)))./(max(ind(:))-min(ind(:)))+1);
ind(~isfinite(ind))=1;
rgb = zeros([size(ind) 3]);
for k = 1:3
    rgb(:,:,k) = reshape(cmap(ind, k), size(ind));
end