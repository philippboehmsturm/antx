function out = icc(data);
%%%%% ANOVA example, within subjects
%%%% and computation of intraclass coefficient
%%%% see http://www.uvm.edu/~dhowell/StatPages/More_Stuff/icc/icc.html
% data: nsub-by-nrep array of observations  

[ns nr] = size(data);

nob = ns*nr;

sub = sum(data,2); %make another column by summing over conditions

SStotal = sum(data(:) .* data(:)) - ( sum(data(:)) .* sum(data(:)))/nob;
SSbetsubs = sum(sub .* sub)/nr - ( sum(data(:)) .* sum(data(:)))/nob;
%SStreat = sum(t .* t)/8 - ( sum(c1) .* sum(c1))/16;

%SStotal = SSbetsubs + SSwinsubs;
%SSwinsubs = SStreat + SSerror;
SSwinsubs = SStotal - SSbetsubs;

MSEbetsubs = SSbetsubs/ns;
MSEwinsubs = SSwinsubs/ns;

out = (MSEbetsubs - MSEwinsubs) / (MSEbetsubs + (nr-1)*MSEwinsubs);

