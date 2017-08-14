function [b,fval,exitflag,output] = dti_dt_fzero(x,varargin)
%FZERO  Scalar nonlinear zero finding. 
%   modified by VG from Matlab 6.5 for diffusion modelling:
%   hard-coded function to minimise.
%
%   X = FZERO(FUN,X0) tries to find a zero of the function FUN near X0. 
%   FUN accepts real scalar input X and returns a real scalar function value F 
%   evaluated at X.  The value X returned by FZERO is near a point where FUN 
%   changes sign (if FUN is continuous), or NaN if the search fails.  
%
%   X = FZERO(FUN,X0), where X is a vector of length 2, assumes X0 is an 
%   interval where the sign of FUN(X0(1)) differs from the sign of FUN(X0(2)).
%   An error occurs if this is not true.  Calling FZERO with an interval  
%   guarantees FZERO will return a value near a point where FUN changes 
%   sign.
%
%   X = FZERO(FUN,X0), where X0 is a scalar value, uses X0 as a starting guess. 
%   FZERO looks for an interval containing a sign change for FUN and 
%   containing X0.  If no such interval is found, NaN is returned.  
%   In this case, the search terminates when the search interval 
%   is expanded until an Inf, NaN, or complex value is found. 
%
%   X = FZERO(FUN,X0,OPTIONS) minimizes with the default optimization
%   parameters replaced by values in the structure OPTIONS, an argument
%   created with the OPTIMSET function.  See OPTIMSET for details.  Used
%   options are Display and TolX. Use OPTIONS = [] as a place holder if
%   no options are set.
%
%   X = FZERO(FUN,X0,OPTIONS,P1,P2,...) allows for additional arguments
%   which are passed to the function, F=feval(FUN,X,P1,P2,...).  Pass an empty
%   matrix for OPTIONS to use the default values.
%
%   [X,FVAL]= FZERO(FUN,...) returns the value of the objective function,
%   described in FUN, at X.
%
%   [X,FVAL,EXITFLAG] = FZERO(...) returns a string EXITFLAG that 
%   describes the exit condition of FZERO.  
%   If EXITFLAG is:
%      > 0 then FZERO found a zero X
%      < 0 then no interval was found with a sign change, or
%          NaN or Inf function value was encountered during search 
%          for an interval containing a sign change, or
%          a complex function value was encountered during search 
%          for an interval containing a sign change.
%   
%   [X,FVAL,EXITFLAG,OUTPUT] = FZERO(...) returns a structure
%   OUTPUT with the number of iterations taken in OUTPUT.iterations.
%
%   Examples
%     FUN can be specified using @:
%        X = fzero(@sin,3)
%     returns pi.
%        X = fzero(@sin, 3, optimset('disp','iter')) 
%     returns pi, uses the default tolerance and displays iteration information.
%
%     FUN can also be an inline object:
%        X = fzero(inline('sin(3*x)'),2);
%
%   Limitations
%        X = fzero(inline('abs(x)+1'), 1) 
%     returns NaN since this function does not change sign anywhere on the 
%     real axis (and does not have a zero as well).
%        X = fzero(@tan,2)
%     returns X near 1.5708 because the discontinuity of this function near the 
%     point X gives the appearance (numerically) that the function changes sign at X.
%
%   See also ROOTS, FMINBND, @, INLINE.

%   The grandfathered FZERO calling sequences:
%   FZERO(F,X,TOl) sets the relative tolerance for the convergence test.  
%   FZERO(F,X,TOL,TRACE) displays information at each iteration when
%   TRACE is nonzero.
%   FZERO(F,X,TOL,TRACE,P1,P2,...) allows for additional arguments
%   which are passed to the function, F(X,P1,P2,...).  Pass an empty
%   matrix for TOL or TRACE to use the default value.

%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 374 $  $Date: 2004-06-11 08:18:07 +0200 (Fr, 11. Jun 2004) $

%  This algorithm was originated by T. Dekker.  An Algol 60 version,
%  with some improvements, is given by Richard Brent in "Algorithms for
%  Minimization Without Derivatives", Prentice-Hall, 1973.  A Fortran
%  version is in Forsythe, Malcolm and Moler, "Computer Methods
%  for Mathematical Computations", Prentice-Hall, 1976.

