
% #yg uhelp: display a function's HELP or a CELL array in text window.
% ###  use [+/-]key to change fontsize
% #b   use [ctrl+c] to copy selection
% #b   use [b] to scroll to begin
% #b   use [e] to scroll to end
% #b   [left/right arrows] to decrease/increase fontsize
% ##  see also contextmenu
%
% #### =====================================================================================
% ####  UHELP ... FURTHER INFORMATION
% #### =====================================================================================
%
% uhelp additional infos
% uhelp(cell, 0/1, 'cursor' ,'end' )   ;%places cursor to the end
%
%% COLORCODE
% e2={'ee3e' ; 'blll ## HASH ' ;'blll ### HASH ### ddede' ;'blll #### HASH ddede';' ## ------------------------------' };
% uhelp(e2)
% e2={'ee3e' ; ' § [h] § [heute]  ; § [m] § morgen '};uhelp(e2)
% % uhelp({' #cm rote KORRELATION #k ccrrc #ky blob';' #c deddeede'});
% uhelp(e2)
%
%% ##wg _______EXAMPLES_______________________________________________
%% #bl              MOUSE-LISTBOX
%% #bx           MOUSE-LISTBOX
%% #ok        _MOUSE-LISTBOX_
%% #ko     _MOUSE-LISTBOX_
%% #wg  _MOUSE-LISTBOX_
%% #ka _MOUSE-LISTBOX_
%% #kd _MOUSE-LISTBOX_
%% #ra _MOUSE-LISTBOX_
%% #rd _MOUSE-LISTBOX_

% HREF-matlab-workspace
% disp(['BATCH: <a href="matlab: uhelp({'' #r RED'' ;'' #g green''},1,''cursor'',''end'')">' 'show history' '</a>'  ]);


