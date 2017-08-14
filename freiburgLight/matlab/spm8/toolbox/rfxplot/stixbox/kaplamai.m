function  [tt,pp] = kaplamai(x, color)
%KAPLAMAI Plot Kaplan-Maier estimate of survivor function.
%
%         kaplamai(x)
%         kaplamai([x, censored])
%         kaplamai([x, censored, group])
%
%	  Note that there is only one input, with 1, 2 or 3
%	  columns.

%       Copyright (c) Anders Holtsberg, 1998

if size(x,1) == 1
   x = x';
end
n = size(x,1);
if size(x,2)<2
   x(:,2) = zeros(n,1);
end
if ~all(x(:,2)==1|x(:,2)==0)
   error('The second column does not consist of only ones and zeros.')
end
if ~all(x(:,1)>0)
   warning('Normally time points should be positive.')
end

h = ishold;
if nargin > 1
   plotsym = color;
else
   plotsym = '0';
end

% === Multiple groups ========================
if size(x,2) > 2
   color = 'brgkm';
   j = 1;
   while size(x,1)>0
      indic = (x(:,3) == x(1,3));
      disp([color(j), ' is group ', num2str(x(1,3))])
      kaplamai(x(indic,1:2), color(j))
      x = x(find(indic==0),:);
      hold on
      j = j+1; if j==6, j=1; end
   end
   if h, hold on, else hold off, end
   return
end

% === OK, lets go ============================

n = size(x,1);
c = x(:,2);
x = x(:,1);
[x, i] = sort(x);
c = c(i);

atrisk = n + 1 - ranktrf(x);
p = 1 ./ atrisk(c==0);
q = 1 - p;
q = cumprod(q);
tdead = x(c==0);
qq = [1; q];
if tdead(1) > 0
   t = [0; tdead];
else
   t = [tdead(1); tdead];
end
if plotsym == '0'
   stairs(t, qq);
else
   stairs(t, qq, plotsym);
end
if ~h
   a = axis;
   a(3) = 0;
   axis(a)
end

% === That was it, folks =====================

if h, hold on, else hold off, end

if nargout > 0
   tt = tdead;
   pp = q;
end
