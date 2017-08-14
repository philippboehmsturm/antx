function varargout = dti_indices(bch)
% Compute various invariants of diffusion tensor
%
% Batch processing
% FORMAT res = dti_indices(bch)
% ======
%/*\begin{itemize}*/
%/*\item*/ Input argument:
%   bch struct containing fields
%/*\begin{description}*/
%/*\item[*/       .dtimg/*]*/  cell array of filenames of DT images
%/*\item[*/       .data/*]*/   Xdim-by-Ydim-by-Zdim-by-6 array of tensors
%               Only one of .files and .data need to be given.
%/*\item[*/       .option/*]*/ character array with a combination of
%/*\begin{description}*/
%/*\item[*/               f/*]*/ Fractional Anisotropy
%/*\item[*/               v/*]*/ Variance Anisotropy. In the literature, this is 
%                 sometimes referred to as relative anisotropy, 
%                 multiplication by a scaling factor of 1/sqrt(2) 
%                 yields variance anisotropy.
%/*\item[*/               d/*]*/ Average Diffusivity
%/*\end{description}\end{description}*/
%/*\item*/ Output argument:
%   res struct containing fields (if requested)
%/*\begin{description}*/
%/*\item[*/       .fa/*]*/ FA output
%/*\item[*/       .va/*]*/ VA output
%/*\item[*/       .ad/*]*/ AD output
%/*\end{description}*/
%   where output is a filename if input is in files and a
%   Xdim-by-Ydim-by-Zdim array if input is a data array.
%/*\end{itemize}*/
%/* The algorithms used in this routine are based on \cite{basserNMR95}.*/
% 
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Anisotropy/Diffusivity';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

if ~isfield(bch,'data')
        IDT = spm_vol(char(bch.dtimg));
        X = spm_read_vols(IDT);
        [p n e] = spm_fileparts(IDT(1).fname);
        if ~isempty(regexp(n,'^((dt[1-6])|(D[x-z][x-z]))_.*', 'once'))
                n = n(5:end);
        end;
else
        X = bch.data;
end;
AD= mean(X(:,:,:,[1 4 6]),4);
A = X;
A(:,:,:,1) = A(:,:,:,1) - AD;
A(:,:,:,4) = A(:,:,:,4) - AD;
A(:,:,:,6) = A(:,:,:,6) - AD;

if any(bch.option=='f')
        FA=sqrt(3/2*(sum(A(:,:,:,[1 4 6]).^2,4) +...
                     2*sum(A(:,:,:,[2 3 5]).^2,4)) ./ ...
                (sum(X(:,:,:,[1 4 6]).^2,4) + 2*sum(X(:,:,:,[2 3 5]).^2,4)));
        if ~isfield(bch,'data')
                res.fa = {fullfile(p,['fa_' n e])};
                IFA = IDT(1);
                IFA.fname = res.fa{1};
                IFA.descrip = 'FA image';
                IFA.pinfo = [1; 0; 0];
                IFA.dt = [spm_type('float32') spm_platform('bigend')];
                IFA = spm_create_vol(IFA);
                IFA = spm_write_vol(IFA,FA);
        else
                res.fa = FA;
        end;
end;
if any(bch.option=='v')
        VA=sqrt(sum(A(:,:,:,[1 4 6]).^2,4) +...
                2*sum(X(:,:,:,[2 3 5]).^2,4)) ./ ...
           (sqrt(6).*AD);
        if ~isfield(bch,'data')
                res.va = {fullfile(p,['va_' n e])};
                IVA = IDT(1);
                IVA.fname = res.va{1};
                IVA.descrip = 'A_\sigma';
                IVA.pinfo = [1; 0; 0];
                IVA.dt = [spm_type('float32') spm_platform('bigend')];
                IVA = spm_create_vol(IVA);
                IVA = spm_write_vol(IVA,VA);
        else
                res.va = VA;
        end;
end;
if any(bch.option=='d')
        if ~isfield(bch,'data')
                res.ad = {fullfile(p,['ad_' n e])};
                IAD = IDT(1);
                IAD.fname = res.ad{1};
                IAD.descrip = 'Average Diffusivity';
                IAD.pinfo = [1; 0; 0];
                IAD.dt = [spm_type('float32') spm_platform('bigend')];
                IAD = spm_create_vol(IAD);
                IAD = spm_write_vol(IAD,AD);
        else
                res.ad = AD;
        end;
end;

spm_input('!DeleteInputObj');
if nargout>0
        varargout{1}=res;
else
        if isfield(bch,'data')
                fprintf('extracted information saved into workspace variable ''res''\n');
                assignin('base','res',res);
                disp(res);
        end;
end;