%
% FEATURES:
% •HTML-style to display text (words in uppercase and the name of the
%    function within the text appear highlighted
% •use mouse wheel to scroll up/down the text
% •use mouse wheel + control button to change the fontsize
% •change fontstyle and backgroundcolor
% •set window to 'always on top' mode ([aot.m] required from matlab file exchange)
% •multiple window mode possible
% •save fontstyle/color/windowsize parameter within this function for the
%  next call
%
%SYNTAX:   uhelp(function) ;%one window mode
%          uhelp(cell)
%          uhelp(function,1) ;%multiple windows mode
%          uhelp(cell,1)
%
% DESCRIPTION:
% uhelp('regexprep');   %replace window mode (default)
% uhelp('regexprep',1) ;%multiple windows mode
% [mousewheel up/down]:             scroll text
% [control]+ [mousewheel up/down]:  decrease/increase fontsize
% [arrow left]/[arrow right]:       decrease/increase fontsize
%
% checkbox    :  to set window as 'always on top'
% contextmenu : [font]      -> choose font-size/weight/style from menu
%               [backgroundcolor]
%               [saveconfig]-> save following parameter in THIS matlab-function:
%                    - font-size/weight/style
%                    - used  'always on top' mode
%                    - figure position
%               [copy selection]-> copy selection to clipboard
%               [evaluate selection]-> ..
% help         : opens another textwindow (replace window mode) to depict help
%              [Help browser]: see documentation in the Help browser
%EXAMPLES:
% uhelp uhelp
% uhelp('fft')
%
%NOTE: the following file is required
%  FINDOBJ by Yair Altman -->
%  http://www.mathworks.com/matlabcentral/fileexchange/14317-findjobj-find-java-handles-of-matlab-graphic-objects
%
% optional: to set window to 'allways on top' download AOT -->
% http://www.mathworks.com/matlabcentral/fileexchange/20694-aot
% --------------------------------------------------
% paul koch,BNIC Berlin 2010
%____________________________ADDIT PARAS____________________
% pairwise add. PARAS
% currently: 'position'  [4 elements]
% uhelp({'ded';'fff'},1,'position',[0 0 .5 .3])
%
%___________________________new COLOR marks_____________________
% ' §b [left]    §k,    :  §  combined with matlab colorletter (y,m,k,b,g,r)
%
%% EXAMPLE
%    %% bka
%        hh={};
%        hh{end+1,1}=( ' #yk ***  IMAGE-SHORTCUTS  ***' );
%        hh{end+1,1}=(' §b [left]    §k    toggle imageFusion/image1');
%        hh{end+1,1}=(' §b [right]   §k    toggle image1/image2');
%        hh{end+1,1}=(' §b [up/down] §k    increase/decrease alpha-blending');
%        hh{end+1,1}=(' §b [c/v]     §k    change colormap (forward/backward)' );
%
%        hh{end+1,1}=(' §b [z]       §k    show/hide coordinates  ');
%        hh{end+1,1}=(' §b [t]       §k    show/hide labels  ');
%
%        uhelp(hh,1,'position',[ 0.7378    0.7633    0.2601    0.130])  ;
%        drawnow;



function uhelp(fun,varargin)


warning off;




if nargin>2
    %vnew=varargin{1};
    varag=varargin(2:end);
    
    vara=reshape(varag,[2 length(varag)/2])';
    paras=cell2struct(vara(:,2)',vara(:,1)',2);
    
else
    paras=struct();
end



posfig=[];
if nargin==0
    uhelp({'..use contextmenu to open Figuretable existing '},1)  ;
    return;
end

% if length(varargin)==0 %dirty: 2 inputs means 'multiple windows mode'
%     try; posfig=get(335,'position'); end
%     try; close(335);end %otherwise replace an existing window
% end
if nargin>0 %dirty: 2 inputs means 'multiple windows mode'
    %     try
    if isempty(varargin) || varargin{1}==0
        try; posfig=get(335,'position'); end
        %         try; close(335);end %otherwise replace an existing window
    end
    %     end
end

if ~iscell(fun) %call help of a function
    e=help(fun);
    %     ix=strfind(e,char(10));%replace Carriage return
    %     ix=[1 ix length(e)];
    %     for i=1:length(ix)-1 %make a cell
    %         e2(i,1)={e(ix(i):ix(i+1)-1)};
    %     end
    e2=strsplit2(e,char(10))';
else %CELL as input
    e2=fun;
end

%%%••••••••••••••••••••••••••••••••••••••••••••••
x.aot=0;
x.evntModifier=0;
%%%••••••••••••••••••••••••••••••••••••••••••••••


e0=e2;%backup


% #############################################################
% vorl={};
% vorl(end+1,:)={'^^'    ' <html><b><font  color="red"> '     ' </b></font> '  }
% vorl(end+1,:)={'^^^'   ' <html><b><font  color="green"> '   ' </b></font> '  };

% vorl={};
% vorl(end+1,:)={'^^'    ' <b><font  color="red"> '     ' </b></font> '  }
% vorl(end+1,:)={'^^^'   ' <b><font  color="green"> '   ' </b></font> '  };


%   drawnow;


x.fun=fun;
x.e0=e0;

e2=htmlcolorize(e2)  ;




% if length(varargin)==0
if isfield(paras,'position')
    posfig=[paras.position];
else
    posfig= [ 0.3049    0.4189    0.3889    0.4667];
end

figexist=0;
if isempty(varargin) ||  varargin{1}==0
    
    if ~isempty(findobj(0,'Number', 335))
        figexist=1;
        hfig=findobj(0,'Number', 335);
    else
        figure(335);
        hfig=findobj(0,'Number', 335);
        set(hfig,'visible','off','units','normalized','position',posfig);
    end
else
    %hfig=figure;
    hfig=figure('visible','off','units','normalized','position',posfig);
    
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if figexist==0
    pause(.001)
end

x=setup(x);

if figexist==0
    pause(.001)
end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if figexist==0
    set(hfig,'tag','uhelp','color',[1 1 1]);
    set(hfig,'units','normalized','menubar','none',...
        'WindowScrollWheelFcn',{@gwheel,1});
    ui=uicontrol('Style','listbox','units','normalized', 'Position',[0 0,1 1],...
        'String', ...
        e2, 'tag','txt','max',2,...
        'backgroundcolor',[1 1 1],'fontsize',8);%,'fontname','Courier New');
    if ~isempty(posfig)
        set(hfig,'position',posfig);
    end
    set(hfig,'WindowKeyPressFcn',@keyx)
else
    hlb=findobj(hfig,'tag','txt');
    set(hlb,'value',1)
    set(hlb,'string',e2);
