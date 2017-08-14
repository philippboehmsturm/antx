function obj = fdmar_resar(obj)

%build estimated residuals and residuals of the ar - estimation
for order = 1:obj.order
    resmatrix(:,order) = obj.resgaus(obj.order-order+1:end-order);
end

obj.resest = resmatrix * obj.coeff';
obj.resar = obj.resgaus(obj.order+1:end) - obj.resest(1:end);

end