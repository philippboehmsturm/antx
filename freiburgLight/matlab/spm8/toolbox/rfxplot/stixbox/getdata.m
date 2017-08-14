function x = getdata(i)
%DATASETS Famous datasets.
%
%	  x = getdata(i)
%
%	  where i is
%
%		1  Phosphorus Data
%		2  Scottish Hill Race Data
%		3  Salary Survey Data
%		4  Health Club Data
%		5  Brain and Body Weight Data
%		6  Cement Data
%		7  Colon Cancer Data
%		8  Growth Data
%		9  Consumption Function
%		10 Cost-of-Living Data
%		11 Demographic Data
%	  
%	  To get rid of the help text supply a second arbirary
%	  input argument. All files datas*.m are the actual datasets.

if nargin < 1
   help getdata
   i = input('Which dataset? > ');
end
if isempty(i), return, end

if nargin < 2
   s = ['datas',num2str(i)];
   eval(['help ', s]);
end

x = eval(s);
