function varargout = dti_extract_dirs(bch)
% Batch processing:
% FORMAT res=dti_extract_dirs(bch)
% ======
%/*\begin{itemize}*/
%/*\item*/ Input argument:
%   bch struct with fields
%/*\begin{description}*/
%/*\item[*/       .srcimgs/*]*/ cell array of file names
%/*\item[*/       .ref/*]*/     A struct with one field of 'image', 'scanner' or 
%                'snparams'. Determines the reference system for 
%                extracted gradient information. The routine assumes 
%                that all images have the same orientation and applies 
%                the inverse rotation, zoom and shearing part of the 
%                affine transformation of the first image or the 
%                normalisation parameters to the gradient directions. 
%                If 'snparams' is given, this needs to be a cellstring 
%                containing the name of the sn.mat file.
%/*\item[*/       .saveinf/*]*/ Save extracted b- and g-values to text files? (0 
%                no, 1 yes)
%/*\item[*/       .sep/*]*/     separate antiparallel directions (0 no, 1 yes)
%/*\item[*/       .ltol/*]*/    b value tolerance to treat as identical - set this 
%                to the b value rounding error
%/*\item[*/       .dtol/*]*/    cosine between gradient vectors to treat directions 
%                as identical
%/*\end{description}*/
%/*\item*/ Output arguments:
%   res struct with fields
%/*\begin{description}*/
%/*\item[*/       .dirsel/*]*/ ndir-by-nscan logical array of flags that mark 
%               images with similar diffusion weighting - 
%               deprecated. One should use the result of 
%               unique([res.ubj, res.ugj],'rows') instead.
%/*\item[*/       .b/*]*/      ndir-by-1 vector of distinct b values for bval/dir 
%               combinations 
%/*\item[*/       .g/*]*/      ndir-by-3 array of distinct directions for bval/dir 
%               combinations
%/*\item[*/       .ub/*]*/     nb-by-1 vector of distinct b values over all 
%               directions
%/*\item[*/       .ug/*]*/     ndir-by-3 array of distinct directions over all bvals
%/*\item[*/       .allb/*]*/   nimg-by-1 vector of all b values
%/*\item[*/       .allg/*]*/   nimg-by-3 array of all directions
%/*\item[*/       .bfile/*]*/  name of text file with b-values
%/*\item[*/       .gfile/*]*/  name of text file with g-values
%/*\end{description}\end{itemize}*/
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_extract_dirs.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Extract DTI dirs';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

fprintf('Reading diffusion information\n');
V = spm_vol(bch.srcimgs{1});
M1 = V.mat;
for k = 1:numel(bch.srcimgs)
        ud(k) = dti_get_dtidata(bch.srcimgs{k});
end;

if isfield(bch.ref, 'snparams')
        M =dti_get_snaffine( bch.ref.snparams{1});
elseif isfield(bch.ref, 'refscanner')
        M = eye(4);
elseif isfield(bch.ref, 'refimage')
        prms = spm_imatrix(inv(M1));
        M = spm_matrix([0 0 0 prms(4:6) sign(prms(7:9))]);
else
        error('Missing coordinate reference specification!');
end;

G = (M(1:3,1:3)*(cat(1,ud.g).*repmat(cat(1,ud.b),[1 3]))')';
res.allb = sqrt(sum(G.*G,2));
G(res.allb>0,:) = G(res.allb>0,:)./repmat(res.allb(res.allb>0),1,3);
res.allg = G;

if bch.saveinf
        [p n e]   = spm_fileparts(bch.srcimgs{1});
        res.bfile = fullfile(p,[n '_b.txt']);
        res.gfile = fullfile(p,[n '_g.txt']);
        tmpb = res.allb';
        save('-ascii','-double', res.bfile, 'tmpb');
        tmpg = res.allg';
        save('-ascii','-double', res.gfile, 'tmpg');
end;

fprintf('# unique b values:            ');
bb=repmat(round(res.allb/bch.ltol)*bch.ltol,1,size(G,1));
bb=abs(bb-bb');
[res.ub res.ubi res.ubj] = unique(round(res.allb/bch.ltol)*bch.ltol);
fprintf('%d\n', size(res.ub,1));

fprintf('# unique gradient directions: ');
if bch.sep
        GG=G*G';
else
        GG=abs(G*G');
end;

[tmp res.ugi res.ugj] = unique(GG>=bch.dtol,'rows');
res.ug = res.allg(res.ugi,:);
fprintf('%d\n', size(res.ug,1));

% old dirsel stuff - could be done by combining ubj and ugj
res.dirsel = unique(GG>=bch.dtol & bb==0,'rows');
% dirsel will be sorted, so any b0 images will give a only-zero first row
% in dirsel:
if ~any(res.dirsel(1,:))
        res.dirsel(1,:)= ~any(res.dirsel,1);
end;

for k=1:size(res.dirsel,1) 
        ind=find(res.dirsel(k,:)); 
        res.b(k,1)=res.allb(ind(1));
        res.g(k,:)=res.allg(ind(1),:);
end;

if nargout == 0
        fprintf('extracted information saved into workspace variable ''res''\n');
        assignin('base','res',res);
        disp(res);
end;
if nargout > 0
        varargout{1} = res;
end;