end

if figexist==0
    try
        set(ui,'FontName',  x.FontName,'FontAngle',x.FontAngle,...
            'FontWeight',x.FontWeight,'fontsize',x.fontsize);
        set(ui,'backgroundcolor','w');
        
    end
    if isfield(paras,'position');
        set(hfig,'position',paras.position);
    else
        try
            if isempty(varargin) || varargin{1}==0
                set(hfig,'position',posfig); % previous pos
            end
        catch
            set(hfig,'position',x.fgpos);
        end
    end
    drawnow;
    try;     aot(x.aot);aot(x.aot);  end %AOT
    set(hfig,'toolbar','none');
end



if figexist==0
    
    %----------------------------------
    %           AOT-button
    %----------------------------------
    b1 = uicontrol('Style', 'checkbox', 'String', '','fontsize',8,...%'pushbutton'
        'units','normalized','TooltipString','toggle: alway on top',...
        'Position', [0 0 .03 .03], 'Callback', @ontop,'backgroundcolor',[1 1 1]);
    if x.aot==1; set(b1,'value',1); else; set(b1,'value',0);end
end

if figexist==0
    
    %----------------------------------
    %           HELP
    %----------------------------------
    b2 = uicontrol('Style', 'pushbutton', 'String', '','fontsize',8,...%'pushbutton'
        'units','normalized','TooltipString','help; see also CONTEXTMENU',...
        'Position', [0.02 0 .03 .03], 'Callback', {@gcontext, 6},'backgroundcolor',[1 1 1]);
    a2=[0 1 0.0313725490196078 0.32156862745098 1 1 1 1 1 1 1 1 1 1 0.83921568627451 0.741176470588235 0.968627450980392 0.905882352941176 0.741176470588235 0.968627450980392 0.776470588235294 0.258823529411765 0.776470588235294 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0470588235294118 0.333333333333333 1 1 1 1 1 1 1 1 1 1 0.811764705882353 0.729411764705882 0.952941176470588 0.890196078431373 0.713725490196078 0.937254901960784 0.745098039215686 0.235294117647059 0.764705882352941 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0627450980392157 0.290196078431373 0 0.290196078431373 0.32156862745098 0.352941176470588 0.517647058823529 0.611764705882353 0.67843137254902 0.83921568627451 0.870588235294118 0.968627450980392 0 0.0941176470588235 0.223529411764706 0.258823529411765 0.0941176470588235 0.290196078431373 0.290196078431373 0.0627450980392157 0.741176470588235 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0]';
    aa2=[25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 21 20 16 19 17 21 21 25 25 25 25 25;25 25 25 21 15 11 13 8 5 14 14 21 21 24 24 25;25 25 25 21 18 12 1 10 5 5 4 4 21 1 1 2;21 21 25 21 18 12 1 4 7 21 21 4 21 22 22 2;25 25 25 21 18 9 7 5 5 5 4 4 21 3 3 2;25 25 25 21 18 6 4 4 4 18 18 21 21 2 23 25;25 25 25 25 21 18 18 18 18 21 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25]';
    set(b2,'cdata',   ind2rgb(uint8(aa2),a2),'visible','on');
    %----------------------------------
    %         context
    %----------------------------------
    cmenu = uicontextmenu;
    set(ui,'UIContextMenu', cmenu);
    item4 = uimenu(cmenu, 'Label','copy  selection', 'Callback', {@gcontext, 4});%copy
    item8 = uimenu(cmenu, 'Label','save table as Figure (reloadable)', 'Callback', {@gcontext, 8});%save
    
    item9 = uimenu(cmenu, 'Label','load table (Figure)', 'Callback', {@gcontext, 9});%open
    
    
    item10 = uimenu(cmenu, 'Label','save as textfile', 'Callback', {@gcontext, 10});%save
    set(item10,'Separator','on');
    item11 = uimenu(cmenu, 'Label','load textfile', 'Callback', {@gcontext, 11});%save
    
    
    item1 = uimenu(cmenu, 'Label','font',     'Callback', {@gcontext, 1});
    set(item1,'Separator','on');
    item2 = uimenu(cmenu, 'Label','backgroundcolor', 'Callback', {@gcontext, 2});
    item3 = uimenu(cmenu, 'Label','saveConfig', 'Callback', {@gcontext, 3});
    set(item3,'Separator','on');
    
    item5 = uimenu(cmenu, 'Label','<html><font color=red>evaluate selection', 'Callback', {@gcontext, 5});% evaluate
    item6 = uimenu(cmenu, 'Label','help',   'Callback', {@gcontext, 6});%help
    item7 = uimenu(cmenu, 'Label','see in Matlabs Help browser',   'Callback', {@gcontext,7});%help
    %----------------------------------
    %           keys
    %----------------------------------
    set(hfig,'KeyPressFcn',@fontsize); %figure and..
    set(ui,'KeyPressFcn',@fontsize); %listbox is keysensitive
    %----------------------------------
    %           scroll:
    %here use findjobj
    %----------------------------------
