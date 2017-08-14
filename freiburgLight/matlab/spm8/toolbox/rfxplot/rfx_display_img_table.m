function rfx_display_img_table(dlist,dnum,opts,xyzstr)
%
% display a list of image descriptions with a count
% for interactive image selection
% -------------------------------------------------------------------------
% $Id: rfx_display_img_table.m 6 2009-04-07 14:20:52Z vglauche $

global defs

try
  FS = spm('FontSizes');
  PF = spm_platform('fonts');
  
  Finter = spm_figure('GetWin','Interactive');
  Fgraph = spm_figure('GetWin','Graphics');
  
  % clear bottom half of Graphics Window and set up fonts
  spm_results_ui('Clear',Fgraph);
  figure(Fgraph)
  
  ht = 0.4;
  bot= 0.05;
  
  f = 1;
  while f <= length(dlist)
    
    % --- CREATE AXES ---------------------------------------------------
    hAx   = axes('Position',[0.025 bot 0.9 ht],...
      'DefaultTextFontSize',FS(8),...
      'DefaultTextInterpreter','none',...
      'DefaultTextVerticalAlignment','Baseline',...
      'Units','points',...
      'Visible','off');
    
    AxPos = get(hAx,'Position'); set(hAx,'YLim',[0,AxPos(4)]);
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
    dx3 = 0.15;
    tabentry = y;
    text(dx1,tabentry,'index','HorizontalAlignment','center');
    text(dx2,tabentry,'count','HorizontalAlignment','center');
    text(dx3,tabentry,'image description','HorizontalAlignment','left');
    y = y - dy/2;
    % line separating header from entries
    line('XData',[0 1],'YData',[y y],'LineWidth',1,'Color','r')
    y = y - dy;
    % --- END OF TABLE HEADER -------------------------------------------
    while f <= length(dlist)
      if strcmp(opts.prefix,'beta') && isempty(strfind(dlist{f},'bf(1)'))
        text(dx1,y,sprintf('%d',f),'HorizontalAlignment','right',...
          'color',[.7 .7 .7]);
        text(dx2+0.01,y,sprintf('%d',dnum(f)),'HorizontalAlignment','right',...
          'color',[.7 .7 .7]);
        text(dx3,y,sprintf('%s',dlist{f}),'HorizontalAlignment','left',...
          'color',[.7 .7 .7]);
      else
        text(dx1,y,sprintf('%d',f),'HorizontalAlignment','right');
        text(dx2+0.01,y,sprintf('%d',dnum(f)),'HorizontalAlignment','right');
        text(dx3,y,sprintf('%s',dlist{f}),'HorizontalAlignment','left');
      end
      y = y - dy;
      f = f + 1;
      if y < dy
        break
      end
    end
    % --- second column (only if necessary) -----------------------------
    if f < length(dlist)
      dx4	= 0.5;
      dx5	= 0.55;
      dx6	= 0.6;
      y = tabentry;
      text(dx4,tabentry,'index','HorizontalAlignment','center');
      text(dx5+0.01,tabentry,'count','HorizontalAlignment','center');
      text(dx6,tabentry,'image description','HorizontalAlignment','left');
      y = y - dy/2;
      % --- line separating header from entries -----------------------
      line('XData',[0 1],'YData',[y y],'LineWidth',1,'Color','r')
      y = y - dy;
      while f <= length(dlist)
        if strcmp(opts.prefix,'beta') && isempty(strfind(dlist{f},'bf(1)'))
          text(dx4,y,sprintf('%d',f),'HorizontalAlignment','right',...
            'color',[.7 .7 .7]);
          text(dx5+0.01,y,sprintf('%d',dnum(f)),'HorizontalAlignment','right',...
            'color',[.7 .7 .7]);
          text(dx6,y,sprintf('%s',dlist{f}),'HorizontalAlignment','left',...
            'color',[.7 .7 .7]);
        else
          text(dx4,y,sprintf('%d',f),'HorizontalAlignment','right');
          text(dx5+0.01,y,sprintf('%d',dnum(f)),'HorizontalAlignment','right');
          text(dx6,y,sprintf('%s',dlist{f}),'HorizontalAlignment','left');
        end
        y = y - dy;
        % --- break for pagination ----------------------------------
        f = f + 1;
        if y < dy
          break
        end
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