% old: function b = fzero(FunFcn,x,tol,trace,varargin)

% Initialization
fcount = 0;
exitflag = 1;

defaultopt = struct('Display','notify','TolX',eps);

% If just 'defaults' passed in, return the default options in X
if nargin==1 & nargout <= 1 & isequal(x,'defaults')
   b = defaultopt;
   return
end

if nargin < 1, 
   error('FZERO requires at least one input arguments'); 
end

% Note: don't send varargin in as a comma separated list!!
numargin = nargin; numargout = nargout;
[tol, trace, calltype, varargin] = ...
   parse_call(x,defaultopt,numargin,numargout,varargin);

if strcmp(calltype,'old')
   %  The old calling syntax is being used.
   warning('MATLAB:fzero:ObsoleteSyntax', ...
       ['This syntax for calling FZERO is obsolete.  Use the\n',...
        '         following syntax instead:\n            ' ...
        'X = FZERO(FUN,X0,OPTIONS,P1,P2,...)\n',...
        '         See the help entry for FZERO for more information on \n',...
        '         syntax and usage.'])
end

% Convert to inline function as needed is done in PARSE_CALL
if trace > 2 
   header = ' Func-count      x           f(x)         Procedure';
   step=' '; 
end
if  (~isfinite(x))
   error('Second argument must be finite.')
end

% Interval input
if (length(x) == 2) 
   a = x(1); savea=a;
   b = x(2); saveb=b;
   % Put first feval in try catch
   try
      fa = diffT1(a,varargin{:});
   catch
     es = sprintf(['FZERO cannot continue because user supplied' ...
                   ' function \nfailed with the error below.\n\n%s '],  ...
                  lasterr);
 
      error(es)
   end
   fb = diffT1(b,varargin{:});
   if any(~isfinite([fa fb])) | any(~isreal([fa fb]))
      error('Function values at interval endpoints must be finite and real.')
   end
   if trace > 2
      disp(' ')
      disp(header)
      data = [a fa]; step='       initial';
      fcount = fcount + 1;
      disp([sprintf('%5.0f   %13.6g %13.6g ',fcount, data), step])
      data = [b fb]; step = '       initial';
      fcount = fcount + 1;    
      disp([sprintf('%5.0f   %13.6g %13.6g ',fcount, data), step])
   else  % this is in an else since in the "if", want the fcounts
         % added in one at a time, so can't do it before the if
      fcount = fcount + 2;
   end
   if ( fa == 0 )
      b = a;
      if trace > 1
         disp('Zero find terminated successfully.');
      end
      output.iterations = fcount;
      output.funcCount = fcount;
      output.algorithm = 'bisection, interpolation';
      fval = fa;
      return
   elseif ( fb == 0)
      % b = b;
      if trace > 1
         disp('Zero find terminated successfully.');
      end
      output.iterations = fcount;
      output.funcCount = fcount;
      output.algorithm = 'bisection, interpolation';
      fval = fb;
      return
   elseif (fa > 0) == (fb > 0)
      error('The function values at the interval endpoints must differ in sign.')
   end
   
   % Starting guess scalar input
