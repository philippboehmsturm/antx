function ACF = arfit_acf(obj, T)

coeff = arfit_coeff(obj);
%[Atiny Qtiny A Q V C] = arfit_coeff(obj);
%ACFlarge = vec_decomp( (eye((obj.dim * obj.order)^2) - kron(A, A)) \ vec(Q) );
%ACFlarge

V = coeff.V;
ACF = zeros(obj.dim, obj.dim, T+1);
D = diag(1 ./ (sqrt(diag(V(1:obj.dim, 1:obj.dim)))));

for p = 0:T
	ACF(:, :, p+1) = D * V(1:obj.dim, 1:obj.dim) * D;
	%ACF(:, :, p+1) = ACFlarge(1:obj.dim, 1:obj.dim);
	V = coeff.Alarge * V;
end
