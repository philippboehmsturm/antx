function [b,count,ind] = rfx_unique_unsorted(a)
% 
% removes duplicate cells and counts occurrences
% works only for cell arrays of strings
%
% not very elegant, but it works ...
%
% ARGS:
% a -- cell array (of strings)
%
% OUTPUT
% b     -- cell array of unique elements of a (unsorted)
% count -- number of occurences of each cell in b in the original cell
%          array a
% ind   -- indices of each cell in b into the original cell array a
% -------------------------------------------------------------------------
% $Id: rfx_unique_unsorted.m 13 2010-07-15 08:38:20Z volkmar $


if ~iscell(a)
  a = cellstr(a);
end

[m,n] = size(a);

if n>1; a = a(:); end

orig = a;
numelA = numel(a);

e   = 1;
ind = zeros(1,numelA);

while ~isempty(a)
  b{e} = a{1};
  o = strmatch(b{e},orig,'exact');
  i = strmatch(b{e},a,'exact');
  count(e) = length(i);
  ind(o) = e;
  
  a(i) = [];
  e = e + 1;
end
return