end


%  x.scroll=findjobj(hfig,'Class', 'UIScrollPane$1');%scroll
set(hfig,'userdata',x);

% set(findobj(gcf,'style','listbox'),'FontName','courier');

% 'a'
%% from mfile-saved config
if figexist==0
    set(findobj(hfig,'style','listbox'),'FontName',x.FontName, 'fontsize',single(x.fontsize),'FontWeight','normal');%x.FontWeight
    
end

lb1=findobj(hfig,'style','listbox');
if isfield(paras,'fontsize');
    set(lb1, 'fontsize',paras.fontsize) ;
end

if isfield(paras,'cursor');
    if strcmp(paras.cursor,'end')
        set(lb1, 'value',size(get(lb1,'string'),1)  );
    end
    %   else
end

% 'ssss'

set(hfig,'visible','on');




%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% •••••••••••••••••••••••••••••  SUBFUNS      •••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%%••••••••••••••••••••••••••••••••••••••••••••••
% embedded functions
%%%••••••••••••••••••••••••••••••••••••••••••••••

function keyx(h,e)

if strcmp(e.Character,'j')
    try
        %         us=get(get(h,'parent'),'userdata');
        us=get(h,'userdata');
        sc=get(0,'ScreenSize');
        sc=sc(3:4);
        p=round (get(0,'PointerLocation'));
        p(2)=sc(2)-p(2);
        %     p
        us.jFrame.setLocation(p(1)*2,p(2)*2);
    end
elseif strcmp(e.Character,'s')
    try
        %         us=get(get(h,'parent'),'userdata');
        us=get(h,'userdata');
        sc=get(0,'ScreenSize');
        sc=sc(3:4);
        p=round (get(0,'PointerLocation'));
        p(2)=sc(2)-p(2);
        c=[us.jFrame.getX us.jFrame.getY];
        d(1)= 2*p(1)-c(1);
        d(2)= 2*p(2)-c(2);
        us.jFrame.setSize(d(1),   d(2));
        
        %         us.jFrame.getSize
        %         us.jFrame.getWidth
        %         us.jFrame.getWidth
        %         jFrame.setSize=( )
    end
    

elseif strcmp(e.Character,'+')
    tx= findobj(gcf,'tag','txt');
    set(tx,'fontsize', get(tx,'fontsize')+1)  ;
elseif strcmp(e.Character,'-')
    tx= findobj(gcf,'tag','txt');
    if get(tx,'fontsize')-1 >1
        set(tx,'fontsize', get(tx,'fontsize')-1)  ;
    end
elseif strcmp(e.Key,'e')  % go to END
    lb1=findobj(h,'tag','txt');
    set(lb1, 'value',size(get(lb1,'string'),1)  );
elseif strcmp(e.Key,'b')  %go to begin
    lb1=findobj(h,'tag','txt');
    set(lb1, 'value',1 );
end

if strcmp(e.Modifier,'control') %copy selection
    if strcmp(e.Key,'c')
        gcontext([], [], 4);
    end
end

%----------------------------------
%         AOT/ontop
% here use aot
%----------------------------------
function ontop(src,evnt)
warning off;

