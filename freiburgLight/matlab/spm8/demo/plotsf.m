function h = plotsf(varargin)
% Plot a set of stick functions
% H = PLOTSF(SF)
% Plots Sticks at each data point in SF, starting at baseline (0).
% H = PLOTSF(X,SF)
% Plots sticks at each data point in SF, starting at baseline (0). Sticks are
% placed at positions in X.
% SF can be a NDATA-x-NLINES array, while X should be NDATA-x-1.
% H = PLOTSF(X,SF,plot_options...) specifies additional plot
% options. PLOTSF passes all options to PLOT. Note that markers will be
% placed at both top and bottom end of the plotted sticks.
% H = PLOTSF(AX,...) plot into handle AX
%----------------------------------------------------------------------------
% (C) Volkmar Glauche 2009

% Argument checks
if ishandle(varargin{1})
    ax = varargin{1};
    plotargs = varargin(2:end);
else
    ax = axes;
    plotargs = varargin;
end
if (numel(plotargs) < 2 || ~isnumeric(plotargs{2}))
    sf = plotargs{1};
    x  = 1:size(sf,1);
    plotopts = plotargs(2:end);
else
    x  = plotargs{1};
    sf = plotargs{2};
    plotopts = plotargs(3:end);
end

if numel(x) ~= size(sf,1)
    error('Wrong sized input arguments');
end

% Assemble sticks - for each non-zero stick value insert a zero before and
% after and replicate its x coordinate
sf1 = cell(2,size(sf,2));
for k = 1:size(sf,2)
    sfind  = find(sf(:,k));
    sf1{1,k} = [x(1) kron(x(sfind), [1 1 1]) x(end)]';
    sf1{2,k} = zeros(3*numel(sfind)+2,1);
    sf1{2,k}(3:3:3*numel(sfind)) = sf(sfind,k);
end

% pass things to plot
h = plot(ax, sf1{:}, plotopts{:});