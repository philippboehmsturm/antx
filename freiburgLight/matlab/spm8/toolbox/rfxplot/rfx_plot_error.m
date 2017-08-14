function rfx_plot_error(G, sd, x, br, sm, col, err, ind, subno)
%
% adaptation of myplot_error for the rfxplot toolbox
%
% SYNTAX:
%----------------------------------------
% function plot_error(G, sd, x, br, sm, col)
%
% where
%
% G	    : if 1 x n = vector of means
%	      if m x n = matrix of n variables with m observations
% sd	: if G is vector of means sd = vector for errorbars
%	      NB. G and sd must have the same size
% x	    : if specified x is used as x - coordinate for plot
%	      x must be 1 x n
% br	: if br = 'dot' a dot is plotted for the mean,
%         if br = 'dotline' a dot os plotted for the mean and a connecing line
%         if br = 'bar' a bar is plotted
% sm	  : 0 = sd
%         1 = sem
%         2 = 90% ci
% col   : cell array of color specs
% err   : flag for color of error bar ('s','k')
%         s = same, k = black (default)
% ind   : flag for overlaying individual data (default = 0)
% -------------------------------------------------------------------------
% $Id: rfx_plot_error.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  if nargin < 9
    subno = [];
  end
  
  if nargin < 8
    ind = 0;
  end
  
  if nargin < 7
    err = 'k';
  end
  
  if nargin < 3
    x = 1:size(G,2);
  elseif isempty(x)
    x = 1:size(G,2);
  end;
  
  if nargin < 4
    br = 0;
  end
  
  if nargin < 5
    sm = 0;
  end;
  
  if size(G,1) > 1
    m = nanmean(G);
    if sm == 1
      s = nansem(G);
    elseif sm == 2
      s = nansem(G)*spm_invNcdf(0.95);
    elseif sm == 0
      s = nanstd(G);
    end
  else
    m = G;
    if nargin < 2 || isempty(sd)
      s = zeros(size(G));
    else
      s = sd;
    end
  end
  
  hold on;
  
  if strcmp(br,'bar')
    if nargin < 6
      H=bar(x,m);
      set(H,'FaceColor',[.9 .9 .9]);
    else
      for f = 1:size(G,2)
        H(f)=bar(x(f),m(f));
        set(H(f),'FaceColor',col{f});
        hold on;
      end
    end
    if sm >= 0
      for j = 1:size(G,2)
        if nargin < 7 || strcmp(err,'r')
          line([x(j) x(j)],([s(j) 0 - s(j)] + m(j)),'LineWidth',2,'Color','r')
        elseif strcmp(err,'k')
          line([x(j) x(j)],([s(j) 0 - s(j)] + m(j)),'LineWidth',2,'Color','k')
        elseif strcmp(err,'s')
          line([x(j) x(j)],([s(j) 0 - s(j)] + m(j)),'LineWidth',2,'Color',col{j})
        end
      end
    end
  elseif strcmp(br,'dot') || strcmp(br,'dotline')
    if sm >= 0
      for j = 1:size(G,2)
        if nargin < 7
          line([x(j) x(j)],([s(j) 0 - s(j)] + m(j)),'LineWidth',2,'Color','r')
        elseif strcmp(err,'k')
          line([x(j) x(j)],([s(j) 0 - s(j)] + m(j)),'LineWidth',2,'Color','k')
        elseif strcmp(err,'s')
          line([x(j) x(j)],([s(j) 0 - s(j)] + m(j)),'LineWidth',2,'Color',col{j})
        end
      end
    end
    if nargin < 6
      f = plot(x,m,'k.','MarkerSize',8);
      if strcmp(br,'dotline')
        f = plot(x,m,'k-','linewidth',2);
      end
    else
      for f = 1:size(G,2)
        H(f) = plot(x(f),m(f),'bo');
        hold on
        if ~isempty(col)
          set(H(f),'Color',col{f},'MarkerSize',6,'MarkerFaceColor',col{f},'MarkerEdgeColor',col{f});
        else
          set(H(f),'Color','k','MarkerSize',6,'MarkerFaceColor',col{f},'MarkerEdgeColor',col{f});
        end
      end
      if strcmp(br,'dotline')
        plot(x,m,'color',col{f},'linestyle','-','linewidth',2)
      end
    end
  end
  
  if ind
    for r = 1:size(G,2)
      for s = 1:size(G,1)
        if ~isempty(subno)
          if mod(s,2) % uneven + left
            plot(x(r)-0.07,G(s,r),'marker','.','color','k','Markersize',8);
            text(x(r)-0.10,G(s,r),num2str(subno(s)),'FontSize',8,...
              'HorizontalAlignment','r');
          else
            plot(x(r)+0.07,G(s,r),'marker','.','color','k','Markersize',8);
            text(x(r)+0.10,G(s,r),num2str(subno(s)),'FontSize',8,...
              'HorizontalAlignment','l');
          end
        else
          plot(x(r)+0.07,G(s,r),'marker','.','color','k','Markersize',8);
        end
      end
    end
  end
  
  %set(gca,'xlim',[x(1)-1 x(end)+1],'xtick',x)
catch me
  if defs.debug
    if ~defs.saverr
      e=1; while ~strcmp(me.stack(e).name(1:3),'rfx'); e=e+1; end
      fname = sprintf('%s_line%d.mat',me.stack(e).name,me.stack(e).line);
      save(fname);
      rfx_save_error(me,fname);
    end
  else
    rfx_error_message(me);
  end
end
return;