elseif (length(x) == 1)
   % Put first feval in try catch
   try
      fx = diffT1(x,varargin{:});
   catch
       if ~isempty(Ffcnstr)
           es = sprintf(['FZERO cannot continue because user supplied' ...
                   ' %s ==> %s\nfailed with the error below.\n\n%s '],  ...
               Ftype,Ffcnstr,lasterr);
       else
           es = sprintf(['FZERO cannot continue because user supplied' ...
                   ' %s \nfailed with the error below.\n\n%s '],  ...
               Ftype,lasterr);
       end
      error(es)
   end
   if fx == 0
      b = x;
      if trace > 1
         disp('Zero find terminated successfully');
      end
      output.iterations = fcount;
      output.funcCount = fcount;
      output.algorithm = 'bisection, interpolation';
      fval = fx;
      return
   elseif ~isfinite(fx) | ~isreal(fx)
      error('Function value at starting guess must be finite and real.');
   end
   fcount = fcount + 1;     
   if trace > 2
      disp(' ')
      disp(header)
      data = [x fx]; step='       initial';
      disp([sprintf('%5.0f   %13.6g %13.6g ',fcount, data), step])
   end
   if x ~= 0, 
      dx = x/50;
   else, 
      dx = 1/50;
   end
   
   % Find change of sign.
   twosqrt = sqrt(2); 
   a = x; fa = fx; b = x; fb = fx;
   
   while (fa > 0) == (fb > 0)
      dx = twosqrt*dx;
      a = x - dx;  fa = diffT1(a,varargin{:});
      if ~isfinite(fa) | ~isreal(fa)
         exitflag = disperr(a,fa,trace);
         b = NaN; fval = NaN;
         output.iterations = fcount;
         output.funcCount = fcount;
         output.algorithm = 'bisection, interpolation';
         return
      end
      fcount = fcount + 1;
      if trace > 2         data = [a fa];  step='       search';
         disp([sprintf('%5.0f   %13.6g %13.6g ',fcount, data), step])
      end
      if (fa > 0) ~= (fb > 0)
         break
      end
      b = x + dx;  fb = diffT1(b,varargin{:});
      if ~isfinite(fb) | ~isreal(fb)
         exitflag = disperr(b,fb,trace);
         b = NaN; fval = NaN;
         return
      end
      fcount = fcount + 1;        
      if trace > 2
         data = [b fb];  step='       search';
         disp([sprintf('%5.0f   %13.6g %13.6g ',fcount, data), step])
      end
   end % while
   if trace > 2
      disp(' ')
      disp(['   Looking for a zero in the interval [', ...
            num2str(a) , ', ', num2str(b), ']']);
      disp(' ')
   end
   savea = a; saveb = b;
else
   error('Second argument must be of length 1 or 2.');
