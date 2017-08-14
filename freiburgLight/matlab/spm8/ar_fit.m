function [out]=ar_fit(x,p)

if length(p)==1
    pmax=p;
    fit=arfit_init(pmax);
    fit = arfit_update(fit,x);
    out = arfit_coeff(fit);
else
    pfin=sort(p);
    pmax=max(pfin);
    fit=arfit_init(pmax);
    fit = arfit_update(fit,x);
    out = arfit_sparse_coeff(fit, pfin);
    
end