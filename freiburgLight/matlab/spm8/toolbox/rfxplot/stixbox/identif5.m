function v = identif5(x,y,arg3,arg4)
%IDENTIF5 Identify points on a plot by clicking with the mouse.
%
%         v = identif5(x,y)
%
%	  This routine plots x versus y and waits for mouse clicks
%	  to identify points. Click with left button on points and 
%	  end with middle button or space bar. Plotsymbol and text 
%	  strings are optional input arguments. 
%	  THIS IS THE SAME AS IDENTIFY, BUT IT CAN TAKE CELL
%	  ARRAYS AS TEXT STRINGS -- ONLY MATLAB 5.

%       GPL Copyright (c) Anders Holtsberg, 1998

plotsymbol = '*';
textvector = 1:length(x);
for i = 3:nargin
   if i == 3
      A = arg3;
   else
      A = arg4;
   end
   if max(size(A)) <= 1
      plotsymbol = A; 
   elseif size(A,1) == length(x) | ...
         (size(A,1) == 1 & size(A,2) == length(x)) | iscell(A)         
      if min(size(A)) == 1 
         A = A(:);
      end
      textvector = A;
   else
      error('Argument incompatibility')
   end
end

if ~isempty(plotsymbol), plot(x,y,plotsymbol); end
cx = cov(x);
cy = cov(y);
v = [];
B = 1;
while B == 1 
  [xc,yc,B] = ginput(1);
  if B == 1
    d = (x-xc).^2/cx+(y-yc).^2/cy;
    [d i] = sort(d);
    i = i(1);
    v = [v; i];
    hold on
    if isstr(textvector)
       text(xc,yc,textvector(i,:));
    elseif iscell(textvector)
       text(xc,yc,textvector{i});
    else
       text(xc,yc,sprintf(' %g',textvector(i)));
    end
  end
end
hold off
