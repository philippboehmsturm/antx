function rfx_display_subj_table(dirs,opts,xyzstr)
%
% display a table with subject directories for group specification and
% exclusion of subjects
% -------------------------------------------------------------------------
% $Id: rfx_display_subj_table.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  Fgraph = spm_figure('GetWin','Graphics');
  FS = spm('FontSizes'); % also need for plotting (not only for table)
  PF = spm_platform('fonts');
  
  % clear bottom half of Graphics Window and set up fonts
  spm_results_ui('Clear',Fgraph);
  figure(Fgraph)
  
  ht = 0.4;
  bot= 0.05;
  
  f = 1;
  while f <= length(dirs)
    
    % --- CREATE AXES ---------------------------------------------------
    hAx   = axes('Position',[0.025 bot 0.9 ht],...
      'DefaultTextFontSize',FS(8),...
      'DefaultTextInterpreter','none',...
      'DefaultTextVerticalAlignment','Baseline',...
      'Units','points',...
      'Visible','off');
    
    AxPos = get(hAx,'Position'); set(hAx,'YLim',[0,AxPos(4)])
    dy    = FS(9);
    y0    = floor(AxPos(4)) - dy;
    y	  = y0;
    
    % --- TABLE HEADER --------------------------------------------------
    % Table Title
    text(0,y,sprintf('Data Extraction from %s-images %s',...
      opts.prefix,xyzstr),...
      'FontSize',FS(11),'FontWeight','Bold');
    y = y - dy/2;
    % Table top line
    line([0 1],[y y],'LineWidth',3,'Color','r'),
    y = y - 9*dy/8;
    % bottom table boundary
    line('XData',[0 1],'YData',[0 0],'LineWidth',3,'Color','r')
    
    % construct table headers
    dx1 = 0.05;
    dx2 = 0.1;
    tabentry = y;
    text(dx1,tabentry,'index','HorizontalAlignment','center');
    text(dx2,tabentry,'subject directory','HorizontalAlignment','left');
    y = y - dy/2;
    % line separating header from entries
    line('XData',[0 1],'YData',[y y],'LineWidth',1,'Color','r')
    y = y - dy;
    % --- END OF TABLE HEADER -------------------------------------------
    while f <= length(dirs)
      text(dx1,y,sprintf('%d',f),'HorizontalAlignment','right');
      text(dx2+0.01,y,sprintf('%s',dirs{f}),'HorizontalAlignment','left');
      y = y - dy;
      f = f + 1;
      if y < dy
        break
      end
    end
    text(0.5,0.1,sprintf('Page %d',spm_figure('#page')),...
      'FontSize',FS(8),'FontAngle','italic')
    spm_figure('NewPage',[hAx;get(hAx,'Children')]);
  end
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