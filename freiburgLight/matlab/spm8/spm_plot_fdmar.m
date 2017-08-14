function glmar = spm_plot_fdmar(xSPM,SPM,hReg,Session,pflag)
% xSPM currently unused
if nargin < 5
    pflag = false;
end

%-coordinate
%--------------------------------------------------------------------------
if numel(hReg) == 1
    xyzvx = xSPM.M\[spm_XYZreg('GetCoords',hReg);1];
    xyzvx = xyzvx(1:3);
else
    xyzvx = hReg;
end


%-Get raw data and filter 
%--------------------------------------------------------------------------
y        = spm_get_data(SPM.xY.VY,xyzvx);
y        = spm_filter(SPM.xX.K,y);

%-residuals (non-whitened)
%----------------------------------------------------------------------

xX.xKXs  = spm_sp('Set',spm_filter(SPM.xX.K,SPM.xX.X));       % KWX
res      = spm_sp('r',xX.xKXs,y);  

%-coeff of ar fit
%----------------------------------------------------------------------
coeff    = arfit_coeff(SPM.xVi.arfit.Sess{Session});

%-stimuli
%----------------------------------------------------------------------
stimu = NaN;
szy = floor(log10(size(y,2))+1);
for k = 1:size(y,2)
    glmar(k) = fdmar_init(coeff.A,y(:,k),res(:,k),stimu);
    if pflag
        fdmar_plot(glmar(k),sprintf('fdmarplot_%0*d.png',szy,k));
    else
        fdmar_plot(glmar(k));
    end
end