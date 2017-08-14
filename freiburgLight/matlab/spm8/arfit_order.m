function out = arfit_order(obj)

out = obj;

max_order = obj.order;
SC = zeros(max_order, 1);

pguess=1;
final=0;

for i = 1:max_order
	obj.order = i;
	coeff = arfit_coeff(obj);
	SC(i) = coeff.SC;
    if i>1
	  if SC(i) < SC(i-1)
         pguess=i;
      end
      if SC(i) > SC(i-1) & final==0
         pfinal=pguess;
         final=1;
      end
    else
        pfinal=1;
    end
end

out.estimated_order = pfinal;
out.trackorder(out.iter)=pfinal;