try
    
    jframe=get(gcf,'javaframe');
    try
        warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    catch
        warning off;
    end
    
    try
        jClient = jframe.fFigureClient;  % This works up to R2011a
    catch
        try
            jClient = jframe.fHG1Client;  % This works from R2008b-R2014a
        catch
            jClient = jframe.fHG2Client;  % This works from R2014b and up
        end
    end
    jWindow = jClient.getWindow;
    
    if jWindow.isAlwaysOnTop==1
        jWindow.setAlwaysOnTop(0);
    else
        jWindow.setAlwaysOnTop(1);
    end
    
catch
    
    if exist('aot.m')==0;%if aot.m is not in the matlabpath
        disp('[figure on top] is enabled, download and add [aot.m] to the matlabpath');
        disp('http://www.mathworks.com/matlabcentral/fileexchange/20694-aot');
    else
        x=get(gcf,'userdata');
        if x.aot==0
            try; x.aot=1; aot(1);end;  set(gcf,'menubar','none','toolbar','none');
        else
            try; x.aot=0; aot(0);end;  set(gcf,'menubar','none','toolbar','none');
            
        end
        set(gcf,'userdata',x);
    end
    
end

%----------------------------------
%           arrow keys
%----------------------------------
function fontsize(src,evnt)
x=get(gcf,'userdata');
if strcmp(evnt.Modifier,'control'); %[control]+mousewheel
    x.evntModifier=1; %if [control]-key is pressed..
    %code this for mousewheel-specifications
else
    x.evntModifier=0;
    tx= findobj(gcf,'tag','txt');
    if size(tx,1)>1
        tx=tx(1);
    end
    if strcmp(evnt.Key,'leftarrow')
        if get(tx,'fontsize')-1>1
            set(tx,'fontsize', get(tx,'fontsize')-1)  ;
        end
    elseif strcmp(evnt.Key, 'rightarrow')
        set(tx,'fontsize', get(tx,'fontsize')+1)  ;
    end
end
set(gcf,'userdata',x);

%----------------------------------
%           mousewheel
%----------------------------------
function gwheel(obj, event, mode)

try
    x=get(gcf,'userdata');
    if  x.evntModifier==0 %[scroll text]
        x=get(gcf,'userdata'); scroll=x.scroll;
        try
            set(scroll,'value',   get(scroll,'value')  +event.VerticalScrollCount*25);
        catch %after savibng Image
            x.scroll=findjobj(gcf,'Class', 'UIScrollPane$1');%scroll
            set(gcf,'userdata',x);
        end
        
    else %define fontsize with mouse wheel
        tx= findobj(gcf,'tag','txt');
        
        fs= get(tx,'fontsize');
        fs2=fs+event.VerticalScrollCount;
        if fs2>1
            set(tx,'fontsize', fs2)  ;
        end
        x.evntModifier=0;
        set(gcf,'userdata',x);
    end
end



%----------------------------------
%           contextmenu
%----------------------------------
function gcontext(obj, event, mode)
x= get(gcf,'userdata');
if mode==1
    tx= findobj(gcf,'tag','txt');
    r.FontName=get(tx,'FontName');
    r.FontWeight=get(tx,'FontWeight');
    r.FontAngle=get(tx,'FontAngle');
    r.FontSize=get(tx,'fontsize');
    r.FontUnits= 'points' ;
    
    try;aot(0);end
    set(gcf,'menubar','none','toolbar','none');
    ix= uisetfont(r );
    set(tx,'fontsize',ix.FontSize);
    
    
    try
        str=get(tx,'string');
        fstag=find(cellfun('isempty',regexpi(str,'<font size='))==0);
        fstag=fstag(1);
        fstag=str{fstag};
        fstag=fstag(min(findstr(fstag,'font size')):min(findstr(fstag,'font size'))+14);
        
        oldFS=str2num(char(regexprep({fstag},'[A-z\W]','')));
        newFS=ix.FontSize;
        str=regexprep(str,['<font size="'  num2str(oldFS) '">'],['<font size="'  num2str(newFS) '">']);%char(dd(1:6));
        set(tx,'string',str);
    end
    
    try;    set(tx,ix);drawnow; end
elseif mode==2
    try
        p=colorui;
    catch
        p=uisetcolor
    end
    try
        tx= findobj(gcf,'tag','txt');
    end
    try;     set(tx,'backgroundcolor',p); end
