function varargout=dti_eig(bch)
% Tensor decomposition
%
% Computes eigenvector components, eigenvalues and euler angles (pitch,
% roll, yaw convention) from diffusion tensor data.
% Output image naming convention
%/*\begin{itemize}*/
%/*\item*/  evec1[x,y,z]*IMAGE - components of 1st eigenvector
%/*\item*/  evec2[x,y,z]*IMAGE - components of 2nd eigenvector
%/*\item*/  evec3[x,y,z]*IMAGE - components of 3rd eigenvector
%/*\item*/  eval[1,2,3]*IMAGE  - eigenvalues
%/*\item*/  euler[1,2,3]*IMAGE - euler angles
%/*\end{itemize}*/
% Batch processing
% FORMAT res = dti_eig(bch)
% ======
%/*\begin{itemize}*/
%/*\item*/ Input argument:
%   bch struct with fields
%/*\begin{description}*/
%/*\item[*/       .dtimg/*]*/     cell array of filenames of tensor images
%/*\item[*/       .data/*]*/      real 6-by-Xdim-by-Ydim-by-Zdim-array of tensor elements
%/*\item[*/       .dteigopts/*]*/ results wanted, a string array containing a
%                  combination of /*\begin{description}*/
%/*\item[*/                   v/*]*/ (eigenvectors)
%/*\item[*/                   l/*]*/ (eigenvalues)
%/*\item[*/                   a/*]*/ (euler angles)/*\end{description}*/
%/*\end{description}*/
% Only one of 'dtimg' or 'data' need to be specified. If 'data' is
% provided, no files will be read and outputs will be given as
% arrays in the returned 'res' structure. Input order for the
% tensor elements is alphabetical.
%/*\item*/ Output argument (only defined if bch has a 'data' field):
%   res struct with fields
%/*\begin{description}*/
%/*\item[*/       .evec/*]*/  eigenvectors
%/*\item[*/       .eval/*]*/  eigenvalues
%/*\item[*/       .euler/*]*/ euler angles
%/*\end{description}*/
% The presence of each field depends on the option specified in
% the batch.
%/*\end{itemize}*/
%
% This function is part of the diffusion toolbox for SPM5. For general
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id$

rev = '$Revision$';
funcname = 'Tensor decomposition';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

if isfield(bch,'data')
    tmp=size(bch.data);
    if length(tmp)>4||tmp(1)~=6
        error('wrong DTI dimensions');
    end;
    DTIdim=[1 1 1];
    DTIdim(1:length(tmp)-1)=tmp(2:end);
    if any(bch.dteigopts=='v')
        res.evec = zeros([3,3,DTIdim]);
    end;
    if any(bch.dteigopts=='l')
        res.eval = zeros([3,DTIdim]);
    end;
    if any(bch.dteigopts=='a')
        res.euler = zeros([3,DTIdim]);
    end;
    for p = 1:DTIdim(3)
        if any(bch.dteigopts=='a')
            [evec eval euler] = ...
                dti_eig_decompose(bch.data(:,:,:,p));
        else
            [evec eval] = ...
                dti_eig_decompose(bch.data(:,:,:,p));
        end;
        if any(bch.dteigopts=='v')
            res.evec(:,:,:,:,p) = evec;
        end;
        if any(bch.dteigopts=='l')
            res.eval(:,:,:,p) = eval;
        end;
        if any(bch.dteigopts=='a')
            res.euler(:,:,:,p) = euler;
        end;
    end;