end % if (length(x) == 2

fc = fb;
% Main loop, exit from middle of the loop
while fb ~= 0
   % Insure that b is the best result so far, a is the previous
   % value of b, and c is on the opposite of the zero from b.
   if (fb > 0) == (fc > 0)
      c = a;  fc = fa;
      d = b - a;  e = d;
   end
   if abs(fc) < abs(fb)
      a = b;    b = c;    c = a;
      fa = fb;  fb = fc;  fc = fa;
   end
   
   % Convergence test and possible exit
   m = 0.5*(c - b);
   toler = 2.0*tol*max(abs(b),1.0);
   if (abs(m) <= toler) | (fb == 0.0), 
      break, 
   end
   
   % Choose bisection or interpolation
   if (abs(e) < toler) | (abs(fa) <= abs(fb))
      % Bisection
      d = m;  e = m;
      step='       bisection';
   else
      % Interpolation
      s = fb/fa;
      if (a == c)
         % Linear interpolation
         p = 2.0*m*s;
         q = 1.0 - s;
      else
         % Inverse quadratic interpolation
         q = fa/fc;
         r = fb/fc;
         p = s*(2.0*m*q*(q - r) - (b - a)*(r - 1.0));
         q = (q - 1.0)*(r - 1.0)*(s - 1.0);
      end;
      if p > 0, q = -q; else p = -p; end;
      % Is interpolated point acceptable
      if (2.0*p < 3.0*m*q - abs(toler*q)) & (p < abs(0.5*e*q))
         e = d;  d = p/q;
         step='       interpolation';
      else
         d = m;  e = m;
         step='       bisection';
      end;
   end % Interpolation
   
   % Next point
   a = b;
   fa = fb;
   if abs(d) > toler, b = b + d;
   else if b > c, b = b - toler;
      else b = b + toler;
      end
   end
   fb = diffT1(b,varargin{:});
   fcount = fcount + 1;      
   if trace > 2
      data = [b fb];  
      disp([sprintf('%5.0f   %13.6g %13.6g ',fcount, data), step])
   end
end % Main loop
output.iterations = fcount;
output.funcCount = fcount;
output.algorithm = 'bisection, interpolation';
fval = diffT1(b,varargin{:});
if trace > 1
   disp(['Zero found in the interval: [',num2str(savea),', ', num2str(saveb),'].']);
end

%------------------------------------------------------------------
function [tol, trace, calltype, otherargs]=parse_call(x,defaultopt,numargin,numargout,otherargs)
% old call: function b = fzero(FunFcn,x,tol,trace,varargin)
% new call: function b = fzero(FunFcn,x,options,varargin)

% New syntax has only 1 inputs: fzero(x)
if ( numargin < 2 )
   calltype = 'new';
   options = [];
else   % numargin >=3 
   thirdarg = otherargs{1};
   otherargs = otherargs(2:end);
   if (numargout  > 1) % new syntax if > 1 output
      calltype = 'new';
      options = thirdarg;
   elseif isstruct(thirdarg)   %  (numargout <= 1)
      % x = fzero(f,x,options,...)
      calltype = 'new'; 
      options = thirdarg;
   elseif  length(thirdarg)==1 & numargin==2 %  (numargout <= 1)
      % fzero(f,x,tol)
      calltype = 'old';
      tol = thirdarg; 
      trace = 0;
   elseif length(thirdarg)==1 & (numargin > 2 ) %  (numargout <= 1)
      % x = fzero(f,x,tol,trace,...)
      calltype = 'old';
      tol = thirdarg;
      trace = otherargs{1};
      otherargs = otherargs(2:end);
      
   elseif isempty(thirdarg) & numargin==2  %  (numargout <= 1)
      % x = fzero(f,x,[])
      calltype = 'new';
      options = [];
   elseif numargin > 2 & isempty(thirdarg)
      % x = fzero(f,x,[],...)
      % 4 or more args, 3rd is empty
      % Can't tell whether old or new call.
      
      warning('MATLAB:fzero:UndeterminedSyntax', ...
          ['Cannot determine from calling sequence whether to use new or\n', ...
          '  grandfathered FZERO function.  Using new; if call was ', ...
          'grandfathered\n  FZERO syntax, this may give unexpected results.']);
      options = thirdarg;
      calltype= 'new';
   else % 3 or more args but invalid thirdarg 
      % x = fzero(f,x,thirdarg,...)
      options = thirdarg;
      calltype = 'new';
   end
end

if isequal(calltype,'new')
   tol = optimget(options,'TolX',defaultopt,'fast');
   printtype = optimget(options,'Display',defaultopt,'fast');
   switch printtype
   case 'notify'
      trace = 1;
   case {'none', 'off'}
      trace = 0;
   case 'iter'
      trace = 3;
   case 'final'
      trace = 2;
   otherwise
      trace = 1;
   end
end



%------------------------------------------------------------------

function exitflag = disperr(y, fy, trace)
%DISPERR Display an appropriate error message when FY is Inf, 
%   NaN, or complex.  Assumes Y is the value and FY is the function 
%   value at Y. If FY is neither Inf, NaN, or complex, it generates 
%   an error message.

if ~isfinite(fy)  % NaN or Inf detected
   exitflag = -1;
   if trace > 0
      disp('Exiting fzero: aborting search for an interval containing a sign change');
      disp('    because NaN or Inf function value encountered during search ');
      disp(['(Function value at ', num2str(y),' is ',num2str(fy),')']);
      
      disp('Check function or try again with a different starting value.')
   end
elseif ~isreal(fy) % Complex value detected
   exitflag = -1;
   if trace > 0
      disp('Exiting fzero: aborting search for an interval containing a sign change');
      disp('    because complex function value encountered during search ');
      disp(['(Function value at ', num2str(y),' is ',num2str(fy),')']);
      
      disp('Check function or try again with a different starting value.')
   end
else
   error('DISPERR (in FZERO) called with invalid argument.')
end

function err = diffT1(t,t1,dx,vel)
% t1 directions are x, y, z, -x, -y, -z
% max(-x -y -z replaced by min(x y z
%err = min((t1(4)-t)/dx(1),0).^2 + min((t1(1)-t)/dx(1),0).^2 + ...
%    min((t1(5)-t)/dx(2),0).^2 + min((t1(2)-t)/dx(2),0).^2 + ...
%    min((t1(6)-t)/dx(3),0).^2 + min((t1(3)-t)/dx(3),0).^2 - 1/vel.^2;
err = sum(min((t1-t)./dx,0).^2) - 1/vel.^2;

return;
