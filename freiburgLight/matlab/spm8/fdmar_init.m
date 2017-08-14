%A -> Parameter Matrix of arfit_coeff()
%X -> filtered data
%res -> residuals of the glm-analysis (first pass of spm_spm)
%stimu -> stiumuli from the experiment

function obj = fdmar_init(A,X,res,stimu)

obj.order = length(A);
obj.coeff = A;
obj.X = X;
obj.res = res;
obj.stimu = stimu;

obj.resgaus=fdmar_gaus(res);
obj=fdmar_resar(obj);
obj=fdmar_arspekth(obj);

end