elseif mode==3
    tx= findobj(gcf,'tag','txt');
    s.colbg=get(tx,'backgroundcolor');
    s.fontsize=get(tx,'fontsize');
    s.FontName=get(tx,'FontName');
    s.FontAngle=get(tx,'FontAngle');
    s.FontWeight=get(tx,'FontWeight');
    s.fgpos=get(gcf,'position');
    x=get(gcf,'userdata') ;
    s.aot=x.aot;
    
    fi=which('uhelp.m');
    fil={};
    fid=fopen(fi);    j=1;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        fil{j,1}=tline;     j=j+1;
    end
    fclose(fid);
    
    for i=1:length(fil)
        if ~isempty( findstr(fil{i},'%***setup-start'))
            w1=i;
        end
        if ~isempty( findstr(fil{i},'%***setup-end'))
            w2=i;
        end
    end
    
    fil1=fil(1:w1);
    fil2=fil(w2:end);
    v=fieldnames(s);
    filset={};
    for i=1:length(v)
        dum0=['dum1=s.' v{i} ';']; eval(dum0);
        if ischar( dum1)
            filset{i,1}=['x.' v{i} '='''   num2str(dum1)  ''';' ];
        else
            filset{i,1}=['x.' v{i} '=['   num2str(dum1)  '];' ];
        end
    end
    %      char(filset)
    filnew=[fil1; filset; fil2];
    
    fid = fopen([   fi ],'w','n');%SAVE
    for i=1:size(filnew,1)
        dumh=char(  (filnew(i,:)) );
        fprintf(fid,'%s\n',dumh);
    end
elseif mode==4 | mode==5%[4] copy selection or [5]evaluate selection
    tx= findobj(gcf,'tag','txt');
    x=get(gcf,'userdata');%get(tx,'string');
    li=x.e0;
    va=get(tx,'value');
    
    e0='';
    for i=1:length(va)
        %e0=[e0 li{va(i)}];
        e0=[e0 sprintf('%s\n' ,li{va(i)})];
    end
    
    if mode==4
        warning off;
        clipboard('copy',e0)
        warning on;
    elseif mode==5
        try;
            %             eval(e0);
            evalin('base',e0);
        end
    end
    
elseif mode==6
    po=get(gcf,'position');
    %     uhelp('uhelp',1); drawnow;
    
    hlp=help(mfilename);
    hlp=strsplit2(hlp,char(10))';
    uhelp(hlp,1);
    set(gcf,'tag','uhelphelp')
    
    
    %
    %     ch=findobj(0,'tag','uhelp');
    %     x=get(gcf,'userdata');
    %     if x.aot==1
    %         for i=length(ch):-1:1
    %             figure(ch(i)); aot(0) ;
    %             if x.aot==1
    %                 try; aot(1); end
    %                 set(ch(i),'menubar','none','toolbar','none');
    %             end
    %         end
    %     end
    po([1 2])=po([1 2])-.1;
    set(gcf,'position',po,'name','HELP of HELP');
elseif mode==7  %BROWSER
    
    try;
        doc(x.fun);
    end
elseif mode==8 %save as figure
    %     item8 = uimenu(cmenu, 'Label','save Figure', 'Callback', {@gcontext, 8});%save
    
    [fi pa]=uiputfile('*.fig', 'save as Figure');
    try;
        saveas(gcf,fullfile(pa,fi),'fig') ;
        disp([ 'table saved as: ' fi ] );
    end
elseif mode==9 %Load Figure
    %     item9 = uimenu(cmenu, 'Label','load table (Figure)', 'Callback', {@gcontext, 9});%open
    [fi pa]=uigetfile('*.fig', 'load figuretable');
    open(fullfile(pa,fi));
    
elseif mode==10
    %     item10 = uimenu(cmenu, 'Label','save as textfile', 'Callback', {@gcontext, 10});%save
    try
        [fi pa]= uiputfile('*.txt', 'save as textfile');
        pathname=[pa fi];
        dataX=(x.e0);
        clas=class(dataX);
        fid = fopen(fullfile(pa,fi),'w','n');
        if  ( strcmp(clas,'cell')==1 | strcmp(clas,'char')==1)
            for i=1:size(dataX,1)
                dumh=char(  (dataX(i,:)) );
                fprintf(fid,'%s\n',dumh);
            end
        end
        fclose(fid);
    catch
        try;  fclose(fid);end
    end
    
elseif mode==11
    %     item11 = uimenu(cmenu, 'Label','load textfile', 'Callback', {@gcontext, 11});%save
    
    [fi pa]= uigetfile('*.txt', 'load textfile');
    
    
    try
        fid = fopen(fullfile(pa,fi));
        d=[];
        j=1;
        while 1
            tline=fgetl(fid);
            if ~ischar(tline);break;end
            d{j,1}=tline;
            j=j+1;
        end
        fclose(fid);
        
        uhelp(d,1);
        return
    catch
        try;    fclose(fid);;end
    end
    
    
    
end

function Tokens = strsplit2(String, Delim)
Tokens = [];
while (size(String,2) > 0)
    if isempty(Delim)
        [Tok, String] = strtok(String);
    else
        [Tok, String] = strtok(String, Delim);
    end
    Tokens{end+1} = Tok;
end


function e2=htmlcolorize(e2)

col1={...
    'b' 'blue'
    'g' 'green'
    'r' 'red'
    'c' 'aqua'
    'm' 'FF00FF'
    'y' 'FFd700'
    'k' 'black'
    'w' 'white'
    'x' 'A52a2a'
    'l'  '00ff00' %lime
    'o'  'FFA500'
    'a'  '#C0C0C0 ' %antrazit (GRAU)
    'd'  '#808080'  %dark (GRAUdunkel)
    };

%
% FS=['<font size="'  num2str(x.fontsize)-2 '">'];

% vorl={};
% vorl(end+1,:)={'§'     ['<b>'   '<font  color="blue">' ]  '</b></font>'  };
% vorl(end+1,:)={'$'     ['<b>' FS '<font  color="red">']   ' </b></font> '  };
% vorl(end+1,:)={'##'     [' <b>' FS '<font  color="green"> ']   ' </b></font> '  };
% vorl(end+1,:)={'###'    [' <b>' FS '<font  color="blue"> ' ]    ' </b></font> '  };
% vorl(end+1,:)={'####'   [' <b>' FS '<font  color="red"> '  ]   ' </b></font> '  };
% vorl(end+1,:)={'#####'  [' <b>' FS '<font  color="green"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§r'  [' <b>' FS '<font  color="red"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§b'  [' <b>' FS '<font  color="blue"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§g'  [' <b>' FS '<font  color="green"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§k'  [' <b>' FS '<font  color="black"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§m'  [' <b>' FS '<font  color="magenta"> ']   ' </b></font> '  };
% vorl(end+1,:)={'§y'  [' <b>' FS '<font  color="yellow"> ']   ' </b></font> '  };
% vorl(end+1,:)={'#\D'      ['<b>' FS '<font color="white"  bgcolor="A52a2a" size="+1"> ']   ' </b></font></bgcolor></color> '  };
% vorl(end+1,:)={'#\D\D'     [' <b>' FS '<font color="white"  bgcolor="A52a2a" size="+1"> ']   ' </b></font></bgcolor></color> '  };

vorl={};
vorl(end+1,:)={'§'     ['<b>'   '<font  color="blue">' ]  '</b></font>'  };
vorl(end+1,:)={'$'     ['<b>'   '<font  color="red">']   ' </b></font> '  };
vorl(end+1,:)={'##'     [' <b>'   '<font  color="green"> ']   ' </b></font> '  };
vorl(end+1,:)={'###'    [' <b>'   '<font  color="blue"> ' ]    ' </b></font> '  };
vorl(end+1,:)={'####'   [' <b>'   '<font  color="red"> '  ]   ' </b></font> '  };
vorl(end+1,:)={'#####'  [' <b>'   '<font  color="green"> ']   ' </b></font> '  };
vorl(end+1,:)={'§r'  [' <b>'   '<font  color="red"> ']   ' </b></font> '  };
vorl(end+1,:)={'§b'  [' <b>'   '<font  color="blue"> ']   ' </b></font> '  };
vorl(end+1,:)={'§g'  [' <b>'   '<font  color="green"> ']   ' </b></font> '  };
vorl(end+1,:)={'§k'  [' <b>'   '<font  color="black"> ']   ' </b></font> '  };
vorl(end+1,:)={'§m'  [' <b>'   '<font  color="magenta"> ']   ' </b></font> '  };
vorl(end+1,:)={'§y'  [' <b>'   '<font  color="yellow"> ']   ' </b></font> '  };

vorl(end+1,:)={'#\D'      ['<b>'   '<font color="white"  bgcolor="A52a2a"  > ']   ' </b></font></bgcolor></color> '  };
vorl(end+1,:)={'#\D\D'     [' <b>'   '<font color="white"  bgcolor="A52a2a"  > ']   ' </b></font></bgcolor></color> '  };
vorl(end+1,:)={'%'      ['<b> <font  color="green">']  ''   }; %remove comment %%
% vorl(end+1,:)={'%'      ['<font  color="green">']  ''   }; %remove comment %%


% yellow aqua=cyan color="DC143C"

%% html for tag '#yg'-type
% vorl2=[ ' </b>' FS '<font color="white">'];
% vorl3=[ ' </b>' FS '<font bgcolor="white">'];

vorl2=[ ' <b>'   '<font color="white">'];
vorl3=[ ' <b>'   '<font bgcolor="white">'];

% regexp( ' www www wwww ww wwwww' ,'\<www\>')
% regexp( ' www www wwww wwwww' ,'\<www\>')

veclin=[];
for v=1:size(vorl,1)%vpatter
    kpat=v;
    %     pat=char(regexprep(vorl(kpat,1),'\^','\\^'));
    %  pat=char(regexprep(vorl(kpat,1),'\^','\\^'));
    
    pat=char(vorl(kpat,1));
    pat2=[' \<' pat '\> ' ];
    ix=regexp(e2 ,pat2);
    lin=find(~cellfun('isempty',ix));
    veclin=[veclin; lin(:)];
    for j=1:length(lin);
        q=e2(lin(j));
        for npat=1:length( ix{lin(j)});
            %             speccol=find(cellfun('isempty',strfind(col1(:,1),   pat2(regexpi(pat2,'#')+2) ))==0)
            
            %             speccol=find(cellfun('isempty',strfind(col1(:,1), q{1}(regexp(q{1},pat2,'once')+2) ))==0);
            %             q{1}(regexp(q{1},pat2,'once')+2)
            speccol=find(cellfun('isempty',regexpi(col1(:,1), q{1}(regexp(q{1},pat2,'once')+2) ))==0);
            
            if isempty(speccol)
                if mod(npat,2)==1
                    q= regexprep(q,pat2, vorl(v,2) ,'once');
                    %            q= regexprep(q,pat2,'*','once')
                else
                    q=  regexprep(q,pat2, vorl(v,3)   ,'once');
                    %            q=  regexprep(q,pat2,'+','once')
                end
            else
                
                %                 speccol2=find(cellfun('isempty',strfind(col1(:,1),...
                %                     q{1}(regexp(q{1},pat2,'once')+3) ))==0);
                speccol2=find(cellfun('isempty',regexpi(col1(:,1),...
                    q{1}(regexp(q{1},pat2,'once')+3) ))==0);
                
                ds=regexprep(vorl2,'white', col1(speccol,2));
                if ~isempty(speccol2)
                    ds=[ds regexprep(vorl3,'white', col1(speccol2,2))] ;
                end
                q= regexprep(q,pat2, ds ,'once');
                
                
            end
            
            
        end
        %q={['<html>' q{1}]};
        %        q={['<html><pre>' q{1}   '</pre>' ]};
        e2(lin(j))  =q;
    end
    
end%v
% 'r'
veclin=unique(veclin);
for i=1:length(veclin)
    e2{veclin(i)}=[  '<html><pre>' e2{veclin(i)} '</pre>'  ];
end




% #############################################################
%----------------------------------
% cofig is written HERE
%----------------------------------
function x=setup(x)
%***setup-start  %ANCHOR- DO NOT REMOVE THIS
x.colbg=[1  1  1];
x.fontsize=[8];
x.FontName='Consolas';
x.FontAngle='normal';
x.FontWeight='normal';
x.fgpos=[0.036111     0.17611     0.47951     0.46667];
x.aot=[0];
%***setup-end   %ANCHOR-DO NOT REMOVE THIS












