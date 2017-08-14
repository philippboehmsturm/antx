function out = arfit_coeff(obj)
%function [A Q Alarge Qlarge V C] = arfit_coeff(obj)

V1 = cell(obj.order);
C1 = cell(obj.order);

for i = 0:obj.order-1
	for j = 0:obj.order-1
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

out.A = A(1:obj.dim, 1:obj.order * obj.dim);
out.Q = Q(1:obj.dim, 1:obj.dim);

out.Alarge = [out.A; eye(obj.dim * (obj.order - 1)) zeros(obj.dim * (obj.order - 1), obj.dim)];

out.SC = log(det(out.Q)) + log(obj.N) * obj.order * obj.dim ^ 2 / obj.N;
