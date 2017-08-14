function [a, u] = egumbel(x)
%EGUMBEL  Estimate parameters of the Gumbel distribution
%
%         [a, u] = egumbel(x)
%
%	  The parameter  a  is scaling and  u  is position. The
%	  method of moments is used.

%       GPL Copyright (c) Anders Holtsberg, 1999

a = mean(x) - .57721566490153286; % Euler's gamma
u = std(x) / 1.2825498301618641 % pi/sqrt(6)
