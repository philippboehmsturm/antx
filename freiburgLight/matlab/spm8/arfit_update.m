function obj = arfit_update(obj, x)

%change the distribution of x to gaussian distributed data
[y,ind]=sort(x);
[y,ind2]=sort(ind);
x=norminv(ind2/(length(ind2)+1),0,1);

%arfit
try
	obj.dim;
catch
	obj.dim = size(x, 2);
	for p = 0:obj.order
		obj.V{1+p} = zeros(obj.dim);
	end
end

obj.N = obj.N + size(x, 1) - mean(sum(isnan(x)));
x(isnan(x)) = 0;

obj.iter=obj.iter+1;

for p = 0:obj.order
	obj.V{1+p} = obj.V{1+p} + x(1+p:end, :)' * x(1:end-p, :);
end