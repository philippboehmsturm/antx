%calulate theoretical ar spectrum out of estimated ar Parameters obj.A

function obj = fdmar_arspekth(obj)

A = obj.coeff;

obj.arspek = [];

for f = 1:1000
    sum=0;
    for p = 1:length(A)
        sum = sum + A(p) * exp(-2*sqrt(-1)*pi*p*f/2000);
    end
    obj.arspek(f+1) = (abs(1-sum))^(-2);
end
end
    