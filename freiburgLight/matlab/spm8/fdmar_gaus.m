%change distribution of x to a gaussian distributed x

function Xgaus = fdmar_gaus(X)

[y,ind]=sort(X);
[y,ind2]=sort(ind);
Xgaus=norminv(ind2/(length(ind2)+1),0,1);

end