



%% get path and struct with FPlinks to ANT and TPMs in refspace
%  [pathx s]=antpath

function [pathx s]=antpath(arg)

pathx=fileparts(mfilename('fullpath'));
s.refpa=fullfile(pathx, 'templateBerlin_hres');
s.refTPM={...
    fullfile(s.refpa,'_b1grey.nii')
    fullfile(s.refpa,'_b2white.nii')
    fullfile(s.refpa,'_b3csf.nii')
  };
s.ano=fullfile(s.refpa,'ANO.nii');
s.avg =fullfile(s.refpa,'AVGT.nii');
s.fib =fullfile(s.refpa,'FIBT.nii');
s.refsample= fullfile(s.refpa,'_sample.nii');
s.gwc =fullfile(s.refpa,'GWC.nii');


if exist('arg')
  explorer(pathx);  
end



