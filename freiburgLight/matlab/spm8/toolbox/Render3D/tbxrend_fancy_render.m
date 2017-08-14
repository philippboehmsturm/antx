function varargout = tbxrend_fancy_render(varargin)
% Fancy rendering of intensities of one brain superimposed on surface
% FORMAT fr = tbxrend_fancy_render(cmd, ...)
% ======
% Commands are
% 'init'     - Initialise rendering
% 'load'     - Load rendering from fr*.mat file
% 'save'     - Save information about used data, slices and cuts into
%              fr_<name of structural image>.mat
% 'addblobs' - Select new SPM/image set for colouring
% 'addsurf'  - Add another surface patch given as
%              - gifti file
%              - filename for a .mat file with a struct FV
%              - Matlab struct with faces and vertices from the workspace
%              - image file to be spm_surf'ed. The image will be resliced
%                to space and resolution of the brain mask (if present). The
%                surface will be created on a slightly smoothed image at
%                threshold 0.5
%              - thresholded SPM, saved and resliced to the space of the
%                brain mask (if present)
% 'addline'  - Add lines as streamtubes given as
%              - filename for a .mat file with variables "vertices" (cell
%                array of lines in xyz mm coordinates) and optionally "width"
%              - Matlab struct with vertices and width fields from the workspace
%              - widths can alternatively be sampled from a file (e.g. FA)
%              See MATLABs streamtube command for details
% 'redraw'   - Redraw the figure
% 'render'   - Re-render the surface patch
% 'slice'    - Add a "slice" through the structural image
%              the slice must be given as a function sfunc(x, y, z)
%              the resulting slice is at sfunc(x, y, z) = 0
%              examples:
%              'x-20' produces a slice at x = 20 (x-20 = 0)
%              'x.^2 + y.^2 - r.^2' produces a slice on a cylinder with
%              radius r along the z axis
%              a slice sub-volume can be specified as a range of x,
%              y, z where the slice function should be evaluated
%              (in most cases, this will be the inverse of the
%              corresponding cut expression)
%              enter '1' or 'none' if no sub-volume needed
% 'cut'      - Cut a piece of surface and slices
%              the cut expression must specify the range of x, y, z
%              which should be cut away
% 'axison'   - Turn axis labels on (useful to determine cut coordinates)
% 'axisoff'  - Turn axis labels off
% 'relight'  - Reset lighting after rotation of the figure
%
% This function is part of the volumes toolbox for SPM2. For general help
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxrend_fancy_render.m 721 2011-09-27 11:30:49Z glauche $
% core code taken from fancy_rendering by John Ashburner

rev='$Revision: 721 $'; %#ok<NASGU>
funcname = 'Fancy render';

if nargin == 0,
    fr = tbxrend_fancy_render('init');
    if nargout > 0
        varargout{1} = fr;
    end;
    return;
end;

% defaults
mydefaults = struct('camcolour',[1 1 1], 'slicecolour',[.7 .7 .7], ...
    'indper',.6, 'colfunc','colrgb', 'slicescuts',{{}}, ...
    'VM',[], 'VV',[], 'blobs',{{}}, 'surf',{{}}, 'line',{{}},...
    'slicepatch',[], 'x',[], 'y',[], 'z',[]);
mydefaultssurf = struct('data',[], 'quality',.3, 'colour',[.8 .8 .9], 'tcol',1, 'cut',1, ...
    'patch',[], 'alpha',1, 'cutalpha',0.3, 'specularstrength',.2);
mydefaultsline = struct('vertices',[], 'width',1, 'colour',[.8 .8 .9], 'alpha',1,...
    'N',20, 'specularstrength',.2);
