function varargout=dti_hosvd(bch)
% Compute SVD for higher order tensors
% 
% Batch processing
% FORMAT res = dti_hosvd(bch)
% ======
%/*\begin{itemize}*/
%/*\item*/ Input argument:
%  bch struct with fields
%/*\begin{description}*/
%/*\item[*/       .data/*]*/    tensor elements in alphabetical index order (if data is 
%                given, then no files will be read or written)
%/*\item[*/       .dtimg/*]*/   cell array with file names of images
%/*\item[*/       .dtorder/*]*/ tensor order
%/*\end{description}*/
%/*\item*/ Output argument:
%   res  struct with fields
%/*\begin{description}*/
%/*\item[*/        .S/*]*/ singular tensor (elements in alphabetical index order)
%/*\item[*/        .U/*]*/ cell array of singular matrices
%/*\end{description}\end{itemize}*/
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_hosvd.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Higher order SVD';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

spm('pointer','watch');
dirs='xyz';
if ~isfield(bch,'data')
        V = spm_vol(char(bch.dtimg));
        dsz = [numel(V) V(1).dim(1:2)];
        np = V(1).dim(3);
        SV = V;
        for k=1:numel(SV)
                [p n e] = spm_fileparts(SV(k).fname);
                if n(1)=='D'
                        n(1)='S';
                else
                        n = ['S' n];
                end;
                SV(k).fname = fullfile(p, [n e]);
        end;
        SV=spm_create_vol(SV);
        res.S = cellstr(char(SV.fname));
        [p n e] = spm_fileparts(V(1).fname);
        if ~isempty(regexp(n, sprintf('^D%s_.*', repmat('[x-z]',1,bch.dtorder)), 'once'))
                n = n(bch.dtorder+2:end);
        end;
        for k=1:3
                for l=1:3
                        UV(k,l)=V(1);
                        UV(k,l).fname = fullfile(p, [sprintf('U%d%s_%s',l,dirs(k),n) e]);
                end;
        end;
        UV=spm_create_vol(UV);
        res.U = cellstr(char(UV(:).fname));
else
        dsz = size(bch.data);
        res.S = NaN*zeros(dsz);
        np = 1;
end;
if dsz(1) ~= (bch.dtorder+1)*(bch.dtorder+2)/2
        error('Wrong data size');
end;
[Hind mult iHperm] = dti_dt_order(bch.dtorder);
Tsz = 3*ones(1,bch.dtorder);
if np > 1
        spm_progress_bar('init',np,'hosvd','Planes completed');
end;
for cp = 1:np
        if ~isfield(bch,'data')
                data = zeros(dsz);
                M = eye(4);
                M(3,4) = -cp;
                M = inv(M);
                for k=1:dsz(1)
                        data(k,:,:) = spm_slice_vol(V(k),M,dsz(2:3),0);
                end;
                S = NaN*zeros(dsz);
                U = NaN*zeros([3 3 dsz(2:3)]);
        else
                data = bch.data;
        end;
        for k=1:prod(dsz(2:end))
                if all(isfinite(data(:,k))) 
                        T = dti_dt_reshape(data(:,k),bch.dtorder,iHperm);
                        if prod(dsz(2:end))==1 % compute U only for single tensor
                                Ustr = sprintf('res.U{%d} ',1:bch.dtorder);
                        else
                                U1 = zeros(3,3,bch.dtorder);
                                Ustr = sprintf('U1(:,:,%d) ',1:bch.dtorder);
                        end;
                        eval(sprintf('[S1 %s] = hosvd(T);', Ustr));
                        if ~isfield(bch,'data')
                                S(:,k) = dti_dt_reshape(S1,bch.dtorder,iHperm);
                                U(:,:,k) = U1(:,:,1);
                        else
                                res.S(:,k) = dti_dt_reshape(S1,bch.dtorder,iHperm);
                        end;
                end;
        end;
        if ~isfield(bch,'data')
                for p = 1:(bch.dtorder+1)*(bch.dtorder+2)/2
                        SV(p)=spm_write_plane(SV(p),squeeze(S(p,:,:)),cp);
                end;
                for k=1:3
                        for l=1:3
                                UV(k,l)=spm_write_plane(UV(k,l),squeeze(U(k,l,:,:)),cp);
                        end;
                end;
        end;
        if np > 1
                spm_progress_bar('set',cp);
        end;
end;
spm_progress_bar('clear');
if nargout > 0
        varargout{1} = res;
elseif isfield(bch,'data')
        fprintf('extracted information saved into workspace variable ''res''\n');
        assignin('base','res',res);
end;
spm('pointer','arrow');
