function t = cat2tbl(m1, m2)
%CAT2TBL  Take category data and produce a table of counts.
%
%         table = cat2tbl(m1, m2)
%
%         It works with one input argument too.
%
%         See also CONTINCY

if nargin < 2
   if size(m1,2) == 2
      m2 = m1(:,2);
      m1 = m1(:,1);
   else
      m2 = ones(size(m1));
   end
end

if size(m1,2) ~= 1 | size(m2,2) ~= 1
   error('Column vectors expected as arguments')
end

if any([m1; m2] ~= round([m1; m2]))
   error('Integers expected in input vectors');
end

if min(m1) == 0
   m1 = m1 + 1;
end
if min(m2) == 0
   m2 = m2 + 1;
end

% Here is a smart solution in Matlab 5:
% t = full(sparse(m1,m2,1));
% But we wat it to work in Octave too, 
% this solution assumes fortran indexing on:

t = zeros(max(m1), max(m2));
x = sort(m1 + (m2-1)*max(m1));
i = find([1; diff(x)>0]);
j = 1:length(x);
count = diff([j(i), length(x)+1]);
t(x(i)) = count;
