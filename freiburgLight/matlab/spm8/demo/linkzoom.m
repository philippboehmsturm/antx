function HA = linkzoom(A1,A2)
%LINKZOOM   Links the zoom or pan for 2-D axes.
%
%   SYNTAX:
%          linkzoom
%          linkzoom(AS)
%          linkzoom(AH,AS)
%     HA = linkzoom(...);
%
%   INPUT:
%     AS - String specifying the axes to be linked. Must be a combination
%          of 'x', 'y' and 'z' or 'off' to eliminate the link  (see note
%          below).
%          DEFAULT = 'xy' (both axes are linked)
%     AH - Handles of axes to be linked with/without handle of figures or
%          uipanels to search for them (ignores the colorbars).
%          DEFAULT: gcf (links all the axes from the current figure)
%
%   OUTPUT (all optional):
%     HA - Handles of the axes (see note below).
%
%   DESCRIPTION:
%     MATLAB's LINKAXES links the axes limits from several axes. This
%     function linkes the zoom/pan function of several axes independenly of
%     its limits. That is, it links the zoom/pan regions.
%
%     3 dimensional MATLABs ZOOM changes the camera view instead of axes
%     limits. For this reason, by now the program works only on
%     2-dimensional plots.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * To reset (for example) the zoom limits in all axes use: 
%       >> for k = 1:length(HA), zoom(HA(k),'reset'), end
%     * By now, MATLABs ZOOM does not work for z-axis/3-dimensional
%       zooming, and neither this function.
%     * By now, the program actualizes all axes until the mouse is
%       released. Then, the panning is not instantaneous in all axes.
%
%   EXAMPLE:
%     % Data
%     figure(1)
%     rgb = imread('peppers.png');
%     r   = rgb(1: 2:end,1:2:end,:); r(:,:, 2:3)  = 0;
%     g   = rgb(1: 5:end,1:3:end,:); g(:,:,[1 3]) = 0;
%     b   = rgb(1:10:end,1:4:end,:); b(:,:, 1:2)  = 0;
%     % linkaxes:
%     ax    = zeros(3,1);
%     ax(1) = subplot(231); image(r)
%     ax(2) = subplot(232); image(g)
%     ax(3) = subplot(233); image(b)
%     title(ax(2),'LINKAXES (see the equal limits!):')
%     linkaxes(ax,'xy')
%     % linkzoom:
%     ax    = zeros(3,1);
%     ax(1) = subplot(234); image(r)
%     ax(2) = subplot(235); image(g)
%     ax(3) = subplot(236); image(b)
%     title(ax(2),'LINKZOOM (any difference?):')
%     linkzoom(ax)
%     zoom on
%
%   SEE ALSO: 
%     LINKAXES
%     and
%     TLABEL by Carlos Vargas
%     at http://www.mathworks.com/matlabcentral/fileexchange
%
%
%   ---
%   MFILE:   linkzoom.m
%   VERSION: 1.1 (Jun 19, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   REVISIONS:
%   1.0      Released. (Sep 11, 2008)
%   1.1      Fixed bug when axes already zoomed in. Changed example. (Jun
%            19, 2009) 

%   DISCLAIMER:
%   linkzoom.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2008-2009 Carlos Adrian Vargas Aguilera

% Parameters:
appname = 'linkzoomdata'; % Name of the application data.
HA      = [];             % Default output.

% MAIN:
if ~ ((nargin==2) && isstruct(A2)) 
 % LINKZOOM called from window command or m-file:
 
 % Checks inputs and sets defaults:
 if ~nargin
  AH = gcf;
  AS = 'xyz';
 end
 if nargin==1
  if ischar(A1)
   AS = A1;
   AH = gcf;
  else
   AH = A1;
   AS = 'xyz';
  end
 end
 if nargin==2
  AH = A1;
  AS = A2;
 end
 if nargin>2
  error('CVARGAS:linkzoom:tooManyInputs', ...
   'At most 2 inputs are allowed.')
 end  

 % Checks handles:
 ih = ishandle(AH);
 if ~all(ih)
  if ~sum(ih)
   error('CVARGAS:linkzoom:incorrectHandleInput', ...
     'Input handle AH must be from figures, uipanels or axes.')
  end
  warning('CVARGAS:linkzoom:incorrectHandleInput', ...
     'Some input handles on AH were ignored.')
  AH = AH(ih);
 end
 % Searches for axes handles in figures and uipanels:
 HA = [];
 for k = 1:length(AH)
  switch get(AH(k),'type')
   case {'figure','uipanel'}
    ha = findobj(AH(k),'-depth',1,'Type','axes','-not','Tag','Colorbar',...
     '-not','Tag','legend');
   case 'axes'
    ha = AH(k);
   otherwise
    error('CVARGAS:linkzoom:incorrectHandleInput', ...
     'Input handle(s) must be from figures, uipanels or axes.')
  end
  HA = [HA; ha(:)];
 end
 
 % Number of axes:
 na = length(HA);
 
 % Checks strings:
 as = lower(AS);
 switch as
  case {'x','xy','xz','xyz','xzy',...
        'y','yx','yz','yxz','yzx',...
        'z','zx','zy','zxy','zyx'}
   % continue
  case 'off'  % cleares linking:
   for k = 1:na
    if isappdata(HA(k),appname)
     data = getappdata(HA(k),appname);
     rmappdata(HA(k),appname)
     if isstruct(data) || isfield(data,'ah')
      ind          = (data.ah==HA(k)) | ~ishandle(data.ah);
      data.ah(ind) = [];
      for l = 1:length(data.ah)
       setappdata(data.ah(l),appname,data)
      end
     end
    end
    hz = zoom(HA(k));  
    hp = pan(ancestor(HA(k),{'figure','uipanel'},'toplevel'));
    set(hz,'ActionPostCallback',[]) 
    set(hp,'ActionPostCallback',[])
   end
   if ~nargout, clear HA, end
   return
  otherwise
    error('CVARGAS:linkzoom:incorrectStringInput', ...
    ['String axes input AS must be a combination of ''x'', ''y'' and '...
     '''z''; or ''off''.'])
 end

 % Removes axes from previous links:
 for k = 1:na
  if isappdata(HA(k),appname)
   data = getappdata(HA(k),appname);
   rmappdata(HA(k),appname)
   if isstruct(data) || isfield(data,'ah')
    ind          = (data.ah==HA(k)) | ~ishandle(data.ah);
    data.ah(ind) = [];
    for l = 1:length(data.ah)
     setappdata(data.ah(l),appname,data)
    end
   end
  end
 end 

 % Sets and saves application data:
 data     = [];
 data.ah  = HA(:);
 data.as  = as;
 data.ap  = false;
 for k = 1:na 
  % Resets limits zoom for double clicks in any axes undoes zooming.
  if ~isappdata(data.ah(k),'zoom_zoomOrigAxesLimits')% Fixed BUG (Jun 2009)
   zoom(data.ah(k),'reset')
  else
   zoom(data.ah(k),'out')
  end
 end
 for k = 1:na
  setappdata(HA(k),appname,data);
  hz = zoom(HA(k));
  hp = pan(ancestor(HA(k),{'figure','uipanel'},'toplevel'));
  set(hz,'ActionPostCallback',@linkzoom) 
  set(hp,'ActionPostCallback',@linkzoom)
  set(hz,'ActionPreCallback' ,@linkzoom) 
  set(hp,'ActionPreCallback' ,@linkzoom)
 end

else
 % LINKZOOM called from ZOOM or PAN function:
 
 try
  if ~isfield(A2,'Axes') || ~isscalar(A2.Axes)
   if ~nargout, clear HA, end
   return
  end
 
  % Gets application data:
  ahc  = A2.Axes;
  data = getappdata(ahc,appname);
  if ~isstruct(data) && ~isfield(data,'ah')
   if ~nargout, clear HA, end
   return
  end
  
  % Ignores deleted axes:
  data.ah(~ishandle(data.ah)) = [];
  
  % Number of axes:
  na = length(data.ah);
  
  % Finds out if it is a pre or poscallback or double click:
  doubleclick = strcmp(get(gcf,'SelectionType'),'open');
  if ~data.ap && ~doubleclick
   % Precallback:
   data.ap = true;
   for k = 1:na
    setappdata(data.ah(k),appname,data);
   end
   if ~nargout, clear HA, end
   return
  else
   % Postcallback:
   data.ap = false;
  end

  % Probably here goes a DRAWNOW but it seems to work without it and
  % besides, I keep getting an error with figure WindowButtonDownFcn.
  
  % Gets axes limits:
  iothers = (data.ah~=ahc);
  range   = 1:na;
  limpre  = [zeros(na,5) ones(na,1)]; 
  for k = range
   limpre(k,:) = [getappdata(data.ah(k),'zoom_zoomOrigAxesLimits') ...
                  get(data.ah(k),'ZLim')];
  end
  limfix = limpre(~iothers,:);
  
  % Zooms the X-axis:
  if ismember('x',data.as)
   limnew  = get(ahc,'XLim');
   if strcmp(get(ahc,'XScale'),'log');
    limnew = real(log10(limnew));
   end
   for k = range(iothers)
    limfit = interp1(limfix(1:2),limpre(k,1:2),limnew,'linear','extrap');
    if strcmp(get(data.ah(k),'XScale'),'log');
     limfit = 10.^limfit;
    end
    set(data.ah(k),'XLim',limfit)
   end
  end
  
  % Zooms the Y-axis:
  if ismember('y',data.as)
   limnew  = get(ahc,'YLim');
   if strcmp(get(ahc,'YScale'),'log');
    limnew = real(log10(limnew));
   end
   for k = range(iothers)
    limfit = interp1(limfix(3:4),limpre(k,3:4),limnew,'linear','extrap');
    if strcmp(get(data.ah(k),'YScale'),'log');
     limfit = 10.^limfit;
    end
    set(data.ah(k),'YLim',limfit)
   end
  end
  
  % Zooms the Z-axis:
  if ismember('z',data.as)
   limnew  = get(ahc,'ZLim');
   if strcmp(get(ahc,'ZScale'),'log');
    limnew = real(log10(limnew));
   end
   for k = range(iothers)
    limfit = interp1(limfix(5:6),limpre(k,5:6),limnew,'linear','extrap');
    if strcmp(get(data.ah(k),'ZScale'),'log');
     limfit = 10.^limfit;
    end
    set(data.ah(k),'ZLim',limfit)
   end
  end
  
  % Updates data:
  for k = range
   setappdata(data.ah(k),appname,data);
  end

 catch
  % Do not sets an error only displays it:
   disp(lasterr)
 end
end

% Outputs?:
if ~nargout, clear HA, end


% [EOF]   linkzoom.m