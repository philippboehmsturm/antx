function moh_smooth_job(p, fwhm)
% spatially smooth images with FWHM
%
% Mohamed Seghier 05.08.2007
% =======================================
%

if nargin == 1
    fwhm = [8 8 8] ;
end

jobs{1}.spatial{1}.smooth.fwhm = fwhm ;
jobs{1}.spatial{1}.smooth.dtype = 0 ;

jobs{1}.spatial{1}.smooth.data = p ;
spm_jobman('run' , jobs) ;

return;
