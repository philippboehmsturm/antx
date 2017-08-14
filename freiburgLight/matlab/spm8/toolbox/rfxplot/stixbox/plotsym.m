function plotsym(x,y,a3,a4,a5,a6,a7)
%PLOTSYM  Plot with symbols
%
%	  plotsym(x,y,S)
%	  plotsym(x,y,s,S,c,C,symsize)
%
%	  Input S is one of the following
%
%	  's'  square           
%         'd'  diamond
%         't'  triangle
%	  'i'  inverted triangle
%	  'l'  left triangle
%	  'r'  right triangle
%	  'c'  circle
%	
%	  In the longer call s is vector that contains category marker that
%	  is plotted with symbol from text string S, i.e element i is 
%	  plotted with symbol S(s(i)), c is vector for colormarking, and
%	  C is corresponding string of 'rgbcymwk' in permuted order. If C
%	  is omitted then c is taken as a colour in itself. The colors
%	  may then be changed by calling colormap. The input symsize 
%	  defines the symbol size relative to the default size which is 1.
%	  It may be a scalar, which is then applied to all symbols, or a 
%	  vector, one for each symbol. Examples:
%
%	  plotsym(x,y,z,'st','rb')
%	     Points x,y are plotted with red squares (z=1) or blue
%	     triangles (z=2).
%
%	  plotsym(x,y,'s',z,2)
%	     Points x,y are plotted with squares of twice the standard 
%	     size, filled with colors according to value in z and current 
%	     colormap.
%
%	  Note: in Matlab 5.x the built in plot function now has similar
%	  functionality.
%
%	  See also PLOT and COLORMAP

x = x(:);
y = y(:);
n = length(x);

symbol = ones(n,1);
symboltable = 'stcidlr';
color = [];
colortable = [];
symsize = ones(n,1);

s1 = 1; 
s2 = 1;
for i=3:nargin
   v = eval(['a',num2str(i)]);
   if isstr(v)
      if s1 == 1
         symboltable = v;
         s1 = 2;
         s2 = 2;
      else
         colortable = v;
         s2 = 3;
      end
   else
      if s2 == 1
         symbol = v;
         s2 = 2;
      elseif s2 == 2
         color = v;
         s2 = 3;
      else
         symsize = v;
      end
   end
end

if isempty(color)
   if isempty(colortable) 
      colortable = 'rbgcmywk';
   end
   color = colortable(rem(symbol-1,length(colortable))+1);
   color = color(:);
elseif ~isempty(colortable)
   color = colortable(color);
elseif length(color) < length(x)
   color = color(symbol);
end
symbol = symboltable(symbol);
if length(symsize) == 1
   symsize = symsize(ones(n,1));
end

if ~ishold 
   cla reset 
   sx = max(x)-min(x);
   sy = max(y)-min(y);
else
   a = axis;
   sx = max([a(2);x])-min([a(1);x]);
   sy = max([a(4);y])-min([a(3);y]);
end
P = get(gca,'Position');
P = P(3)/P(4);
dx = sx/25/P/1.3;
dy = sy/25;

Ss = [-1 1 1 -1; -1 -1 1 1]/4;
Ds = [-1 0 1 0; 0 -1 0 1]/2/sqrt(2);
Ts = [-sqrt(3)/2 0 sqrt(3)/2; 0.5 -1 0.5]/sqrt(3)/1.5;
Is = [-sqrt(3)/2 0 sqrt(3)/2; -0.5 1 -0.5]/sqrt(3)/1.5;
Ls = [0.5 -1 0.5; -sqrt(3)/2 0 sqrt(3)/2]/sqrt(3)/1.5;
Rs = [-0.5 1 -0.5; -sqrt(3)/2 0 sqrt(3)/2]/sqrt(3)/1.5;
Cs = [sin(pi*(0:31)/16); cos(pi*(0:31)/16)]/pi;

for i=1:n
   si = symbol(i);
   if     si == 's', sym = Ss;
   elseif si == 'd', sym = Ds;
   elseif si == 't', sym = Ts;
   elseif si == 'i', sym = Is;
   elseif si == 'l', sym = Ls;
   elseif si == 'r', sym = Rs;
   elseif si == 'c', sym = Cs;
   end
   p = patch(x(i)+dx*symsize(i)*sym(1,:),y(i)+dy*symsize(i)*sym(2,:),color(i));
   % set(p,'EdgeColor',[1 1 1]); % Uncomment for Matlab 4.x
end

set(gca,'Box','on');
grid