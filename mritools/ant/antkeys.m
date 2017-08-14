


%% #b [ANT]-KEYBOARD-SHORTCUTS
%% #wo _MAIN-PANEL_
% #g [ctrl q] #k close ANT
% #g [ctrl r] #k reload ANT
% #g [k]      #k lists the [k]eybord shortcut list
% #g [e]      #k opens windows [E]XPLORER with CURRENT DIRECTORY
% #g [p]      #k show [p]revious projects &  load a previous project
% #g [c]      #k open [c]ase-file matrix
% 
% #g [h].[space]  #k positions the Help-window to left/right side, depending were ANT is located
% #g [h].[left]   #k positions the Help-window to left side 
% #g [h].[right]  #k positions the Help-window to right side 
% #g [h].[up]     #k positions the Help-window to top 
% #g [h].[down]   #k positions the Help-window to bottom
% #g [h].[return] #k positions the Help-window to bottom, but use same x-width as ANT-window
% #g [h].[v]      #k make Help-window visible, if its behind other windows
% 
% #g [a].[left]   #k positions the ANT-window to left side 
% #g [a].[right]  #k positions the ANT-window to right side 
% #g [a].[up]     #k positions the ANT-window to center-top 
%% #wo _MOUSE-LISTBOX_
% #g [w]         #k show AVGT.nii with overlayed warped x_t2.nii
% #g [+]         #k increase fontsize
% #g [-]         #k decrease fontsize
% #g [ctrl v]    #k select folders via clipboard-contence
% #g [ctrl c]    #k copy folders to clipboard

% _________________________________________________________________________________
% #d <i>   [A].[B]  :   this means key-[A] followed by key-[B], not the reversed,not simultaneousely


%% #bl              MOUSE-LISTBOX                   
%% #bx           MOUSE-LISTBOX  
%% #ok        _MOUSE-LISTBOX_ 
%% #ko     _MOUSE-LISTBOX_  
%% #wg  _MOUSE-LISTBOX_    
%% #ka _MOUSE-LISTBOX_        


function antkeys(h,e)

% % global an;
% h
persistent lastkey
 
%   e

key=e.Key;
if strcmp(get(h,'tag'),'ant')
    if strcmp(key,'q')==1 && strcmp(e.Modifier,'control')==1
       antcb('quit');
    elseif strcmp(key,'r')==1 && strcmp(e.Modifier,'control')==1   
       try;  antcb('reload'); end
    elseif strcmp(key,'k')==1 
       uhelp('antkey');
    elseif strcmp(key,'e')==1    
        explorer;
     elseif strcmp(key,'p')==1     
        antxpath=antpath;
        prevprojects=fullfile(antxpath,'prevprojects.mat');
        load(prevprojects);
        he=selector2(pp,{'PREVIOUS PROJECTFILE', 'time (1st time called)' 'preject(description)'},...
            'out','col-1','selection','single','title','SELECT PROJECT');%,'position',[ .2 .2 .6 .4]);
        if isempty(he); return; end 
        try
            antcb('load',he{1});
        end
     elseif strcmp(key,'c')==1    
         r=ante;
         r.filematrix();
        
   elseif strcmp(key,'h')==1 
       lastkey ='h';
   %••••••••••••••••••••••••••••••••ANT WINDOW••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••    
   elseif strcmp(key,'a')==1 
       lastkey ='a';    
    elseif strcmp(key,'leftarrow')==1 &&  strcmp(lastkey,'a')==1
        try
            lastkey=[];
            h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
            set(h1,'position',[0.001  p11(2)   p11(3) p11(4)]);
            figure(h2);figure(h1);
        end
    elseif strcmp(key,'uparrow')==1 &&  strcmp(lastkey,'a')==1
        try
            lastkey=[];
            h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
            set(h1,'position',[0.3  1-p11(4)-.05   p11(3) p11(4)]);
            figure(h2);figure(h1);
        end    
    elseif strcmp(key,'rightarrow')==1 &&  strcmp(lastkey,'a')==1
        try
            lastkey=[];
            h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
            set(h1,'position',[1-p11(3)-0.001  p11(2)   p11(3) p11(4)]);
            figure(h2);figure(h1);
        end
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••    
       
    elseif strcmp(key,'return')==1 &&  strcmp(lastkey,'h')==1
        try
            lastkey=[];
            h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
            h2=findobj(0,'tag','uhelp'); p2=get(h2,'outerposition');p22=get(h2,'position');
            set(h2,'position',[p11(1) 0.05   p11(3) p11(2)-.05]);
            
            
            figure(h2);figure(h1);
        end
       
   elseif strcmp(key,'downarrow')==1 &&  strcmp(lastkey,'h')==1
       try
           lastkey=[];
           h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
           h2=findobj(0,'tag','uhelp'); p2=get(h2,'outerposition');p22=get(h2,'position');
           set(h2,'position',[p11(1) 0.05   p22(3) p11(2)-.05]);
           
           
           figure(h2);figure(h1);
       end
    elseif strcmp(key,'uparrow')==1 &&  strcmp(lastkey,'h')==1
        try
            lastkey=[];
            h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
            h2=findobj(0,'tag','uhelp'); p2=get(h2,'outerposition');p22=get(h2,'position');
            set(h2,'position',[p11(1)  p1(2)+p1(4)   p22(3)   .99-(p1(2)+p1(4))  ]);
            figure(h2);figure(h1);
        end
    elseif strcmp(key,'leftarrow')==1 &&  strcmp(lastkey,'h')==1
        try
            lastkey=[];
            h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
            h2=findobj(0,'tag','uhelp'); p2=get(h2,'outerposition');p22=get(h2,'position');
            set(h2,'position',[0  p11(2)   p11(1) p22(4)]);
            figure(h2);figure(h1);
        end
    elseif strcmp(key,'rightarrow')==1 &&  strcmp(lastkey,'h')==1
        try
            lastkey=[];
            h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
            h2=findobj(0,'tag','uhelp'); p2=get(h2,'outerposition');p22=get(h2,'position');
            set(h2,'position',[p11(1)+p11(3)  p11(2)    p22(3:4)]);
            figure(h2);figure(h1);
        end          
    elseif strcmp(key,'space')==1 &&  strcmp(lastkey,'h')==1
        try
            lastkey=[];
            h1=findobj(0,'tag','ant');   p1=get(h1,'outerposition');p11=get(h1,'position');
            h2=findobj(0,'tag','uhelp'); p2=get(h2,'outerposition');p22=get(h2,'position');
            if p11(1)>.3 %set left
                %set(h2,'position',[p11(1)-p22(3)  p11(2)    p22(3)  .9-p11(2) ]);
                set(h2,'position',[0  p11(2)    p11(1)  .9-p11(2) ]);
            else %right
                set(h2,'position',[p11(1)+p11(3)  p11(2)   1-(p11(1)+p11(3))  .9-p11(2) ]); 
            end
            
            figure(h2);figure(h1);
        end
     elseif strcmp(key,'v')==1 &&  strcmp(lastkey,'h')==1
         if ~isempty(findobj(0,'tag','uhelp'))
             figure(findobj(0,'tag','uhelp'));