% menu setup
if nargin==2
    if ischar(varargin{1}) && ishandle(varargin{2})
        if strcmpi(varargin{1},'menu')
            VMfancy = uimenu(varargin{2},'Label',funcname, 'Tag', 'VMFANCY');

            VMfancyinit = uimenu(VMfancy,'Label','Init',...
                'Callback',[mfilename '(''menuinit'');' ],...
                'Tag','VMFANCY0');
            VMfancyload = uimenu(VMfancy,'Label','Load',...
                'Callback',[mfilename '(''menuload'');' ],...
                'Tag','VMFANCY0');
            VMfancycut = uimenu(VMfancy, 'Label', 'Cut',...
                'Callback',[mfilename '(''addcut'');' ],...
                'Tag','VMFANCY1','Visible','off');
            VMfancyslice = uimenu(VMfancy, 'Label', 'Slice',...
                'Callback',[mfilename '(''addslice'');' ],...
                'Tag','VMFANCY1','Visible','off');
            VMfancyaddsurf = uimenu(VMfancy, 'Label', 'Add surface',...
                'Callback',[mfilename '(''addsurf'');' ],...
                'Tag','VMFANCY1','Visible','off');
            VMfancyrelight = uimenu(VMfancy, 'Label', 'Relight',...
                'Callback',[mfilename '(''relight'');' ],...
                'Tag','VMFANCY1','Visible','off');
            VMfancyblobs = uimenu(VMfancy, 'Label', 'New blobs',...
                'Callback',[mfilename '(''addblobs'');' ],...
                'Tag','VMFANCY1','Visible','off');
            VMfancyax = uimenu(VMfancy, 'Label', 'Axis',...
                'Tag','VMFANCY1','Visible','off');
            VMfancyaxison = uimenu(VMfancyax, 'Label', 'On',...
                'Callback',[mfilename '(''menuaxison'');' ],...
                'Tag','VMFANCY1_AXISON');
            VMfancyaxisoff = uimenu(VMfancyax, 'Label', 'Off', 'Checked','on',...
                'Callback',[mfilename '(''menuaxisoff'');' ],...
                'Tag','VMFANCY1_AXISOFF');
            VMfancysave = uimenu(VMfancy, 'Label', 'Save',...
                'Callback',[mfilename '(''save'');' ],...
                'Tag','VMFANCY1','Visible','off');
            VMfancyexp = uimenu(VMfancy, 'Label', 'Export to Workspace',...
                'Callback',[mfilename '(''export'');' ],...
                'Tag','VMFANCY1','Visible','off');
            VMfancyimp = uimenu(VMfancy, 'Label', 'Import from Workspace',...
                'Callback',[mfilename '(''import'');' ],...
                'Tag','VMFANCY1','Visible','off');
            VMfancyclear = uimenu(VMfancy, 'Label', 'Clear',...
                'Callback',[mfilename '(''menuclear'');' ],...
                'Tag','VMFANCY1','Visible','off');
            if nargout > 0
                varargout{1} = VMfancy;
            end;
            return;
        end;
        if strcmpi(varargin{1},'hmenu')
            Menu = uimenu(varargin{2},'Label',['Help on ' funcname],...
                'Callback',['spm_help(''' mfilename ''')']);
            if nargout > 0
                varargout{1} = Menu;
            end;
            return;
        end;
    end;
end;

switch lower(varargin{1})
    %=======================================================================
    % menu functions
    %=======================================================================

    case 'defaults'
        varargout{1} = mydefaults;
        varargout{2} = mydefaultssurf;
        return;

    case {'menuinit', 'menuload'}
        spm_input('!DeleteInputObj');
        fr = feval(mfilename,varargin{1}(5:end), varargin{2:end});
        set(findobj(get(gcbo,'Parent'),'Tag','VMFANCY0'),'Visible','off');
        set(findobj(get(gcbo,'Parent'),'Tag','VMFANCY1'),'Visible','on');
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

    case 'menuclear',
        shh = get(0,'ShowHiddenHandles');
        set(0,'ShowHiddenHandles','on');
        set(findobj(0, 'Tag','VMFANCY0'), 'Visible','on');
        set(findobj(0, 'Tag','VMFANCY1'), 'Visible','off');
        set(0,'ShowHiddenHandles',shh);
        if nargin == 1
            FGraph=get(findobj(0,'Tag',mfilename),'Parent');
        else
            FGraph=varargin{2};
        end;
        delete(FGraph);
        return;

    case 'menuaxison'
        spm('pointer','watch');
        set(findobj(get(gcbo,'Parent'),'Tag','VMFANCY1_AXISON'),'Checked','on');
        set(findobj(get(gcbo,'Parent'),'Tag','VMFANCY1_AXISOFF'),'Checked','off');
        feval(mfilename,varargin{1}(5:end), varargin{2:end});
        spm('pointer','arrow');
        return;

    case 'menuaxisoff'
        spm('pointer','watch');
        set(findobj(get(gcbo,'Parent'),'Tag','VMFANCY1_AXISON'),'Checked','off');
        set(findobj(get(gcbo,'Parent'),'Tag','VMFANCY1_AXISOFF'),'Checked','on');
        feval(mfilename,varargin{1}(5:end), varargin{2:end});
        spm('pointer','arrow');
        return;

        %=======================================================================
        % data specification functions
        %=======================================================================

        % tbxrend_fancy_render('init')
        %=======================================================================

    case ('init')
        if nargin > 1
            fr = fillstruct(mydefaults, varargin{2});
            if ~isempty(fr.surf)
                fr.surf{1} = fillstruct(mydefaultssurf, fr.surf{1});
            end;
        else
            fr = mydefaults;
        end;
        if isempty(fr.surf)
            fr = tbxrend_fancy_render('addsurf',fr);
        end;
        if isempty(fr.VV)
            fr.VV = spm_vol(spm_select(1, 'image', 'Volume Data'));
        end;
        if isempty(fr.VM)
            tmp = spm_vol(spm_select([0 1], 'image', 'Volume Mask (opt.)'));
            if ~isempty(tmp)
                fr.VM = tmp;
                tmp = spm_input('mask threshold [min max]','+1','e','0 1',2);
                fr.VM.min = tmp(1);
                fr.VM.max = tmp(2);
            end;
        end;
        if isempty(fr.blobs)
            fr=tbxrend_fancy_render('addblobs',fr);
        end;
        % create meshgrid on x y z coordinates at voxel edges
        st  = fr.VV.mat*[1 1 1 1]';
        en  = fr.VV.mat*[fr.VV.dim(1:3) 1]';
        tmp = spm_imatrix(fr.VV.mat);
        step= (en-st)./abs(spm_matrix([0 0 0 tmp(4:6)])*[(fr.VV.dim(1:3)-1) 1]');
        FV = get_faces_vertices(fr.surf{1});
        x   = st(1):step(1):en(1);
        x   = x((x>=min(FV.vertices(:,1)-step(1))) &...
            (x<=max(FV.vertices(:,1)+step(1))));
        y   = st(2):step(2):en(2);
        y   = y((y>=min(FV.vertices(:,2)-step(2))) &...
            (y<=max(FV.vertices(:,2)+step(2))));
        z   = st(3):step(3):en(3);
        z   = z((z>=min(FV.vertices(:,3)-step(3))) &...
            (z<=max(FV.vertices(:,3)+step(3))));
        clear FV;
        [fr.x fr.y fr.z]=meshgrid(x,y,z);
        fr=tbxrend_fancy_render('redraw',fr);
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

        % tbxrend_fancy_render('load')
        %=======================================================================

    case('load')
        var = load(spm_select(1,'fr.*\.mat', 'Rendering Description'));
        fr = var.fr;
        % convert to new fr struct, if necessary
        if isfield(fr,'VR')
            fr.blobs={};
            for k=1:numel(fr.VR)
                fr.blobs{k} = fr.VR(k);
                fr.blobs{k}.min = -Inf;
                fr.blobs{k}.max = Inf;
            end;
        end;
        for k=1:numel(fr.blobs)
            if ~isfield(fr.blobs{k},'scaling')
                fr.blobs{k}.scaling = 'rel';
            end;
        end;
        if isfield(fr,'surfname')
            if ischar(fr.surfname)
                fr.surf{1} = mydefaultssurf;
                fr.surf{1}.data = fr.surfname;
            else
                for k=1:numel(fr.surfname)
                    fr.surf{k} = mydefaultssurf;
                    fr.surf{k}.data = fr.surfname{k};
                    if size(fr.surfcolour,1)<=k
                        fr.surf{k}.colour = fr.surfcolour(k,:);
                    end;
                    if length(fr.surftcol)<=k
                        fr.surf{k}.tcol = fr.surftcol(k);
                    end;
                    if length(fr.surfcut)<=k
                        fr.surf{k}.cut = fr.surfcut(k);
                    end;
                end;
            end;
        end;
        if isfield(fr,'reshold') && isfield(fr, 'blobs')
            for k = 1:numel(fr.blobs)
                fr.blobs{k}.interp = fr.reshold;
            end;
        end;
        if isfield(fr,'VM')
            if ~isfield(fr.VM, 'min')
                fr.VM.min = eps;
            end;
            if ~isfield(fr.VM, 'max')
                fr.VM.max = Inf;
            end;
        end;
        fr = fillstruct(mydefaults, fr);
        fr = tbxrend_fancy_render('redraw',fr);
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

        % tbxrend_fancy_render('save')
        %=======================================================================

    case('save')
        ax = findobj(0,'Tag',mfilename);
        fr = get(ax,'UserData');
        if ischar(fr.surf{1}.data)
            [p n e]=fileparts(fr.surf{1}.data);
            fn = fullfile(p,['fr_' n e]);
        else
            [p n] = uiputfile([], 'select filename');
            if n == 0
                return;
            end;
            fn = fullfile(p,n);
        end;
        save(fn,'fr');
        return;

        % tbxrend_fancy_render('export')
        %=======================================================================
        
    case('export')
        ax = findobj(0,'Tag',mfilename);
        fr = get(ax,'UserData');
        assignin('base','fr',fr);
        evalin('base','disp(fr)');
        
        % tbxrend_fancy_render('import')
        %=======================================================================
        
    case('import')
        fr = evalin('base','fr');
        ax = findobj(0,'Tag',mfilename);
        set(ax,'Userdata',fr);
        tbxrend_fancy_render('redraw');
        
        % tbxrend_fancy_render('addblobs')
        %=======================================================================

    case('addblobs') % Possible argument: fr-structure, update it and return it
        if nargin==2
            fr = varargin{2};
        else
            ax = findobj(0,'Tag',mfilename);
            axes(ax);
            fr = get(ax,'UserData');
        end;
        fr.blobs = {};
        nblobs = spm_input('# blob sets','+1','b',{'none','1','2','3'}, ...
            0:3);
        if nblobs==1 % only 1 results image
            fr.colfunc = spm_input('Colour mode', '+1', 'm', 'RGB|Indexed', ...
                ['colrgb';'colind']);
        else
            fr.colfunc = 'colrgb';
        end;
        for k = 1:nblobs
            if spm_input(sprintf('Add blob set #%d from', k), '+1', 'b', ...
                    {'SPM', 'image'},[1 2]) == 1
                opwd = pwd; % work around spm_getSPM's "cd" behaviour
                [SPM VOL] = spm_getSPM;
                rcp      = round(VOL.XYZ);
                dim      = max(rcp,[],2)';
                off      = rcp(1,:) + dim(1)*(rcp(2,:)-1 + dim(2)*(rcp(3,:)-1));
                vol      = zeros(dim)+NaN;
                vol(off) = VOL.Z;
                fr.blobs{k}.vol = reshape(vol,dim);
                fr.blobs{k}.mat = VOL.M;
                cd(opwd);
            else
                fr.blobs{k} = spm_vol(spm_select(1,'image',...
                    sprintf('Results Image #%d',k)));
            end;
            fr.blobs{k}.interp = spm_input('Interpolation of results', '+1', ...
                'm', 'Nearest Neighbour|Trilinear|Sinc',[0;1;-7],1);
            fr.blobs{k}.min = -Inf;
            fr.blobs{k}.max = Inf;
            fr.blobs{k}.scaling = 'rel';
        end;
        if nargin==1
            set(ax,'UserData',fr);
            fr = tbxrend_fancy_render('redraw');
        end;
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

        % tbxrend_fancy_render('addcut')
        %=======================================================================

    case 'addcut',
        if nargin==2
            fr = varargin{2};
        else
            ax = findobj(0,'Tag',mfilename);
            axes(ax);
            fr = get(ax,'UserData');
        end;
        ind = size(fr.slicescuts,2)+1;
        fr.slicescuts{ind}.type='cut';
        ok = 0;
        x = 0; y=0; z=0; %#ok<NASGU> used in cut expression
        while ~ok
            fr.slicescuts{ind}.val = spm_input('Cut expression','+1', ...
                's');
            eval(sprintf('ok=islogical(%s);',fr.slicescuts{ind}.val),...
                'ok=0;');
            if ~ok
                uiwait(msgbox(sprintf(['Invalid cut expression '...
                    '''%s'''], fr.slicescuts{ind}.val),...
                    funcname,'modal'));
            end;
        end;
        if nargin==1
            set(ax,'UserData',fr);
            fr = tbxrend_fancy_render('redraw');
        end;
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

        % tbxrend_fancy_render('addslice')
        %=======================================================================

    case 'addslice',
        if nargin==2
            fr = varargin{2};
        else
            ax = findobj(0,'Tag',mfilename);
            axes(ax);
            fr = get(ax,'UserData');
        end;
        ind = size(fr.slicescuts,2)+1;
        fr.slicescuts{ind}.type='slice';
        fr.slicescuts{ind}.val = spm_input('Slice expression', '+1', 's');
        fr.slicescuts{ind}.bounds = spm_input('Slice sub-volume', ...
            '+1', 's', 'none');
        if strcmpi(fr.slicescuts{ind}.bounds,'none')
            fr.slicescuts{ind}.bounds = '1';
        end;
        if nargin==1
            set(ax,'UserData',fr);
            fr = tbxrend_fancy_render('redraw');
        end;
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

        % tbxrend_fancy_render('addsurf')
        %=======================================================================

    case('addsurf') % Possible argument: fr-structure, update it and return it
        if nargin==2
            fr = varargin{2};
        else
            ax = findobj(0,'Tag',mfilename);
            axes(ax);
            fr = get(ax,'UserData');
        end;
        cs = numel(fr.surf)+1;
        fr.surf{cs} = mydefaultssurf;
        fr.surf{cs}.colour = uisetcolor(fr.surf{cs}.colour,'Surface colour');
        fr.surf{cs}.tcol = spm_input('Overlay results onto this surface',...
            '+1', 'b', {'Yes', 'No'},[1 0]);
        fr.surf{cs}.cut = spm_input('Cut this surface',...
            '+1', 'b', {'Yes', 'No'},[1 0]);
        src= spm_input('Add surface from?', '+1', 'm',...
            {'GIFTI mesh', 'surf*.mat', 'matlab variable', 'image file',...
            'SPM result'}, {'gifti', 'mat','var','img','SPM'});
        switch char(src),
            case 'gifti',
                fr.surf{cs}.data=spm_select(1, 'mesh', ...
                    'Select surface data');
            case 'mat',
                fr.surf{cs}.data=spm_select(1, 'surf_.*\.mat', ...
                    'Select surface data');
            case 'var',
                ok = 0;
                while ~ok
                    tmp = spm_input('Variable name', '+1', 'e');
                    if isstruct(tmp)
                        if isfield(tmp, 'faces') && isfield(tmp, 'vertices')
                            fr.surf{cs}.data = tmp;
                            ok = 1;
                        end;
                    end;
                    if ~ok
                        msgbox(funcname,...
                            ['Please give a name for a struct containing ' ...
                            'the fields ''faces'' and ''vertices''.\n'...
                            'See ''help patch'' for details.']);
                    end;
                end;
            case {'img','SPM'}
                if strcmp(src,'img')
                    V = spm_vol(spm_select([1 1], 'image',...
                        'Image to create surface from'));
                    slevels = spm_input('Add surfaces at image intensity levels','+1',...
                        'e', .5);
                else
                    [SPM xSPM] = spm_getSPM;
                    slevels = spm_input('Add surfaces at Stats levels','+1','e', ...
                        num2str([min(xSPM.Z) max(xSPM.Z)]));
                    V = xSPM.Vspm;
                end;
                if ~isempty(fr.VM)
                    msk = spm_input('Apply brain mask for surface creation?',...
                        '+1', 'b', {'Yes', 'No'},[1 0]);
                else
                    msk = 0;
                end;
                if msk
                    for k=1:numel(V)
                        Vmtmp = fr.VM;
                        [p n e v] = spm_fileparts(V(k).fname);
                        Vmtmp.fname = fullfile(p, ['fr_' n e v]);
                        Vm(k) = spm_imcalc([orderfields(rmfield(fr.VM,{'min','max'}),...
                            V(k)), V(k)],Vmtmp, ...
                            sprintf('i2.*((i1>=%f)&(i1<=%f))',...
                            fr.VM.min,fr.VM.max));
                    end;
                else
                    Vm = V;
                end;
                if numel(slevels) > 1
                    slevels = sort(slevels);
                    col2 = uisetcolor(fr.surf{cs}.colour,...
                        'Surface colour for maximum intensity');
                else
                    col2 = fr.surf{cs}.colour;
                end;
                out = spm_surf(struct('data',{{Vm.fname}},'mode',2,'thresh',slevels));
                if numel(slevels) == 1
                    fr.surf{cs}.data = out.surffile{1};
                else
                    for k=1:numel(slevels)
                        clevel = (slevels(k)-min(slevels))/(max(slevels)-min(slevels));
                        fr.surf{cs+k-1} = fr.surf{cs};
                        fr.surf{cs+k-1}.alpha = .3+.7*clevel;
                        fr.surf{cs+k-1}.data = out.surffile{k};
                        fr.surf{cs+k-1}.colour = fr.surf{cs}.colour + ...
                            clevel*(col2 - fr.surf{cs}.colour);
                    end;
                end;
        end;
        if nargin==1
            set(ax,'UserData',fr);
            fr = tbxrend_fancy_render('redraw');
        end;
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

        % tbxrend_fancy_render('addline')
        %=======================================================================

    case('addline') % Possible argument: fr-structure, update it and return it
        if nargin==2
            fr = varargin{2};
        else
            ax = findobj(0,'Tag',mfilename);
            axes(ax);
            fr = get(ax,'UserData');
        end;
        cl = numel(fr.line)+1;
        fr.line{cl} = mydefaultsline;
        src= spm_input('Add lines from?', '+1', 'm',...
            {'line*.mat', 'matlab variable'}, {'mat','var'});
        ok = 0;
        while ~ok
            switch char(src),
                case 'mat',
                    tmp = load(spm_select(1, 'line_.*\.mat', ...
                        'Select line data'));
                case 'var',
                    tmp = spm_input('Variable name', '+1', 'e');
            end;
            if isstruct(tmp)
                if isfield(tmp, 'vertices') && iscell(tmp.vertices)
                    fr.line{cl}.vertices = tmp.vertices;
                    ok = 1;
                end
            elseif iscell(tmp)
                fr.line{cl}.vertices = tmp;
                ok = 1;
            end;
            if ~ok
                msgbox(funcname,...
                    ['Please give a name for a cell or a file containing ' ...
                    'the variable ''vertices''.']);
            end;
        end;
        src= spm_input('Line Colour Specification', '+1', 'm',...
            {'Select colour', 'matlab variable', 'images'}, {'ui','var','img'});
        switch char(src),
            case 'img',
                tmp = spm_vol(spm_select(3, 'image', ...
                    'Select line colour images (R,G,B)'));
                for k = 1:numel(fr.line{cl}.vertices)
                    col = zeros(size(fr.line{cl}.vertices{k},1),3);
                    for c = 1:3
                        xyz = inv(tmp(c).mat)*...
                            [fr.line{cl}.vertices{k} ...
                            ones(size(fr.line{cl}.vertices{k},1),1)]';
                        col(:,c) = spm_sample_vol(tmp(c),xyz(1,:), xyz(2,:), ...
                            xyz(3,:),0);
                    end;
                    fr.line{cl}.colour{k} = col;
                end;
            case 'var',
                fr.line{cl}.colour = spm_input('Colour', '+1', 'e');
            case 'ui'
                fr.line{cl}.colour = uisetcolor('Line Colour');

        end;
        src= spm_input('Line Width Specification', '+1', 'm',...
            {'matlab variable', 'images'}, {'var','img'});
        switch char(src),
            case 'img',
                tmp = spm_vol(spm_select(1, 'image', ...
                    'Select line width images'));
                for k = 1:numel(fr.line{cl}.vertices)
                    xyz = inv(tmp.mat)*...
                        [fr.line{cl}.vertices{k} ...
                        ones(size(fr.line{cl}.vertices{k},1),1)]';
                    fr.line{cl}.width{k} = ...
                        spm_sample_vol(tmp(c),xyz(1,:), xyz(2,:), ...
                        xyz(3,:),0);

                end;
            case 'var',
                fr.line{cl}.width = spm_input('Line Width', '+1', 'e');
        end;
        src= spm_input('Line Alpha Specification', '+1', 'm',...
            {'matlab variable', 'images'}, {'var','img'});
        switch char(src),
            case 'img',
                tmp = spm_vol(spm_select(1, 'image', ...
                    'Select line alpha images'));
                for k = 1:numel(fr.line{cl}.vertices)
                    xyz = inv(tmp.mat)*...
                        [fr.line{cl}.vertices{k} ...
                        ones(size(fr.line{cl}.vertices{k},1),1)]';
                    fr.line{cl}.alpha{k} = ...
                        spm_sample_vol(tmp(c),xyz(1,:), xyz(2,:), ...
                        xyz(3,:),0);

                end;
            case 'var',
                fr.line{cl}.alpha = spm_input('Line Alpha', '+1', 'e');
        end;

        if nargin==1
            set(ax,'UserData',fr);
            fr = tbxrend_fancy_render('redraw');
        end;
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

        %=======================================================================
        % drawing callbacks
        %=======================================================================

        % tbxrend_fancy_render('axison')
        %=======================================================================

    case('axison')
        ax = findobj(0,'Tag',mfilename);
        axes(ax);
        axis image on;
        xlabel('X'); ylabel('Y'); zlabel('Z');
        return;

        % tbxrend_fancy_render('axisoff')
        %=======================================================================

    case('axisoff')
        ax = findobj(0,'Tag',mfilename);
        axes(ax);
        axis image off;
        return;

        % tbxrend_fancy_render('cut')
        %=======================================================================

    case ('cut')
        if nargin == 2
            ax = findobj(0,'Tag',mfilename);
            axes(ax);
            fr = get(ax,'UserData');
            ind=varargin{2};
        else
            fr = varargin{2};
            ind = varargin{3};
        end;
        % cut surfaces
        for cs = 1:numel(fr.surf)
            if fr.surf{cs}.cut,
                v = get(fr.surf{cs}.patch,'Vertices');
                x=v(:,1); %#ok<NASGU> used in cut expression
                y=v(:,2); %#ok<NASGU>
                z=v(:,3); %#ok<NASGU>
                fva = get(fr.surf{cs}.patch,'FaceVertexAlphaData');
                if isempty(fva)
                    fva = fr.surf{cs}.alpha*ones(size(v,1),1);
                end;
                fva(eval(fr.slicescuts{ind}.val)) = fr.surf{cs}.cutalpha;
                set(fr.surf{cs}.patch,'FaceVertexAlphaData',fva);
            end;
        end;
        % cut slices
        for cs = 1:numel(fr.slicepatch)
            v = get(fr.slicepatch(cs),'Vertices');
            x=v(:,1); %#ok<NASGU> used in cut expression
            y=v(:,2); %#ok<NASGU>
            z=v(:,3); %#ok<NASGU>
            col = get(fr.slicepatch(cs),'FaceVertexCData');
            col(eval(fr.slicescuts{ind}.val)) = NaN;
            if any(~isnan(col(:)))
                set(fr.slicepatch(cs),'FaceVertexCData',col);
            else
                if ishandle(fr.slicepatch(cs))
                    delete(fr.slicepatch(cs));
                end;
            end;
        end;
        if nargin == 2
            set(ax,'UserData',fr);
        end;
        if nargout > 0
            varargout{1} = fr;
        end;
        return;

        % tbxrend_fancy_render('render')
        %=======================================================================

    case('render')
        ax = findobj(0,'Tag',mfilename);
        axes(ax);
        fr = get(ax,'UserData');
        for cs = 1:numel(fr.surf)
            FV = get_faces_vertices(fr.surf{cs});
            col = ones(size(FV.vertices,1),3).*...
                repmat(fr.surf{cs}.colour, [size(FV.vertices,1) 1]);
            if fr.surf{cs}.tcol
                tcol = feval(fr.colfunc,FV,fr);
                col = repmat(1-max(tcol,[],2),[1 3]).*col + tcol;
            end;
            fr.surf{cs}.patch = patch(FV, 'Parent',ax,...
                'AlphaDataMapping', 'none',...
                'FaceVertexAlphaData',...
                fr.surf{cs}.alpha*ones(size(FV.vertices,1),1),...
                'FaceAlpha', 'interp',...
                'FaceColor', 'interp',...
                'FaceVertexCData', col,...
                'EdgeColor', 'none',...
                'FaceLighting', 'phong',...
                'SpecularStrength' , fr.surf{cs}.specularstrength,...
                'AmbientStrength', 0.1,...
                'DiffuseStrength', 0.7,...
                'SpecularExponent', 10,...
                'Tag',sprintf('%s_surf',mfilename));
        end;
        set(ax,'UserData',fr);
        return;

        %=======================================================================
        % tbxrend_fancy_render('relight')
    case ('relight')
        ax = findobj(0,'Tag',mfilename);
        axes(ax);
        fr = get(ax,'UserData');
        l  = findobj(get(ax,'Children'), 'Type', 'light');
        if isempty(l)
            l = camlight(-20, 10);
        else
            l = camlight(l, -20, 10);
        end;
        set(l,'Color',fr.camcolour);
        return;

        %=======================================================================
        % tbxrend_fancy_render('redraw')
    case('redraw') % Possible argument: fr-structure, draw and set it as UserData
        if nargin==2
            fr = varargin{2};
            fg = figure;
            ax = axes('Parent',fg,'Clipping','off','tag',mfilename);
            set(0,'CurrentFigure',fg);
            set(fg,'CurrentAxes',ax,...
                'CloseRequestFcn',[mfilename '(''menuclear'',',num2str(fg),')']);
            set(ax,'UserData',fr);
            view(3);
            [az el] = view;
            daspect([1 1 1]);
            axis image off;
            box on;
            rotate3d on;
        else
            ax = findobj(0,'Tag',mfilename);
            axes(ax);
            [az el] = view;
            fr = get(ax,'UserData');
        end;
        delete(findobj(ax,'tag',sprintf('%s_surf',mfilename)));
        delete(findobj(ax,'tag',sprintf('%s_slice',mfilename)));
        for cs = 1:numel(fr.surf)
            fr.surf{cs}.patch=[];
        end;
        fr.slicepatch=[];
        set(ax,'Userdata',fr);
        tbxrend_fancy_render render;
        for k=1:size(fr.slicescuts,2)
            tbxrend_fancy_render(fr.slicescuts{k}.type,k);
        end;
        view(az,el);
        axis tight;
        tbxrend_fancy_render relight;
        if nargout >0
            varargout{1} = fr;
        end;
        return;

        %=======================================================================
        % tbxrend_fancy_render('slice')
    case ('slice')
        ax = findobj(0,'Tag',mfilename);
        axes(ax);
        fr = get(ax,'UserData');
        ind = varargin{2};
        if isempty(findstr(fr.slicescuts{ind}.val,'fr.'))
            tmp = strrep(fr.slicescuts{ind}.val,'x','fr.x');
            tmp = strrep(tmp,'y','fr.y');
            tmp = strrep(tmp,'z','fr.z');
        else % compatibility with old fr structs
            tmp = fr.slicescuts{ind}.val;
        end;
        sel = round(eval(tmp));
        if isfield(fr.slicescuts{ind},'bounds')
            tmp = strrep(fr.slicescuts{ind}.bounds,'x','fr.x');
            tmp = strrep(tmp,'y','fr.y');
            tmp = strrep(tmp,'z','fr.z');
            sel(~eval(tmp))=NaN;
        end;
        s = isosurface(fr.x,fr.y,fr.z,sel,0);
        clear sel;
        if isempty(s.vertices)
            warning([mfilename ':emptySlice'],...
                'Empty slice after evaluating isosurface\n ''%s''\n',...
                fr.slicescuts{ind}.val);
            return;
        end;
        M   = inv(fr.VV.mat);
        xyz    = (M(1:3,:)*[s.vertices' ; ones(1, size(s.vertices,1))])';
        col1 = spm_sample_vol(fr.VV,xyz(:,1), xyz(:,2), xyz(:,3), -4);
        if ~isempty(fr.VM)
            M = inv(fr.VM.mat);
            xyz = (M(1:3,:)*[s.vertices' ; ones(1, size(s.vertices, ...
                1))])';
            msk = spm_sample_vol(fr.VM, xyz(:,1), xyz(:,2), xyz(:,3), 0);
            col1((msk<fr.VM.min)|(msk>fr.VM.max)|isnan(msk))=0;
        else % we do not have an explicit mask, use non-interpolated volume data instead
            msk = spm_sample_vol(fr.VV,xyz(:,1), xyz(:,2), xyz(:,3), 0);
            col1(isnan(msk))=0;
        end;
        cmap=contrast(col1(col1~=0),1024);
        cmax=max(col1(isfinite(col1)));
        cmin=min(col1((col1~=0)&isfinite(col1)));
        if isempty(cmin)
            cmin = cmax-1;
        end;
        % use only first row of cmap (grayscale cmap!)
        col=repmat(interp1(cmin:(cmax-cmin)/1023:cmax,cmap(:,1),col1),[1 3]);
        col(col1==0)=NaN; % zero masking according to original data
        col = col.*repmat(fr.slicecolour,[size(col,1) 1]); % apply color shade
        tcol = feval(fr.colfunc,s,fr);
        col = repmat(1-max(tcol,[],2),[1 3]).*col + tcol;
        axes(ax);
        fr.slicepatch(end+1) = patch(s,...
            'FaceColor', 'interp', 'FaceVertexCData', col,...
            'EdgeColor', 'none',...
            'FaceLighting', 'phong',...
            'SpecularStrength' ,0.7, 'AmbientStrength', 0.1,...
            'DiffuseStrength', 0.7, 'SpecularExponent', 10,...
            'Tag',sprintf('%s_slice',mfilename));
        set(ax,'UserData',fr);
        return;
end

function tcol=colrgb(FV,fr)
tcol=zeros(size(FV.vertices,1),3);
for l=1:numel(fr.blobs)
    tcol(:,l) = samplecol(FV,fr.blobs{l});
end;

function tcol=colind(FV,fr)
tcol=zeros(size(FV.vertices,1),3);
if numel(fr.blobs) ~= 1
    error('Can only handle 1 results image in indexed mode');
end;
t = samplecol(FV,fr.blobs{1});
t      = ceil(t*1024);
cmap   = hsv(1024);
tcol(t~=0,:)   = cmap(t(t~=0),:)*fr.indper;

function t = samplecol(FV,V)
M    = inv(V.mat);
xyz  = (M(1:3,:)*[FV.vertices' ; ...
    ones(1, size(FV.vertices, 1))])';
if isfield(V,'vol')
    t = spm_sample_vol(V.vol, xyz(:,1), xyz(:,2), xyz(:,3), ...
        V.interp);
else
    t = spm_sample_vol(V, xyz(:,1), xyz(:,2), xyz(:,3), ...
        V.interp);
end;
imean = zeros(size(t));
if isfield(V,'VMean')
    M = inv(V.VMean.mat);
    xyz  = (M(1:3,:)*[FV.vertices' ; ...
        ones(1, size(FV.vertices, 1))])';
    if isfield(V.VMean,'vol')
        imean = spm_sample_vol(V.VMean.vol, ...
            xyz(:,1), xyz(:,2), xyz(:,3), ...
            V.interp);
    else
        imean = spm_sample_vol(V.VMean, ...
            xyz(:,1), xyz(:,2), xyz(:,3), ...
            V.interp);
    end;
end;
t = t-imean;
imsk = ones(size(t));
if isfield(V,'VM')
    M = inv(V.VM.mat);
    xyz  = (M(1:3,:)*[FV.vertices' ; ...
        ones(1, size(FV.vertices, 1))])';
    if isfield(V.VM,'vol')
        imsk = spm_sample_vol(V.VM.vol, ...
            xyz(:,1), xyz(:,2), xyz(:,3), ...
            V.interp);
    else
        imsk = spm_sample_vol(V.VM, ...
            xyz(:,1), xyz(:,2), xyz(:,3), ...
            V.interp);
    end;
end;
t(t<V.min) = V.min;
t(t>V.max) = V.max;
t(~isfinite(t) | ~imsk) = 0;

switch V.scaling
    case 'rel'
        mx = max([eps max(t)]);
    case 'abs'
        mx = V.max;
    case 'minmax'
        mx = V.max-V.min;
        t = t - V.min;
end;
t = t/mx;
% do the masking again
t(~isfinite(t) | ~imsk) = 0;

function FV = get_faces_vertices(source)
if isstruct(source.data)
    FV=source.data;
else
    [p n e] = fileparts(source.data);
    switch e
        case '.mat'
            FV = load(source.data);
        case '.gii'
            FV = gifti(source.data);
            FV = export(FV,'patch'); 
            % reducepatch does not work single precision vertices
            FV.vertices = double(FV.vertices);
    end
end;
FV = reducepatch(FV,source.quality);
