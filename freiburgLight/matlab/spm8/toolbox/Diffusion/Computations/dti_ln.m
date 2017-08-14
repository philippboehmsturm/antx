function varargout = dti_ln(bch)
% Compute ln(Image)
%
% This routine computes the logarithm of image intensities. To avoid 
% numerical problems in DTI calculations (especially tensor estimation), 
% a threshold can be applied before the ln is taken. This threshold 
% defaults to 1, if not set to a different value at run-time.
%
% Batch processing
% FORMAT res = dti_ln(bch)
% ======
%/*\begin{itemize}*/
%/*\item*/ Input argument:
%   bch struct containing the following fields:
%/*\begin{description}*/
%/*\item[*/       .files/*]*/ cell array with file names
%/*\item[*/       .data/*]*/  data matrix (if data is given, then no files will be 
%              read or written)
%/*\item[*/       .minS/*]*/  minimum signal threshold. Set this to 1 to avoid 
%              negative ADC values.
%/*\end{description}*/
%/*\item*/ Output argument:
%   res struct with field .ln, containing a cell array of log 
%       image filenames. If data is given, .ln will contain the log 
%       data themselves.
%/*\end{itemize}*/
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Ln(I)';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

if ~isfield(bch,'data') || isempty(bch.data)
        spm_progress_bar('Init',numel(bch.files),'ln(i1)','Images completed');
        for k=1:length(bch.files) 
                V=spm_vol(bch.files{k});
                [p n e]=spm_fileparts(V.fname);
                res.ln{k} = fullfile(p,['ln_' n e]);
                LNV=V;
                LNV.fname=res.ln{k};
                LNV.dt(1) = spm_type('float32');
                LNV.descrip = [LNV.descrip, ' {ln(intensity) image}'];
                tmp = spm_read_vols(V);
                tmp(tmp<bch.minS) = bch.minS;
                spm_write_vol(LNV,log(tmp));
                spm_progress_bar('Set',k);
        end
        spm_progress_bar('Clear');
else
        tmp = bch.data;
        tmp(tmp<bch.minS) = bch.minS;
        res.ln = log(tmp);
end;

if nargout>0
        varargout{1} = res;
end;
