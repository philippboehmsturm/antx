
%% #b ant-callbacks
%% 
% #yk EXAMPLES
% antcb('getsubjects')    % get selected subjects-->only those selected from [ANT] Mouse-listbox
% antcb('getallsubjects') % get all subjects  --> all from list
% antcb('load','proj_Harms3_lesionfill_20stack.m')   %load this project
% antcb('reload')         % reload gui with project and previous mice-selection
% antcb('fontsize',8)              % set fontsize
% antcb('status',1,'copy Images'); % antcb('status',0,'coffeTime')     statusUpdate
% antcb('update');                 % update subjects
% antcb('quit')/antcb('close')     % close gui


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                  UICALLBACKS
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


function varargout=antcb(h,emp,do,varargin)

warning off;

if ~ishandle(h)
    try; input=[emp do varargin];
    catch;
        try;  input=[emp varargin];
        catch; input=[ varargin];
        end
    end
    %     if exist('do')==1 && ~isempty(varargin)
    %       varargin=  [do varargin];
    %       do=h;
    %     else
    do=h;
    try; varargin=emp;end
    %     end
    
end

hfig=findobj(0,'tag','ant');
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%           LOAD CONFIG
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(do, 'fontsize');
    fontsize(input);
end

if strcmp(do, 'load');
    disp(' ...load project..');
    %% open ant before, if nonexisting
    if isempty(findobj(0,'tag','ant'))
        ant
    end
    
    try
        
        configfile=varargin;
        if exist(configfile)~=2;  configfile=[]; end
    catch
        configfile=[];
    end
    
    if isempty(configfile)
        [fi pa ]=uigetfile(pwd,'select projectfile [mfile]','proj*.m');
        if ~ischar(pa); 
            pause(2)
            return;
            pause(2)
        end
        projectfile=fullfile(pa,fi);
    else
        [pa fi]=fileparts(configfile);
        projectfile=fullfile(pa,[fi]);
    end
 %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••   
    %% make history of previous projectfiles
    if 1
        antxpath=antpath;
        prevprojects=fullfile(antxpath,'prevprojects.mat');
        run(projectfile);
        if exist(prevprojects)~=2
            pp={'-' '-' '-'};
            save(prevprojects,'pp');
        end
        load(prevprojects);
        [ppath pfi pext]=fileparts(projectfile);
        projectfile2=fullfile(ppath, [pfi '.m']);
        
        if strcmp(pp(:,1),projectfile2)==0 %ADD PROJECTFILE
            if strcmp(pp(:,1),'-')==1     ; %replace empty array
                pp={ projectfile2 , datestr(now)  x.project};
            else
                pp(end+1,:)={ projectfile2 , datestr(now) x.project};
            end
            save(prevprojects,'pp');
        end
        
    end
   %•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••• 
    
    clear global an;
    global an;
    run(projectfile);
    cd(fileparts(projectfile));
    an=x;
    antconfig(0);
    
    an.templatepath=fullfile(fileparts(an.datpath),'templates');
    %[pathx s]=antpath;
    % %%%%%%    x= catstruct(x,s);
