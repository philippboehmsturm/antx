function out = arfit_sparse_coeff(obj, orders)
%function [A Q Alarge Qlarge V C] = arfit_coeff(obj)

num_orders = length(orders);

V1 = cell(num_orders);
C1 = cell(num_orders);

for i = orders-1
	for j = orders-1
		if i<=j
			V1{i+1,j+1} = obj.V{j-i+1};
			C1{i+1,j+1} = obj.V{j-i+2};
		else
			V1{i+1,j+1} = obj.V{i-j+1}';
			C1{i+1,j+1} = obj.V{i-j+2}';
		end
	end
end

out.V = cell2mat(V1);
out.C = cell2mat(C1);

A = out.C / out.V;
Q = (out.V - A * out.C') / obj.N;

out.Atiny = A(1:obj.dim, 1:num_orders * obj.dim);
out.Q = Q(1:obj.dim, 1:obj.dim);

Asplitted = mat2cell(out.Atiny, obj.dim, obj.dim(1, ones(1, num_orders)));
Apadded = cell(1, obj.order);
for i = 1:obj.order
	Apadded{i} = zeros(obj.dim);
end
for i = 1:num_orders
	Apadded{orders(i)} = Asplitted{i};
end
out.A = cell2mat(Apadded);

out.Alarge = [out.A; eye(obj.dim * (obj.order - 1)) zeros(obj.dim * (obj.order - 1), obj.dim)];

out.SC = log(det(out.Q)) + log(obj.N) * num_orders * obj.dim ^ 2 / obj.N;
