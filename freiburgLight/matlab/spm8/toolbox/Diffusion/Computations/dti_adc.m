function varargout=dti_adc(job)
% ADC computation
%
% Computes ADC maps from 2 b values (lower b value is assumed to be zero). 
% More than one image can be entered for the high b value, in this case 
% it is necessary to specify one b value per image. If available, this b 
% value will be read from the userdata field of the image handle.
%
% Output images are saved as adc_<FILENAME_OF_B1_IMAGE>.img .
%
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'ADC';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

warning off;

Ib0 = spm_vol(job.file0{1});
Ib1 = spm_vol(char(job.files1));
for k=1:length(Ib1)
        Finter=spm('FigName', sprintf('%s - %d of %d', ...
                                      funcname, k, length(Ib1)), Finter);
        [p n e]=spm_fileparts(Ib1(k).fname);
        d = dti_get_dtidata(Ib1(k).fname);
        IADC=rmfield(Ib1(k),{'private','pinfo'});
        res.adc{k} = fullfile(p,[job.prefix n e]);
        IADC.fname = res.adc{k};
        IADC.dt = [spm_type('float32') spm_platform('bigend')]; % save as float
        adc_func=sprintf(['(log(i2)-log(i1))./(-%d).*(i1>%d).*(i2>%d) + '...
                          '(log(%d)-log(i1))./(-%d).*(i1>%d).*(i2<=%d) + '...
                          '(log(i2)-log(%d))./(-%d).*(i1<=%d).*(i2>%d)'], ...
                         d.b, job.minS, job.minS,...
                         job.minS, d.b, job.minS, job.minS, ...
                         job.minS, d.b, job.minS, job.minS); % avoid log(0)
        IADC=spm_imcalc([Ib0,Ib1(k)],IADC,adc_func,{0,0,job.interp});
        dti_get_dtidata(IADC.fname,d);
end;
warning on;
varargout{1} = res;