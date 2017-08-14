function varargout=dti_dt_adc(job)
% Compute diffusion tensor from 6 ADC images
%
% This function computes diffusion tensors of order 2 from exactly 6 ADC 
% images that have been acquired with different diffusion weightings. If 
% your dataset consists of more diffusion weightings or repeated 
% measurements with 6 diffusion weightings, use the regression method to 
% compute the tensors from the original diffusion weighted images.
%
% This routine tries to figure out gradient direction from userdata field 
% of the ADC images. This may fail if
%/*\begin{itemize}*/
%/*\item*/ there is no userdata: in this case, the following direction scheme is 
%   assumed:
%/*\begin{tabular}{c|ccccccc}*/
%          /*&*/    b0 /*&*/ im1 /*&*/ im2 /*&*/ im3 /*&*/ im4 /*&*/ im5 /*&*/ im6 /*\\*/
%/*\hline*/
%        x /*&*/   0 /*&*/  0 /*&*/   0 /*&*/   1 /*&*/   1 /*&*/   1 /*&*/   1 /*\\*/
%        y /*&*/   0 /*&*/  1 /*&*/   1 /*&*/   0 /*&*/   0 /*&*/   1 /*&*/  -1 /*\\*/
%        z /*&*/   0 /*&*/  1 /*&*/  -1 /*&*/   1 /*&*/  -1 /*&*/   0 /*&*/   0
%/*\end{tabular}*/
%/*\item*/ there are some identical directions in userdata: This happens with some 
%   SIEMENS standard sequences on Symphony/Sonata/Trio systems. In that 
%   case, a warning is issued and SIEMENS standard values are used.
%/*\end{itemize}*/
%/* The algorithm used in this routine is based on \cite{basser98}, */ 
%/* although the direction scheme actually used depends on the applied */ 
%/* diffusion imaging sequence.*/
%
% This function is part of the diffusion toolbox for SPM5. For general help  
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Tensor (from ADC)';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

IADC = spm_vol(char(job.files));
[p n e]=spm_fileparts(IADC(1).fname);
if strcmp(n(1:4),'adc_')
    n=n(5:end);
end;
dirs={'xx','yy','zz','xy','xz','yz'};
for k=1:6
    IDTI(k)=rmfield(IADC(1),'private');
    IDTI(k).dt = [spm_type('float32') spm_platform('bigend')];
    res.dt{k} = fullfile(p, sprintf('D%s_%s%s',dirs{k}, n, e));
    IDTI(k).fname= res.dt{k};
end;

try
    fprintf('Using gradient information from userdata\n');
    C = eye(3);%[0 -1 0; 1 0 0; 0 0 1];
    for k=1:6
        tmp(k) = dti_get_dtidata(IADC(k).fname);
    end;
    prs = cat(1,tmp.g)';
    % workaround for buggy SIEMENS DTI sequences
    if size(unique(prs','rows')',2) ~= 6
        warning(['Some gradient directions seem to be identical -  ' ...
                 'replacing directions with SIEMENS defaults']);
        prs = [ 1.0,  0.0,  1.0; -1.0,  0.0,  1.0; 0.0, -1.0,  1.0; 0.0, ...
                -1.0, -1.0; 1.0, -1.0,  0.0; -1.0, -1.0,  0.0]'; % flip y
                                                                 % already
                                                                 % incorporated
    end;
catch
    fprintf('No gradient information found in userdata - using default\n');
    C = [0 1 0; -1 0 0; 0 0 1];
    prs = [ 0  0  1  1  1  1; 1  1  0  0  1 -1; 1 -1  1 -1  0  0];
end;

rv1 = 1/sqrt(2)*C*prs;

rv = rv1';
for k=1:6
    R(k,:)=[rv(k,:).*rv(k,:) 2*rv(k,1)*rv(k,2) 2*rv(k,1)*rv(k,3) ...
            2*rv(k,2)*rv(k,3)];
end;

Ri=inv(R);

for k=1:6
    Finter=spm('FigName', sprintf('%s - %d of 6', funcname, k), Finter);
    c=Ri(k,:);
    nIDTI(k)=spm_imcalc(IADC,IDTI(k),'c*X',{1,0,job.interp},c);
end;
if nargout > 0
    varargout{1} = res;
end;