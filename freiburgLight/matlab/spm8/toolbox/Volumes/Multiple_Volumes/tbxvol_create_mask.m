function out=tbxvol_create_mask(cmd,bch,varargin)
% Create mask from multiple sources or apply it to images
% FORMAT tbxvol_create_mask(bch)
% ======
% This tool is a front end to spm_imcalc. It aims to implement a 
% one-stop-shop for mask creation from different sources and application 
% to multiple object images.
% There are four pre-defined mask creation options: AND, OR (inclusive), 
% NAND, and NOR. However, any other correct spm_imcalc expression can be 
% supplied by selecting the CUSTOM mask option. This might be useful 
% e.g. if your mask images are not binary and you would like to threshold 
% them at a certain level.
% If only one file is selected as a mask (i.e. a precomputed mask is 
% choosen), the routine assumes that this mask should be applied to other 
% images. In this case, if no images are selected to be masked, nothing 
% will be done.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_create_mask.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Create/apply masks';

switch lower(cmd)
    case 'run'
        % function preliminaries
        Finter=spm_figure('GetWin','Interactive');
        Finter=spm('FigName',funcname,Finter);
        SPMid = spm('FnBanner',mfilename,rev);
        % function code starts here
        
        if isfield(bch.maskspec, 'maskdef')
            if isfield(bch.maskspec.maskdef.mtype, 'maskcustom')
                maskexpr = bch.maskspec.maskdef.mtype.maskcustom;
            else
                switch lower(bch.maskspec.maskdef.mtype.maskpredef)
                    case 'and',
                        op  = '&';
                        nop = '';
                        pl  = '';
                        pr  = '';
                    case 'or',
                        op  = '|';
                        nop = '';
                        pl  = '';
                        pr  = '';
                    case 'nand',
                        op  = '&';
                        nop = '~';
                        pl  = '(';
                        pr  = ')';
                    case 'nor',
                        op  = '|';
                        nop = '~';
                        pl  = '(';
                        pr  = ')';
                end
                maskexpr = '(isfinite(i1)&(i1~=0))';
                for k = 2:numel(bch.maskspec.maskdef.srcimgs)
                    maskexpr = [maskexpr op sprintf('(isfinite(i%d)&(i%d~=0))',k,k)];
                end;
                maskexpr = [nop pl maskexpr pr];
            end
            Vm{1}=spm_imcalc_ui(char(bch.maskspec.maskdef.srcimgs), ...
                                fullfile(bch.maskspec.maskdef.outimg.swd{1},...
                                         bch.maskspec.maskdef.outimg.fname),maskexpr);
            out.mfiles = Vm;
        elseif isfield(bch.maskspec, 'spheres')
            Vref = spm_vol(bch.maskspec.spheres.refimg{1});
            Vref.dt(1) = spm_type('uint8');
            Vref.pinfo(1:2) = inf;
            [xg,yg,zg] = ndgrid(1:Vref.dim(1),1:Vref.dim(2),1:Vref.dim(3));
            xyzg = Vref.mat*[xg(:)';yg(:)';zg(:)';ones(1,numel(xg))];
            if numel(bch.maskspec.spheres.radii) == 1
                bch.maskspec.spheres.radii = bch.maskspec.spheres.radii*ones(1, ...
                                                                  size(bch.maskspec.spheres.centers,1));
            end
            [p n e v] = spm_fileparts(bch.maskspec.spheres.outimg.fname);
            Vmfname = sprintf('%s_%%0%dd%s', n, ...
                              floor(log10(size(bch.maskspec.spheres.centers,2)))+1, e);
            Vm = cell(size(bch.maskspec.spheres.centers,1),1);
            for k = 1:size(bch.maskspec.spheres.centers,1)
                X = zeros(Vref.dim(1:3));
                c = Vref.mat*[bch.maskspec.spheres.centers(k,:)';1];
                d = ((xyzg(1,:)-c(1)).^2 + ...
                     (xyzg(2,:)-c(2)).^2 + ...
                     (xyzg(3,:)-c(3)).^2) <= ...
                    bch.maskspec.spheres.radii(k).^2;
                X(d(:)) = 1;
                Vm{k} = fullfile(bch.maskspec.spheres.outimg.swd{1}, sprintf(Vmfname,k));
                Vref.fname = Vm{k};
                spm_write_vol(Vref, X);
            end
            out.mfiles = Vm;
        else
            Vm=bch.maskspec.srcimg;
        end
        out.masked = cell(numel(bch.srcspec),1);
        for l=1:numel(bch.srcspec)
            out.masked{l} = cell(numel(Vm)*numel(bch.srcspec(l).srcimgs),1);
            switch lower(bch.srcspec(l).scope)
                case 'i',
                    numscope=sprintf('>%d',bch.srcspec(l).maskthresh);
                case 'e',
                    numscope=sprintf('<%d',bch.srcspec(l).maskthresh);
            end;
            
            % Apply scope to correct image (1st if reslicing to mask space, 2nd if
            % object space)
            if strcmpi(bch.srcspec(l).space,'mask') % Reslice to space of mask
                maskstr=sprintf('(abs(i1)%s).*(i2)',numscope);
            else % Reslice to space of object
                maskstr=sprintf('(i1).*(abs(i2)%s)',numscope);
            end
            for k=1:numel(bch.srcspec(l).srcimgs)
                if ~isempty(bch.srcspec(l).srcimgs{k})
                    for m = 1:numel(Vm)
                        if strcmpi(bch.srcspec(l).space,'mask') % Reslice to space of mask
                            Vsi = spm_vol(char(Vm{m}, bch.srcspec(l).srcimgs{k}));
                        else % Reslice to space of object
                            Vsi = spm_vol(char(bch.srcspec(l).srcimgs{k}, Vm{m}));
                        end;
                        Vso = rmfield(Vsi(1),'private');
                        [p n e v] = spm_fileparts(bch.srcspec(l).srcimgs{k});
                        if numel(Vm) == 1
                            out.masked{l}{k} = fullfile(p,[bch.srcspec(l).prefix lower(bch.srcspec(l).scope) n e]);
                            Vso.fname = out.masked{l}{k};
                        else
                            out.masked{l}{(k-1)*numel(Vm)+m} = fullfile(p, ...
                                                                        sprintf('%s%s%s_%0*d%s', ...
                                                                              bch.srcspec(l).prefix, ...
                                                                              lower(bch.srcspec(l).scope), ...
                                                                              n, floor(log10(numel(Vm)))+1, m, e));
                            Vso.fname = out.masked{l}{(k-1)*numel(Vm)+m};
                        end
                        if exist(Vso.fname,'file') && ~bch.srcspec(l).overwrite
                            error(['File ' Vso.fname ' already exists.']);
                        end
                        spm_imcalc(Vsi ,Vso, maskstr, {0,bch.srcspec(l).nanmask,bch.srcspec(l).interp});
                    end
                end
            end
        end
    case 'vout'
        out = cfg_dep;
        out = out(false);
        if ~isfield(bch.maskspec,'srcimg')
            out(1) = cfg_dep;
            out(1).sname = 'Created mask image(s)';
            out(1).src_output = substruct('.','mfiles');
            out(1).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
        end
        for l = 1:numel(bch.srcspec)
            out(end+1) = cfg_dep;
            out(end).sname = sprintf('Masked image(s), set %d',l);
            out(end).src_output = substruct('.','masked','{}',{l});
            out(end).tgt_spec   = cfg_findspec({{'filter','image','strtype','e'}});
        end
    case 'check'
        out = '';
        switch lower(varargin{1})
            case 'spheres'
                if numel(bch.radii) ~= 1 && numel(bch.radii) ~= size(bch.centers,1)
                    out = sprintf('Number of radii must be either 1 or equal to the number of sphere centers (%d).', size(bch.centers,2));
                end
        end
end