%     x= catstruct(s,x);% overwrite defaults with "m-file config"-data
    an.configfile=projectfile;
     %remove from list
    try;       an=rmfield(an,'ls');     end
    try;       an=rmfield(an,'mdirs');     end
    an.ls =struct2list(an); %   ls=fn_structdisp(x);
    
    %an=x;
   
    
    iproject=regexpi2(an.ls,'project.*=');
  an.ls(regexpi2(an.ls,'^\s*an.inf\d'))=[];
    lims=strfind(an.ls{iproject},'''');
    
    %        colergen = @(color,text) ['<html><b><font color='  color '  bgcolor="black" size="+2">' text '</html>'  ];
    colergen = @(color,text) ['<html><b><font color='  color '   size="+2">' text '</html>'  ];
    
    %  colergen = @(color,text) ['<html><table border=0 width=1000 bgcolor=',color,'><TR><TD><pre>',text,'</pre></TD></TR> </table></html>'];
    % % colergen = @(color,text) ['<html><table border=0 width=1400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
    %  dum=colergen('#ffcccc',   x.ls{iproject}(lims(1):lims(2))    )
    %  x.ls{iproject}=   strrep(  x.ls{iproject},  x.ls{iproject}(lims(1):lims(2))   , dum)
    
    an.ls{1}=colergen('#007700',   an.ls{1} );
    %  dum=colergen('#ffcccc',   x.ls{iproject}(lims(1):lims(2))    )
    %  x.ls{iproject}=   strrep(  x.ls{iproject},  x.ls{iproject}(lims(1):lims(2))   , dum)
    
    set(findobj(0,'tag','ant'),'name' ,fi);
    set(findobj(0,'tag','lb2'),'string', an.ls,'FontName','courier');
    
    
    antcb('update'); %update subkects
    
    return
end

if strcmp(do, 'settings');
   antconfig
    
    
    
    
end
if strcmp(do,'close') || strcmp(do,'quit') ;
     hr=findobj(0,'tag','ant');
    set(hr,'closereq','closereq');
    close(hr);
end

if strcmp(do,'reload')
    global an;
    lb=findobj(gcf,'tag','lb3');
    try
        configfile=an.configfile;
        val=get(lb,'value');
    catch
        configfile='';
        val=1;
    end
    
    antcb('quit');
    ant;
    if ~isempty(configfile)
        antcb('load',configfile);
        lb=findobj(gcf,'tag','lb3');
        set(lb,'value',val)
    end
end
    
    

if strcmp(do,'getsubjects');
    paths=getsubjects;
    varargout{1}=paths;
end
if strcmp(do,'getallsubjects');
    paths=getallsubjects;
    varargout{1}=paths;
end

if strcmp(do,'close');
    set(findobj(0,'tag','ant'),'closereq','closereq');
end

if strcmp(do,'status');
    if ~iscell(input); input=cell(input);end
     status(input)
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                                                                                  RUN-MOUSE FIRST    : OLD
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% if strcmp(do, 'run');
%     hfun=findobj(gcf, 'tag','lb1');
%
%     id2exe=get(hfun,'value');
%     funlist=antfun('funlist');
%
%     tasks= funlist(id2exe,2) ; %tasks to perform
%
%     for i=1:length(tasks)
%         antfun(tasks{i});
%     end
%
% end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                                                                                  RUN-2 :       FUNCTIONS FIRST
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if strcmp(do, 'run2') || strcmp(do, 'run');
    antcb('status',1,'running functions');
    hfun=findobj(gcf, 'tag','lb1');
    id2exe=get(hfun,'value');
    funlist=antfun('funlist');
    
    tasks= funlist(id2exe,2) ; %tasks to perform
    paths=antcb('getsubjects');%MousePaths
    if ischar(paths)
        paths=cellstr(paths);
    end
    %_================================
    %% run only once, i.e. NOT over subjects
    if any(cell2mat(funlist(id2exe,4))==0)
        
        for i=1:size(tasks,1)
            try
                antcb('status',1,tasks{i});
                antfun(tasks{i},paths);
            catch
                antcb('status',0);
            end
        end
        antcb('status',0);
        
        return
    end
    %% ================================
    %%                           RUN-1 (upper RUN button)
    %% ================================
    
    if strcmp(do, 'run');
        %disp('_____________________________________________');
        %% perform all tasks within a Mouse first
        % O:\harms1\koeln\dat\s20150701_AA1  & xwarp-1
        % O:\harms1\koeln\dat\s20150701_AA1  & xwarp-21
        % O:\harms1\koeln\dat\s20150701_BB1  & xwarp-1
        % O:\harms1\koeln\dat\s20150701_BB1  & xwarp-21
        %%collect xwarpFunctions for withinMouse
        global an
        
        %  bind xwarp-processes
        iwarp=  regexpi2(tasks,'xwarp-');
        if ~isempty(iwarp)
            tasksub=tasks(iwarp);
            procs=str2num(char(regexprep(tasksub,'xwarp-','')))';
            autocoreg=1;
            if length(find(procs==20 | procs==21))==2  ;%remove MANUAL if AUTO & MANU were selected both
                procs(procs==20)=[];
            end
            
            if find(procs==20)
                procs(procs==20)=2;
                autocoreg=0;
            elseif find(procs==21)
                procs(procs==21)=2;
            end
            tasks(iwarp(1),1:3)={'xwarp', procs,  autocoreg};
            tasks(setdiff( iwarp ,1)  ,: )=[];
        end
        
        %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
        useparallel=an.wa.usePCT;
        %useparallel=0;
        %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
        if useparallel~=0
            if isempty(ver('distcomp'))==1 %no PARALLEL-TB
                disp('Parallel Computing Toolbox(PCT) not working, check..licence/validation (preferences)');
                disp('..for now process data without PCT');
                useparallel=0;
            end
        end
        
        
        if useparallel==0 % normal VERSION       ----  1 CORE
            for j=1:length(paths)
                for i=1:size(tasks,1)
                    try
                        antfun(tasks{i},paths{j},tasks{i,2:end},an);
                    catch
                        antfun(tasks{i,1},paths{j});
                    end
                end
            end
        end
        %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
        if useparallel==1 % PARALLE-VERSION----  SPMD
            
            global an
            
            
            startspmd(an, paths,tasks);
            
            
% %             %             mpools=[4 3 2];
% %             %             for k=1:length(mpools)
% %             %                 try;
% %             %                     matlabpool(mpools(k));
% %             %                     disp(sprintf('process with %d PARALLEL-CORES (SPMD)',mppols(k)));
% %             %                     break
% %             %                 end
% %             %             end
% %             createParallelpools;
% %             disp('..PCT-SPMD used');
% %             
% %             atime=tic;
% %             %% SPMD
% %             global an
% %             if 1 
% %             %spmd
% %                 for j = labindex:numlabs:length(paths)   %% j=1:length(paths)
% %                     for i=1:size(tasks,1)
% %                         %try
% %                         %  i,j, paths{j}
% %                         
% %                         try
% %                             disp(sprintf('%d, %d  -%s',j,i,paths{j} ));
% %                             antfun(tasks{i},paths{j},tasks{i,2:end},an);
% %                         end
% %                         %catch
% %                         % &antfun(tasks{i,1},paths{j});
% %                         %end
% %                     end %i
% %                 end
% %             end %spmd
% %             toc(atime);
        end%SPMD
        %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
        %%  PARALLEL VERSION       ----  PARFOR
        if  useparallel==2
            createParallelpools;
            disp('..PCT-PARFOR used');
            
            %             mpools=[4 3 2];
            %             for k=1:length(mpools)
            %                 try;
            %                     matlabpool(mpools(k));
            %                     disp(sprintf('process with %d PARALLEL-CORES',mppols(k)));
            %                     break
            %                 end
            %             end
         
            %             if 0
            %                 pax=paths;
            %                 job=tasks;
            %                 Njob=size(job,1);
            %                 Npax=length(pax);
            %
            %                 parfor j=1:Npax%length(pax)
            %                     %                 for i=1:Njob%size(tasks,1)
            %                     %                     try
            %                     antfun(job{1},pax{j},job{1,2:end});
            %                     %                     catch
            %                     %                         antfun(job{i,1},pax{j});
            %                     %                     end
            %                     %                 end
            %                 end
            %             end
            
            
            %% change for/parfor here
            atime=tic;
            if size(tasks,1)
                %task2=tasks(1,:);
                mouse=paths;
                Nm=length(mouse);
                parfor j=1:Nm
                    %                     try
                    %task1     =tasks{1};
                    % subtask1=tasks(2:end)
                    v=mouse{j};
                    %antfun('xwarp'  ,v,  tasks{2} ,tasks{3}  ,an);
                    antfun(tasks{1} ,v,  tasks{2} ,tasks{3}  ,an);
                    %                         antfun(tasks{1},paths{j},tasks{1,2:end});
                    %                     catch
                    %                         antfun(tasks{1,1},paths{j});
                    %                     end
                end
            end
            toc(atime);
            
            disp('end')
            %         try;    matlabpool close; end
        end%PARFOR VERSION
        
        %% ================================
        %%                           RUN-2 (LOWER RUN button)
        %% ================================
        %% RUN-2
    else
        %% perform each function first over all mice
        % O:\harms1\koeln\dat\s20150701_AA1  & xwarp-1
        % O:\harms1\koeln\dat\s20150701_BB1  & xwarp-1
        % O:\harms1\koeln\dat\s20150701_AA1  & xwarp-21
        % O:\harms1\koeln\dat\s20150701_BB1  & xwarp-21
        for i=1:size(tasks,1)
            for j=1:length(paths)
                antfun(tasks{i},paths{j});
            end
        end
    end
    antcb('status',0);
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%           koad subjects
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% gui-functions
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(do, 'update')
    fig=findobj(0,'tag','ant');
    global an
    if isempty(an); disp('no project loaded');return;end
    % [dirx,sts] = spm_select(inf,'dir','select mouse folders',[],an.datpath,'s'); %GUI
    %     [sts dirx] = spm_select('FPlist',an.datpath,'s');
    %     if isempty(dirx); return; end
    %     dirx=cellstr(dirx);
    %     try
    %         dirsid=cellfun(@(a) {[a(1+10:end)]},   strrep(strrep(dirx,[an.datpath filesep],''),filesep,'')   );
    %     catch
    %         dirsid=   strrep(strrep(dirx,[an.datpath filesep],''),filesep,'')
    %     end
    
    [sts dirx] = spm_select('FPlist',an.datpath,'');
    if isempty(dirx);
         set(findobj('tag','lb3'),'string',''); %empty listbox
%          delete(get(findobj('tag','lb3'),'UIContextMenu'));%delete contextMenu
        return;
    end
    dirx=cellstr(dirx);
    
    %% sort after task-performed
    if get(findobj(fig,'tag','rbsortprogress'),'value')==1 && length(dirx)>1
        pa=dirx;
        for i=1:size(pa,1)
            pas=pa{i};
            n=1;
            lg(n)=size(dir(fullfile(pas,'c_*.nii')),1)>0;          n=n+1;
            lg(n)=exist(fullfile(pas,   't2.nii'))==2;            n=n+1;
            lg(n)=exist(fullfile(pas,   'reorient.mat'))==2;      n=n+1;
            lg(n)=exist(fullfile(pas,   'c1t2.nii'))==2;          n=n+1;
            lg(n)=exist(fullfile(pas,   'w_t2.nii'))==2;          n=n+1;
            lg(n)=exist(fullfile(pas,   'x_t2.nii'))==2;          n=n+1;
            d(i,:)=lg;
        end
        %d2=sum(d.*repmat([1 2 4 8 16],[size(d,1) 1]),2);
        d2=sum(d.*repmat([2.^([1:length(lg)]-1)],[size(d,1) 1]),2);
        
        [is isor]=sort(d2,'descend');
        dirx=pa(isor);
    end
    
    %     try
    %         dirsid=cellfun(@(a) {[a(1+10:end)]},   strrep(strrep(dirx,[an.datpath filesep],''),filesep,'')   );
    %     catch
    dirsid=   strrep(strrep(dirx,[an.datpath filesep],''),filesep,'');
    %     end
    
    %% CHECK STATE : make status BULLETS
    if 1
        chk=[];
        toolt={};
        chklab={'c_*.nii' 't2.nii' ,'reorient.mat' 'c1t2.nii' 'w_t2.nii' 'x_t2.nii' };
        
        for i=1:length(dirx)
            pa=dirx{i};
            chk0=[];
            %         chk0(end+1,1)=exist(fullfile(pa,'t2.nii'))==2   ;%EXIST t2.nii
            %         chk0(end+1,1)=exist(fullfile(pa,'reorient.mat'))==2  ;%reorient MAT
            %         chk0(end+1,1)=exist(fullfile(pa,'c1t2.nii'))==2  ;%segment (c1)
            %         chk0(end+1,1)=exist(fullfile(pa,'w_t2.nii'))==2  ;%SPM warped
            %         chk0(end+1,1)=exist(fullfile(pa,'x_t2.nii'))==2  ;%ELASTIX warped
            %         chk(end+1,:)=chk0;
            
            tt={};
            for j=1:length(chklab)
                k=dir(fullfile(pa,chklab{j}))   ;
                if size(k,1)
                    k=k(1);
                end
                
                if ~isempty(k);            tt{end+1,1}  =sprintf('%s:\t\t%s ,  %2.2fMb', chklab{j}, k.date, k.bytes/1e6)   ;
                    chk0(end+1,1)=1;
                else
                    tt{end+1,1}  =sprintf('%s:\t %s  ', chklab{j}, '    ---not found---')   ;
                    chk0(end+1,1)=0;
                end
            end
            chk(end+1,:)=chk0;
            toolt(end+1,1)={tt};
        end
        
        %% check status
        dropoutvec=zeros(size(dirx,1),1);
        for i=1:length(dirx);
            statusfile=fullfile(dirx{i},'status.mat');
            if exist(statusfile)==2
                load(statusfile);
               dropoutvec(i)= status.isdropout;
            end
        end
        
        
        
        colundone={'WhiteSmoke'  	'#F5F5F5'}; % color of undone process
        cols={
            'greenlight'  '#99ff99'
            'Gold'  '#FFD700'
            'Green'  	'#008000'
            'LightSkyBlue'  	'#87CEFA'
            'Orange'  	'#FFA500'
            'OrangeRed'  	'#FF4500'
            }; %colors
        
        %MAKE TABLE
        %     coltb=num2cell(double(chk)); %to cell
        %     coltb=cellfun(@(a) [num2str(a)],coltb,'UniformOutput',false); %to cellSTR
        cb=repmat(colundone(1,2),size(chk));
        for j=1:size(chk,2)
            for c=1:size(chk,1)
                if chk(c,j)==1
                    cb(c,j)=cols(j,2);
                end
            end
        end
        dirsid2=repmat({''},size(dirsid,1),1);
        
        %% AD SAME SPACE AFTER NAMES
        si=size(char(dirsid),2);
        dirsidHTML=cellfun(@(a) [(a) repmat('&nbsp' ,1,si-length(a)  )],dirsid,'UniformOutput',false);
        
        
        %     symbol='&#9733'; %STAR
        %     symbol='&#9787'; %SMILEY
        symbol='&#9632';%square
        for i=1:size(dirsid,1)
            %     sw=sprintf(['<html>'     '%s'   '<font color =%s>&#9733'  '</html>'  ] ,dirsid{i}, cb{i,1} )
            %     sw=sprintf(['<html>'     '%s'   repmat('<font color =%s>&#9733',1, size(cols,1))  '</html>'  ] ,dirsid{i}, cb{i,1} )
            dum=[ dirsidHTML{i} cb(i,:)];
            sw=sprintf(['<html>'     '%s'   repmat(['<font color =%s>'  symbol ] ,1, size(cols,1))  '</html>'  ] ,dum{:} );
            dirsid2{i,1}=sw;
            
            %% TOOLTIP
            tooltdum=cellfun(@(a) [ '<font color=' (a) '>' symbol  '<font color=black'  '>'],cb(i,:)','UniformOutput',false);
            
          
            
            tt= cellfun(@(x,y) [x y ],tooltdum,toolt{i},'un',0);
           if dropoutvec(i)==1
             tt=  [ ['<font color=red>' ' *** REMOVED FROM ANALYSIS '] ; tt];
            end
            
            head=['<b><font color="blue"> ' dirx{i} ' </b><br> '];
            tt2=[ '<html>' head   strjoin('<br>',tt)  '</html>' ];
            tooltip{i,1}=tt2;
            %         set(o,'tooltipstr',tt2);
        end
        %     set(hf,'string',dirsid)
        %        s{1}=['<html>'  'I will display <font color =#ADFF2F>&#9733<font color ="Aqua">&#9733<font color ="grey">&#9734'   '</html>'  ]
        dirsid=dirsid2;
    end
    
    lb=findobj(gcf,'tag','lb3');
    set(lb,'userdata', [dirsid dirsid tooltip]);
    
    
    %% displax dropouts using html color
    if any(dropoutvec)==1
        idropout=find(dropoutvec==1);
        dirdrop =dirsid(idropout);
        dirdrop=regexprep(dirdrop,{'<html>' '</html>'},{'<html><s><Font color="red">' '</s>/<html>'});
        dirsid(idropout) =dirdrop;
        
    end
    
    
    
    %  [id ]
    %
    %  [files1 filesshort]=deal({});
    %  for i=1:length(dirx);
    %      kk=rdir(fullfile(dirx{i}, '**/s20*.nii'));
    %      files1{i,1}  =kk.name;
    %      [~ ,fis]=fileparts(kk.name)
    %      nameshort= regexprep(fis,'^\w','');
    %      usc= strfind(nameshort,'_');
    %      nameshort=nameshort(usc(1)+1:usc(3)-1);
    %      filesshort{i,1}=nameshort;
    %  end
    if ~isempty(dirx)
        lb=findobj(gcf,'tag','lb3');
        set(lb,'string', dirsid);%,'userdata',dirx);
        %         set(lb,'fontsize',12);
        set(lb,'fontname','courier');
        an.mdirs=dirx;
    end
    
    %% SET TOOLTIP
    %% TOOLTIP :CASES
    if  0
        lb3                  =findobj(gcf,'tag','lb3');
        hfun_jScrollPane_lb3 = java(findjobj(lb3));
        hfun_jListbox_lb3     = hfun_jScrollPane_lb3.getViewport.getView;
        set(hfun_jListbox_lb3, 'MouseMovedCallback', {@tooltip_lb3,lb3, tooltip });
    end
    
    if 0
        %% TOOLTIP : functions
        funlist=antfun('funlist');
        lb1=findobj(findobj(0,'tag','ant'),'tag','lb1');
        hfun_jScrollPane_lb1 = java(findjobj(lb1));
        hfun_jListbox_lb1     = hfun_jScrollPane_lb1.getViewport.getView;
        set(hfun_jListbox_lb1, 'MouseMovedCallback', {@tooltip_lb1,lb1, funlist(:,3) });
    end
    
    if 0
        funlist=antfun('funlist');
        funlist=antfun('funlist');
        lb1                  =findobj(gcf,'tag','lb1');
        hfun_jScrollPane_lb1 = java(findjobj(lb1));
        hfun_jListbox_lb1     = hfun_jScrollPane_lb1.getViewport.getView;
        set(hfun_jListbox_lb1, 'MouseMovedCallback', {@tooltip_lb1,lb1, funlist(:,3) });
    end
    
    
    %% no FONT-SCALING
    set(findobj(gcf,'style','listbox'),'FontUnits','pixels');
    set(findobj(gcf,'style','pushbutton'),'FontUnits','pixels');
    set(findobj(gcf,'style','text'),'FontUnits','pixels');
    
end

%% FUNCTIONS-listbox: Mouse-movement callback-->tooltip
function tooltip_lb1(jListbox, jEventData, hListbox,tooltipscell)
mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
% hoverIndex = jListbox.locationToIndex(mousePos) + 1;
hoverIndex=get(mousePos,'Y');
fs=get(hListbox,'fontsize');
[hoverIndex   hoverIndex/fs];
est=fs*2;
re=rem(hoverIndex,est);
va=((hoverIndex-re)/est)+1;
%    t=[hoverIndex    va+1   ]
if     va>0 && va<=length(tooltipscell)
    listValues = get(hListbox,'string');
    hoverValue = listValues{va};
    msgStr = sprintf('<html>   <b>%s</b> %s </html>', hoverValue, tooltipscell{va} );
    
    set(hListbox, 'Tooltip',msgStr);
end



%% FUNCTIONS-listbox: Mouse-movement callback-->tooltip
function tooltip_lb3(jListbox, jEventData, hListbox,tooltipscell)
mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
% hoverIndex = jListbox.locationToIndex(mousePos) + 1;
hoverIndex=get(mousePos,'Y');
fs=get(hListbox,'fontsize');
[hoverIndex   hoverIndex/fs];
est=fs*2;
re=rem(hoverIndex,est);
va=((hoverIndex-re)/est)+1;
%    t=[hoverIndex    va+1   ]
if     va>0 && va<=length(tooltipscell)
    %     listValues = get(hListbox,'string');
    %     hoverValue = listValues{va};
    %     msgStr = sprintf('<html>   <b>%s</b> %s </html>', hoverValue, tooltipscell{va} );
    %
    set(hListbox, 'Tooltip',  tooltipscell{va}  );
end



%
% popup=get(findobj(hfig,'tag','rb1'),'value')
%
% if strcmp(do, 'run')
%     id=findobj(hfig,'tag','lb1');
%     ls=get(id,'string');
%     fun=ls(get(id,'value'));
%     starttimer
%     for i=1:length(fun)
%         funi=fun{i}
%         dotask(funi)
%     end
%     delete(timerfind('tag','xboxtimer'));
%     hfig=findobj(0,'tag','xbox');
%     set(findobj(hfig,'tag','status'),'string','status: idle');
%     assignin('base','msgtxt','');
% else
%     doguitask(h,emp,do,varargin)
% end

function doguitask(h,emp,do,varargin)
fig=findobj(0,'tag','xbox');
us=get(fig,'userdata');


if strcmp(do, 'update');    update;end
if strcmp(do, 'clearsubjects');    clearsubjects;end



function dotask(funi)
fig=findobj(0,'tag','xbox');
us=get(fig,'userdata');
if strcmp(funi, 'xcreateproject')
    [pax ls]=  feval('xloadproject', 'create');
    set(findobj(0,'tag','xbox'),'userdata',pax,'name' ,pax.projname);
    set(findobj(0,'tag','lb2'),'string', ls);
elseif strcmp(funi, 'xconvert2nifti')
    xconvert2nifti(us);
elseif strcmp(funi, 'xcoregister auto')
    feval(@xcoregister,getselectedcases(us),0);
    
elseif strcmp(funi, 'xcoregister manu')
    feval(@xcoregister,getselectedcases(us),1);
elseif strcmp(funi, 'xsegment')
    feval(@xsegment,getselectedcases(us));
elseif strcmp(funi, 'xnormalizeElastix')
    feval(@xnormalizeElastix,getselectedcases(us));
elseif strcmp(funi, 'xnormalizeElastixSepHemi')
    feval(@xnormalizeElastixSepHemi,getselectedcases(us));
    
elseif strcmp(funi, 'xnormalizeElastixSepHemiTPM')
    feval(@xnormalizeElastixSepHemiTPM,getselectedcases(us));
    
    
end



%
% %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% % gui-functions
% %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% function update
% fig=findobj(0,'tag','ant');
% us=get(fig,'userdata');
% if isempty(us); disp('no project loaded');return;end
% [dirx,sts] = spm_select(inf,'dir','select mouse folders',[],us.datpath,'s');
% if isempty(dirx); return; end
% dirx=cellstr(dirx);
%
% try
%     dirsid=cellfun(@(a) {[a(1+10:end)]},   strrep(strrep(dirx,[us.datpath filesep],''),filesep,'')   );
% catch
%     dirsid=   strrep(strrep(dirx,[us.datpath filesep],''),filesep,'')
% end
%
% %  [id ]
% %
% %  [files1 filesshort]=deal({});
% %  for i=1:length(dirx);
% %      kk=rdir(fullfile(dirx{i}, '**/s20*.nii'));
% %      files1{i,1}  =kk.name;
% %      [~ ,fis]=fileparts(kk.name)
% %      nameshort= regexprep(fis,'^\w','');
% %      usc= strfind(nameshort,'_');
% %      nameshort=nameshort(usc(1)+1:usc(3)-1);
% %      filesshort{i,1}=nameshort;
% %  end
% if ~isempty(dirx)
%     lb=findobj(gcf,'tag','lb3');
%     set(lb,'string', dirsid,'userdata',dirx);
%     set(lb,'fontsize',10);
% end

function clearsubjects
fig=findobj(0,'tag','ant');
us=get(fig,'userdata');
if isempty(us); disp('no project loaded');return;end
lb=findobj(gcf,'tag','lb3');
set(lb,'userdata',[],'string',[],'value',1);

function us=getselectedcases(us)
hfig=findobj(0,'tag','ant');
figure(hfig);
usecases=get(findobj(hfig,'tag','rb1'),'value');
lb=findobj(hfig,'tag','lb3');
files=get(lb,'userdata');
if usecases==1
    if isempty(files)==0
        files=files.fi;
        files=files((get(lb,'value')));
        us.runfiles=files;
        %           feval(@xcoregister,us,0);
    end
end

function starttimer
try; delete(timerfind('tag','xboxtimer')); end
t = timer('TimerFcn',@timercallback, 'Period', 10,'tag','xboxtimer','ExecutionMode', 'FixedRate');
start(t);

function timercallback(u1,u2)
try
    txt=evalin('base','msgtxt');
    hfig=findobj(0,'tag','xbox');
    %     set(findobj(hfig,'tag','status'),'string',[txt ' ' datestr(now,'HH:MM:SS (dd-mmm)')]);
    set(findobj(hfig,'tag','status'),'string',[txt.tag ' ' sprintf('dt %2.1fmin', etime(clock, txt.time)/60 )  ]);
    
    %       [txt.tag ' ' sprintf('dt %2.1fmin', etime(clock, txt.time)/60 )  ]
    
end

%       set(findobj(hfig,'tag','status'),'string',[txt.tag ' ' sprintf('dt %2.2fs', etime(clock, txt.time))/60  ]);


function paths=getsubjects
global an
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
%li=get(lb3,'string');
va=get(lb3,'value');
paths=an.mdirs(va);

%% remove path which are taken out from analysis
li=get(lb3,'string');
pathshtml=li(va);
del=regexpi2(pathshtml,'</s>');
pathshtml(del)=[];
paths(   del)=[];


function paths=getallsubjects
global an
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
%li=get(lb3,'string');

paths=an.mdirs;
% %% remove 'deselected' files
% [pathstr, name, ext] = fileparts2(paths);
% paths(regexpi2(name,'^_'))=[];
    

function status(input)
% input
bool=input{1};
try; 
    msg=input{2};
end
if exist('msg')==0; msg='';else; msg=['..' msg]; end
hr=findobj(findobj(0,'tag','ant'),'tag','status');
if bool ==1
    set(hr,'string',['status: BUSY!' msg],'foregroundcolor','r');
     set(hr,'TooltipString',['<html><b><font color=red>BUSY since: <font color k>' datestr(now,'HH:MM:SS')]);
     set(hr,'userdata',datestr(now,'HH:MM:SS'));
elseif bool==0
    set(hr,'string',['status: IDLE' msg],'foregroundcolor','b');
    lastprocess=get(hr,'userdata');
    if isempty(lastprocess); 
        idlemsg=['<html><b><font color=green>IDLE since: <font color="black">' datestr(now,'HH:MM:SS') '</font></html>'];
    else
        idlemsg=...
       ['<html><pre><font color=gray >last process ended: <font color="black">' lastprocess  '<br>'...
        '<font color=green><b>IDLE since:         <font color="black">' datestr(now,'HH:MM:SS')] ;
       % sprintf(['<html><b>line #1</b><br /><i><font color="red">line#2</font></i></html>']
    end
    set(hr,'TooltipString',idlemsg);
    

end
drawnow
pause(.01);



function fontsize(iput)

x.defaultFS=0;

if nargin==1
    fs=iput{1};
    if ischar(fs)
        if strcmp(fs,'default')
            x.defaultFS=1;
        end
    end
end

% ScreenPixelsPerInch=get(0,'ScreenPixelsPerInch');
if 1%ScreenPixelsPerInch<100
    %     ant
    %     antcb('load','O:\harms1\harms4\proj_Harms4.m');
    hfig=findobj(0,'tag','ant');
    %ch= get(hfig,'children');
    
    %pushbuttons
    ci= findobj(hfig,'tag','pb1');
    set(ci,'fontunits','points');
    if x.defaultFS==0
        s=get(ci,'string');
        set(ci,'string',regexprep(s,'<h\d>','<h0>'),'fontsize',fs-1);
    end
    set(ci,'fontunits','norm');
    
    
    ci= findobj(hfig,'tag','pb2');
    set(ci,'fontunits','points');
    if x.defaultFS==0
        s=get(ci,'string');
        set(ci,'string',regexprep(s,'<h\d>','<h0>'),'fontsize',fs-1);
    end
    set(ci,'fontunits','norm');
    
    ci= findobj(hfig,'tag','pbload');
    set(ci,'fontunits','points');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','norm');
    
    
    ci= findobj(hfig,'tag','pbloadsubjects');
    set(ci,'fontunits','points');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','norm');
    
    
    ci= findobj(hfig,'tag','status');
    set(ci,'fontunits','points');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','norm');
    
    
    ci= findobj(hfig,'tag','lb1');
    set(ci,'fontunits','points');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','norm');
    
    
    ci= findobj(hfig,'tag','lb2');
    set(ci,'fontunits','points');
    if x.defaultFS==0
        set(ci,'fontsize',fs) ;
    end
    set(ci,'fontunits','norm');
    
    
    ci= findobj(hfig,'tag','lb3');
    set(ci,'fontunits','points');
    if x.defaultFS==0
        set(ci,'fontsize',fs-1) ;
    end
    set(ci,'fontunits','norm');
    
    %html tag path in infolLB
    ci= findobj(hfig,'tag','lb2');
    set(ci,'fontunits','points');
    s=get(ci,'string');
    if x.defaultFS==0
        set(ci,'string',regexprep(s,'+\d"','+0"'));
    end
    set(ci,'fontunits','norm');
end