else
    IDTI = spm_vol(char(bch.dtimg));
    DTIdim=IDTI(1).dim(1:2);
    [p n e]=spm_fileparts(IDTI(1).fname);
    
    if ~isempty(regexp(n,'^((dt[1-6])|(D[x-z][x-z]))_.*', 'once'))
        n = n(5:end);
    end;
    
    cdir=['x','y','z'];
    
    if any (bch.dteigopts=='v')
        for j=1:3
            for k=1:3
                res.evec{(j-1)*3+k} = ...
                    fullfile(p,...
                    [sprintf('evec%d%s_',...
                    k,cdir(j)) n e]);
                vdescrip{(j-1)*3+k} = ...
                    sprintf('Eigenvector %d, %s component',...
                    k, cdir(j));
            end;
        end;
        Vevec = spm_create_vol(struct('fname',res.evec, ...
            'descrip',vdescrip, ...
            'dim',IDTI(1).dim(1:3), ...
            'dt',[spm_type('float32') spm_platform('bigend')], ...
            'mat',IDTI(1).mat,...
            'pinfo',[1 0 0]'));
    end;
    if any(bch.dteigopts=='l')
        ldescrip = cell(1,3);
        for j=1:3
            res.eval{j} = ...
                fullfile(p,[sprintf('eval%d_',j) n e]);
            ldescrip{j} = sprintf('Eigenvalue %d',j);
        end;
        Veval = spm_create_vol(struct('fname',res.eval, ...
            'descrip',ldescrip, ...
            'dim',IDTI(1).dim(1:3), ...
            'dt',[spm_type('float32') spm_platform('bigend')], ...
            'mat',IDTI(1).mat,...
            'pinfo',[1 0 0]'));
    end;
    if any(bch.dteigopts=='a')
        adescrip = cell(1,3);
        for j=1:3
            res.euler{j} = ...
                fullfile(p,[sprintf('euler%d_',j) n e]);
            adescrip{j}  = sprintf('Euler angle %d',j);
        end;
        Veuler = spm_create_vol(struct('fname',res.euler, ...
            'descrip',adescrip, ...
            'dim',IDTI(1).dim(1:3),...
            'dt',[spm_type('float32') spm_platform('bigend')], ...
            'mat',IDTI(1).mat,...
            'pinfo',[1 0 0]'));
    end;
    
    %-Start progress plot
    %-----------------------------------------------------------------------
    spm_progress_bar('Init', IDTI(1).dim(3),...
        'Tensor decomposition', 'planes completed');
    
    %-Loop over planes computing result Y
    %-----------------------------------------------------------------------
    
    for p = 1:IDTI(1).dim(3),
        B = inv(spm_matrix([0 0 -p 0 0 0 1 1 1]));
        
        X=zeros(6,DTIdim(1),DTIdim(2));
        for k = 1:6
            X(k,:,:) = spm_slice_vol(IDTI(k),B,DTIdim,0); % hold 0
        end;
        if any(bch.dteigopts=='a')
            [evec evals euler]=dti_eig_decompose(X);
        else
            [evec evals]=dti_eig_decompose(X);
        end;
        %-Write output image
        %----------------------------------------------------------------
        for n1=1:3
            if any(bch.dteigopts == 'v')
                for n2=1:3
                    Vevec((n1-1)*3+n2)=...
                        spm_write_plane(Vevec((n1-1)*3+n2), ...
                        squeeze(evec(n1,n2,:,:)),p);
                end;
            end;
            if any(bch.dteigopts == 'l')
                Veval(n1)=spm_write_plane(Veval(n1),...
                    squeeze(evals(n1,:,:)),p);
            end;
            if any(bch.dteigopts == 'a')
                Veuler(n1)=spm_write_plane(Veuler(n1), ...
                    squeeze(euler(n1,:,:)),p);
            end;
        end;
        
        spm_progress_bar('Set',p);
    end;
    spm_progress_bar('Clear')
end;
if nargout > 0
    if isfield(bch,'dtimg')
        ud = dti_get_dtidata(bch.dtimg{1});
        if any (bch.dteigopts=='v')
            for k = 1:numel(res.evec)
                dti_get_dtidata(res.evec{k}, ud);
            end
        end
        if any (bch.dteigopts=='a')
            for k = 1:numel(res.euler)
                dti_get_dtidata(res.euler{k}, ud);
            end
        end
    end
    varargout{1} = res;
else
    if isfield(bch,'data')
        assignin('base', 'res', res);
    end;
end;

function varargout=dti_eig_decompose(X)

% input formats:
% - 6-by-N[-by-M]
%
% output formats:
% - evec 3-by-3-by-N[-by-M]
% - eval 3-by-N[-by-M]
% - euler 3-by-N[-by-M]

szx=size(X);
ndx=ndims(X);
if (szx(1) ~= 6) || ~any(ndx==1:3)
    error([mfilename ': Wrong number of elements in tensor']);
end;

DTIdim = [1 1];
if ndx > 1
    DTIdim(1) = szx(2);
end;
if ndx > 2
    DTIdim(2) = szx(3);
end;

evec  = zeros(3,3,DTIdim(1),DTIdim(2));
evals = zeros(3,DTIdim(1),DTIdim(2));

msk   = squeeze(any(isnan(X))|any(isinf(X))|all(X==0));
if DTIdim(2)==1
    msk=msk';
end;

for k=1:DTIdim(1)
    for l=1:DTIdim(2)
        if msk(k,l) % find(isnan(X(:,k,l))|isinf(X(:,k,l)))|all(all(X(:,k,l)==0))
            e = NaN*ones(3,3);
            v = NaN*ones(1,3);
        else
            [re rv] = eig([X(1,k,l) X(2,k,l) X(3,k,l);...
                X(2,k,l) X(4,k,l) X(5,k,l);...
                X(3,k,l) X(5,k,l) X(6,k,l)]);
            
            % sort eigenvalues and -vectors
            tmp=diag(rv);
            [v ind]=sort(-abs(tmp));
            v=tmp(ind);
            e=re(:,ind);
            
            [mx ind] = max(abs(e));
            if sign(det(e))==-1 % make coordinate system right-handed
                if sign(e(ind(1),1))==-1
                    e(:,1) = -e(:,1);
                elseif sign(e(ind(2),2))==-1
                    e(:,2) = -e(:,2);
                else
                    e(:,3) = -e(:,3);
                end;
            else % right-handed, check for 2 negative "main vector" elements
                ne = double(sign([e(ind(1),1) e(ind(2),2) e(ind(3),3)])==-1);
                if sum(ne) == 2
                    ne=ones(3,1)*ne;
                    ne(ne==1)=-1;
                    ne(ne==0)=1;
                    e = e.*ne;
                end;
            end;
        end
        evec(:,:,k,l)=e;
        evals(:,k,l)=v; % nur v
    end;
end;

if nargout > 0
    varargout(1) = {evec};
end;
if nargout > 1
    varargout(2) = {evals};
end;
if nargout > 2
    euler=zeros(3,DTIdim(1),DTIdim(2));
    euler(2,:,:) = squeeze(asin(evec(1,3,:,:)));
    sel=(abs(euler(2,:,:))-pi/2).^2 < 1e-9;
    euler(1,sel) = 0;
    euler(3,sel) = atan2(-squeeze(evec(2,1,sel)), ...
        squeeze(-evec(3,1,sel)./evec(1,3,sel)));
    c = cos(euler(2,~sel))';
    euler(1,~sel) = atan2(squeeze(evec(2,3,~sel))./c, squeeze(evec(3,3,~sel))./c);
    euler(3,~sel) = atan2(squeeze(evec(1,2,~sel))./c, squeeze(evec(1,1,~sel))./c);
    %euler(euler<0) = euler(euler<0)+pi;
    
    varargout(3) = {euler};
end;
