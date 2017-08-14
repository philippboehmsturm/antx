function varargout = dti_saliencies(bch)
% Salient features
% 
% Computes salient features (curve-ness, plane-ness and sphere-ness) from 
% eigenvalue data:
%/*\begin{itemize}*/
%/*\item*/    sc*IMAGE curve-ness (l1-l2)/l1
%/*\item*/    sp*IMAGE plane-ness (l2-l3)/l1
%/*\item*/    ss*IMAGE sphere-ness l3/l1
%/*\end{itemize}*/
% These salient features are described in computer vision literature/*\cite{medioni00}*/.
%
% Batch processing
% FORMAT res = dti_saliencies(bch)
% ======
%/*\begin{itemize}*/
%/*\item*/ Input argument:
%   bch struct containing fields
%/*\begin{description}*/
%/*\item[*/       .limg/*]*/ cell array of image filenames of eigenvalue images
%/*\item[*/       .data/*]*/ alternatively, data as 3-by-xdim-by-ydim-by-zdim array.
%/*\end{description}*/
%/*\item*/ Output arguments:
%   res struct with fields .sc, .sp, .ss. These fields contain 
%       filenames, if input is from files, otherwise they contain 
%       the computed saliency maps.
%/*\end{itemize}*/
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_saliencies.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Salient features';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

if ~isfield(bch,'data')
        IEval = spm_vol(char(bch.limg));
        [p n e] = spm_fileparts(bch.limg{1});
        if length(n)>6 && strcmp(n(1:4), 'eval') 
                n=n(7:end);
        end;
        res.sc = {fullfile(p,['sc_' n e])};
        res.sp = {fullfile(p,['sp_' n e])};
        res.ss = {fullfile(p,['ss_' n e])};
        ISal(1) = IEval(1);
        ISal(1).fname = res.sc{1};
        ISal(1).descrip = 'Curve saliency (eval1-eval2)/eval1';
        ISal(1) = spm_imcalc(IEval,ISal(1),'(i1-i2)./i1');
        ISal(2) = IEval(1);
        ISal(2).fname = res.sp{1};
        ISal(2).descrip = 'Plane saliency (eval2-eval3)/eval1';
        ISal(2) = spm_imcalc(IEval,ISal(2),'(i2-i3)./i1');
        ISal(3) = IEval(1);
        ISal(3).fname = res.ss{1};
        ISal(3).descrip = 'Sphere saliency eval3/eval1';
        ISal(3) = spm_imcalc(IEval,ISal(3),'i3./i1');
else
        res.sc = squeeze((bch.data(1,:,:,:)-bch.data(2,:,:,:))./...
                         bch.data(1,:,:,:));
        res.sp = sqeeze((bch.data(2,:,:,:)-bch.data(3,:,:,:))./...
                        bch.data(1,:,:,:));
        res.ss = squeeze(bch.data(3,:,:,:)./bch.data(1,:,:,:));
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
