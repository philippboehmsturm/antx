function ret = spm_ov_pli(varargin)
% This routine is a plugin to spm_orthviews for SPM. For general help about
% spm_orthviews and plugins type
%             help spm_orthviews
% at the matlab prompt.
%_______________________________________________________________________
%
% $Id: spm_ov_pli.m 712 2010-06-30 14:20:19Z glauche $

global st;

if isempty(st)
    error('pli: This routine can only be called as a plugin for spm_orthviews!');
end;

if nargin < 2
    error('pli: Wrong number of arguments. Usage: spm_orthviews(''pli'', cmd, volhandle, varargin)');
end;

cmd = lower(varargin{1});
volhandle = varargin{2};
switch cmd
    case 'init'
        if nargin < 4
            error('spm_orthviews(''pli'', ''init'',...): Not enough arguments');
        end;
        Vq = spm_vol(varargin{3});
        Vmask = spm_vol(varargin{4});
        if numel(Vq) == 3
            st.vols{volhandle}.pli = struct('qx',Vq(1), 'qy',Vq(2), 'qz',Vq(3), ...
                'mask',Vmask, 'fa',[], 'thresh', [.1 Inf], 'qht',[], ...
                                            'qhc',[], 'qhs',[]);
        else
            error('spm_orthviews(''pli'', ''init'',...): Please specify 3 images!');
        end;
        if nargin > 4
            if ~isempty(varargin{5})
                st.vols{volhandle}.pli.fa = spm_vol(varargin{5});
            end;
        end;
        if nargin > 5
            if ~isempty(varargin{6})
                st.vols{volhandle}.pli.thresh(1) = varargin{6};
            end;
        end;
        if nargin > 6
            if ~isempty(varargin{7})
                st.vols{volhandle}.pli.thresh(2) = varargin{7};
            end;
        end;

    case 'redraw'
        TM0 = varargin{3};
        TD  = varargin{4};
        CM0 = varargin{5};
        CD  = varargin{6};
        SM0 = varargin{7};
        SD  = varargin{8};
        if isfield(st.vols{volhandle},'pli')
            % need to delete old overlays before redrawing
            ov = findobj(0,'Tag',['PLI_OV_1_' num2str(volhandle)]);
            if ~isempty(ov)
                try
                    delete(ov);
                end
            end
            st.vols{volhandle}.pli.qht = [];
            st.vols{volhandle}.pli.qhc = [];
            st.vols{volhandle}.pli.qhs = [];
            
            qx  = st.vols{volhandle}.pli.qx;
            qy  = st.vols{volhandle}.pli.qy;
            qz  = st.vols{volhandle}.pli.qz;
            mask = st.vols{volhandle}.pli.mask;
            fa = st.vols{volhandle}.pli.fa;
            thresh(1) = st.vols{volhandle}.pli.thresh(1);
            thresh(2) = st.vols{volhandle}.pli.thresh(2);

            Mx   = st.vols{volhandle}.premul*qx.mat;
            My   = st.vols{volhandle}.premul*qy.mat;
            Mz   = st.vols{volhandle}.premul*qz.mat;
            Mm   = st.vols{volhandle}.premul*mask.mat;
            if ~isempty(fa)
                fat = spm_slice_vol(fa,inv(TM0*(st.Space\Mx)),TD,0)';
            else
                fat = 1;
            end;
            rqt = cat(3, spm_slice_vol(qx,inv(TM0*(st.Space\Mx)),TD,0)', ...
                spm_slice_vol(qy,inv(TM0*(st.Space\My)),TD,0)', ...
                spm_slice_vol(qz,inv(TM0*(st.Space\Mz)),TD,0)');
            rqt = st.Space(1:3,1:3)*st.vols{volhandle}.premul(1:3,1:3)*reshape(rqt,TD(1)*TD(2),3)';
            qxt = reshape(rqt(1,:)',TD(2),TD(1));
            qyt = reshape(rqt(2,:)',TD(2),TD(1));
            qzt = reshape(rqt(3,:)',TD(2),TD(1));

            maskt = spm_slice_vol(mask,inv(TM0*(st.Space\Mm)),TD,0)';
            maskt = fat.*((maskt >= thresh(1))&(maskt <= thresh(2)));

            if ~isempty(fa)
                fac = spm_slice_vol(fa,inv(CM0*(st.Space\Mx)),CD,0)';
            else
                fac = 1;
            end;
            rqc = cat(3, spm_slice_vol(qx,inv(CM0*(st.Space\Mx)),CD,0)', ...
                spm_slice_vol(qy,inv(CM0*(st.Space\My)),CD,0)', ...
                spm_slice_vol(qz,inv(CM0*(st.Space\Mz)),CD,0)');
            rqc = st.Space(1:3,1:3)*st.vols{volhandle}.premul(1:3,1:3)*reshape(rqc,CD(1)*CD(2),3)';
            qxc = reshape(rqc(1,:)',CD(2),CD(1));
            qyc = reshape(rqc(2,:)',CD(2),CD(1));
            qzc = reshape(rqc(3,:)',CD(2),CD(1));

            maskc = spm_slice_vol(mask,inv(CM0*(st.Space\Mm)),CD,0)';
            maskc = fac.*((maskc >= thresh(1))&(maskc <= thresh(2)));

            if ~isempty(fa)
                fas = spm_slice_vol(fa,inv(SM0*(st.Space\Mx)),SD,0)';
            else
                fas = 1;
            end;
            rqs = cat(3, spm_slice_vol(qx,inv(SM0*(st.Space\Mx)),SD,0)', ...
                spm_slice_vol(qy,inv(SM0*(st.Space\My)),SD,0)', ...
                spm_slice_vol(qz,inv(SM0*(st.Space\Mz)),SD,0)');
            rqs = st.Space(1:3,1:3)*st.vols{volhandle}.premul(1:3,1:3)*reshape(rqs,SD(1)*SD(2),3)';
            qxs = reshape(rqs(1,:)',SD(2),SD(1));
            qys = reshape(rqs(2,:)',SD(2),SD(1));
            qzs = reshape(rqs(3,:)',SD(2),SD(1));

            masks = spm_slice_vol(mask,inv(SM0*(st.Space\Mm)),SD,0)';
            masks = fas.*((masks >= thresh(1))&(masks <= thresh(2)));

            % transversal - plot (x y z)
            np = get(st.vols{volhandle}.ax{1}.ax,'NextPlot');
            set(st.vols{volhandle}.ax{1}.ax,'NextPlot','add');
            cimgt = repmat(abs(qzt),[1,1,3])+repmat(1-abs(qzt),[1,1,3]).*cat(3,abs(qxt),abs(qyt),zeros(size(qxt)));
            st.vols{volhandle}.pli.qht = imagesc(cimgt,'Alphadata',maskt, ...
                                                 'Parent',st.vols{volhandle}.ax{1}.ax);
            set(st.vols{volhandle}.ax{1}.ax,'NextPlot',np);
            set(st.vols{volhandle}.pli.qht, ...
                'Parent',st.vols{volhandle}.ax{1}.ax, 'HitTest','off', ...
                'Tag',['PLI_OV_1_' num2str(volhandle)]);

            % coronal - plot (x z y)
            np = get(st.vols{volhandle}.ax{2}.ax,'NextPlot');
            set(st.vols{volhandle}.ax{2}.ax,'NextPlot','add');
            cimgc = repmat(abs(qyc),[1,1,3])+repmat(1-abs(qyc),[1,1,3]).*cat(3,abs(qxc),abs(qzc),zeros(size(qxc)));
            st.vols{volhandle}.pli.qhc = imagesc(cimgc,'Alphadata',maskc, ...
                                                 'Parent',st.vols{volhandle}.ax{2}.ax);
            set(st.vols{volhandle}.ax{2}.ax,'NextPlot',np);
            set(st.vols{volhandle}.pli.qhc, ...
                'Parent',st.vols{volhandle}.ax{2}.ax, 'HitTest','off', ...
                'Tag',['PLI_OV_1_' num2str(volhandle)]);

            % sagittal - plot (-y z x)
            np = get(st.vols{volhandle}.ax{3}.ax,'NextPlot');
            set(st.vols{volhandle}.ax{3}.ax,'NextPlot','add');
            cimgs = repmat(abs(qxs),[1,1,3])+repmat(1-abs(qxs),[1,1,3]).*cat(3,abs(qys),abs(qzs),zeros(size(qys)));
            st.vols{volhandle}.pli.qhs = imagesc(cimgs,'Alphadata',masks, ...
                                                 'Parent',st.vols{volhandle}.ax{3}.ax);
            set(st.vols{volhandle}.ax{3}.ax,'NextPlot',np);
            set(st.vols{volhandle}.pli.qhs, ...
                'Parent',st.vols{volhandle}.ax{3}.ax, 'HitTest','off', ...
                'Tag',['PLI_OV_1_' num2str(volhandle)]);
        end;

    case 'delete'
        if isfield(st.vols{volhandle},'pli'),
            delete(st.vols{volhandle}.pli.qht);
            delete(st.vols{volhandle}.pli.qhc);
            delete(st.vols{volhandle}.pli.qhs);
            st.vols{volhandle} = rmfield(st.vols{volhandle},'pli');
        end;
        %-------------------------------------------------------------------------
        % Context menu and callbacks
    case 'context_menu'
        item0 = uimenu(varargin{3}, 'Label', 'PLI RG(W) overlay');
        item1 = uimenu(item0, 'Label', 'Add', 'Callback', ...
            ['feval(''spm_ov_pli'',''context_init'', ', ...
            num2str(volhandle), ');'], 'Tag', ['PLI_0_', num2str(volhandle)]);
        item3 = uimenu(item0, 'Label', 'Remove', 'Callback', ...
            ['feval(''spm_ov_pli'',''context_delete'', ', ...
            num2str(volhandle), ');'], 'Visible', 'off', ...
            'Tag', ['PLI_1_', num2str(volhandle)]);

    case 'context_init'
        Finter = spm_figure('FindWin', 'Interactive');
        spm_input('!DeleteInputObj',Finter);
        [Vqfnames, sts] = spm_select(3, 'image',...
            'Components of 1st eigenvector',[], ...
            pwd, 'evec1.*');
        if ~sts
            return;
        end;
        [Vmaskfname, sts] = spm_select(1,'image', 'Mask image');
        if ~sts
            return;
        end;
        Vfafname = spm_select(Inf,'image', 'Fractional anisotropy image', [], ...
            pwd, 'fa.*');
        feval('spm_ov_pli','init',volhandle,Vqfnames,Vmaskfname,Vfafname);
        obj = findobj(0, 'Tag',  ['PLI_1_', num2str(volhandle)]);
        set(obj, 'Visible', 'on');
        obj = findobj(0, 'Tag',  ['PLI_0_', num2str(volhandle)]);
        set(obj, 'Visible', 'off');
        spm_orthviews('redraw');

    case 'context_edit'
        Finter = spm_figure('FindWin', 'Interactive');
        spm_input('!DeleteInputObj',Finter);
        switch varargin{3}
            case 'thresh'
                in = spm_input('Mask threshold {min max}','!+1','e', ...
                    num2str(st.vols{volhandle}.pli.thresh), [1 2]);
            case 'ls'
                in = spm_input('Line style','!+1','s', ...
                    st.vols{volhandle}.pli.ls);
            case 'qst'
                in = spm_input('Quiver distance','!+1','e', ...
                    num2str(st.vols{volhandle}.pli.qst), 1);
            case 'ql'
                in = spm_input('Quiver length','!+1','e', ...
                    num2str(st.vols{volhandle}.pli.ql), 1);
            case 'qw'
                in = spm_input('Linewidth','!+1','e', ...
                    num2str(st.vols{volhandle}.pli.qw), 1);
        end;
        spm_input('!DeleteInputObj',Finter);
        st.vols{volhandle}.pli.(varargin{3}) = in;
        spm_orthviews('redraw');

    case 'context_delete'
        feval('spm_ov_pli','delete',volhandle);
        obj = findobj(0, 'Tag',  ['PLI_1_', num2str(volhandle)]);
        set(obj, 'Visible', 'off');
        obj = findobj(0, 'Tag',  ['PLI_0_', num2str(volhandle)]);
        set(obj, 'Visible', 'on');

    otherwise

        fprintf('spm_orthviews(''pli'',...): Unknown action string %s', cmd);
end;