%              figure(findobj(0,'tag','ant'));
         end
         lastkey=[];
    end
end

if strcmp(get(h,'tag'),'lb3')
   
    if strcmp(key,'w')
        
        pa=antcb('getsubjects');
        f1=fullfile(fileparts(fileparts(pa{1})),'templates\AVGT.nii');
        [ha a]   =rgetnii(f1);
        
        for i=1:size(pa,1)
            try
                pax=pa{i};
                [~,fold,]=fileparts(pax);
                %f1=fullfile(pax,'AVGT.nii');
                f2=fullfile(pax,'x_t2.nii');
                
                [hb b]   =rgetnii(f2);
                
                vs=[50:10:160];
                a4=montageout( rot90( permute(a(:,vs,:),[1 3 4 2])));
                b4=montageout( rot90( permute(b(:,vs,:),[1 3 4 2])));
                % fg,imagesc(a4)
                
                b5=mat2gray(b4);
                
                hf=findobj(0,'tag','contourwarp');
                if isempty(hf)
                    hf=figure(1000);
                    set(hf,'units','norm','color','w','tag','contourwarp','position',[ 0.5951    0.3839    0.3889    0.466]);
                    set(gca,'position',[0 0 1 .95]);set(gcf,'menubar','none'); zoom on;
                    
                end
                set(0,'CurrentFigure',1000);
                
                try
                    delete(findobj(findobj(0,'tag','contourwarp'),'type','image'))
                end
                try
                    delete(findobj(findobj(0,'tag','contourwarp'),'type','contour'))
                end
                
                image(cat(3,b5,b5,b5)); hold all; contour(a4,10,'color','r'); colormap gray;
                title([fold ':    ' 'AVGT.nii' ' - ' 'x_t2.nii'],'fontweight','bold','fontsize',8,'interpreter','latex');
                axis off;
                hold off;
                 drawnow;
                 
                
                
               
                if size(pa,1)>1
                    pause(.5);
                end
                uicontrol(findobj(findobj(0,'tag','ant'),'tag','lb3'));
            end
        end
    end
    %CHARACTER
    if strcmp(e.Modifier,'control')  %clipnoard-selected folders
        if strcmp(e.Key,'v')
            xseldirs;
        elseif strcmp(e.Key,'c')
            pa=antcb('getsubjects');
            mat2clip(pa);
        end
    end
    if strcmp(e.Character,'+')
        hl=findobj(findobj(0,'tag','ant'),'tag','lb3');
        fs=get(hl,'fontsize')+1;
        set(hl,'fontsize',fs);
    elseif strcmp(e.Character,'-')
        hl=findobj(findobj(0,'tag','ant'),'tag','lb3');
        fs=get(hl,'fontsize')-1;
        if fs<4; return; end
        set(hl,'fontsize',fs);
           
    end
    
end