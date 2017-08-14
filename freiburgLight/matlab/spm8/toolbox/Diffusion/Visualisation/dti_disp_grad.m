function varargout=dti_disp_grad(bch)
% Visualise gradient direction vectors
%
% Visualise a set of gradient direction vectors. This is useful to 
% compare gradient directions between measurements which may differ due 
% to changes in measurement protocols, motion correction etc.
%
% Batch processing:
% FORMAT res=dti_disp_grad(bch)
% ======
%/*\begin{itemize}*/
%/*\item*/ Input argument:
%   bch struct with fields
%/*\begin{description}*/
%/*\item[*/       .srcimgs/*]*/ cell array of file names to get diffusion information
%/*\item[*/       .option/*]*/  one or both of 
%/*\begin{description}*/
%/*\item[*/                v/*]*/ displays a vector for each direction, b 
%                  value is encoded as vector length
%/*\item[*/                d/*]*/ displays direction density colour coded on a unit sphere
%/*\end{description}*/
%/*\item[*/       .axbgcol, .fgbgcol/*]*/ axis and figure background colours
%/*\item[*/       .res/*]*/     sphere resolution
%/*\end{description}*/
%/*\item*/ Output argument:
%   res struct with fields
%/*\begin{description}*/
%/*\item[*/       .vf/*]*/  figure handle for vector plot
%/*\item[*/       .vax/*]*/ axis handle for vector plot
%/*\item[*/       .l/*]*/   line handles
%/*\item[*/       .df/*]*/  figure handle for direction plot
%/*\item[*/       .dax/*]*/ axis handle for direction plot
%/*\item[*/       .s/*]*/   surface handle for sphere
%/*\item[*/       .cb/*]*/  handle for colorbar
%/*\end{description}\end{itemize}*/
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_disp_grad.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Visualise gradient directions';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

for k = 1:numel(bch.srcimgs)
        tmp(k) = dti_get_dtidata(bch.srcimgs{k});
end;
g = cat(1,tmp.g);
lg= sum(g.^2,2);
lg(lg == 0) = eps;
b = cat(1,tmp.b);
b1= b.*lg;
g1= g./repmat(sqrt(lg),[1 3]);
g1(~isfinite(g1)) = 0;
if any(bch.option == 'v')
        res.vf=figure;
        res.vax=axes;
        set(res.vax, 'color',bch.axbgcol, 'xcolor',[.9 .7 .7],...
                     'ycolor',[.7 .9 .7], 'zcolor',[.7 .7 .9], 'box','on',...
                     'xlim',[-max(b1) max(b1)], ...
                     'ylim',[-max(b1) max(b1)], ...
                     'zlim',[-max(b1) max(b1)]);  
        set(res.vf, 'color',bch.fgbgcol, 'InvertHardCopy','off');
        view(3);
        for k=1:max(numel(bch.srcimgs))
                try
                        res.l(k)=line([0 b1(k)*g1(k,1)],...
                                      [0 b1(k)*g1(k,2)], ...
                                      [0 b1(k)*g1(k,3)],...
                                      'color',abs(g1(k,:)), 'marker','o', 'linewidth',3);
                        hold on; 
                end;
        end;
        axis square;
        hold off;grid on;
        xlabel('X');ylabel('Y');zlabel('Z');
end;
if any(bch.option == 'd')
        res.df=figure;
        res.dax=axes;
        view(3);
        [x y z] = sphere(bch.res);
        res.s = surf(x, y, z, ...
                     reshape(sum(abs(g1*[x(:) y(:) z(:)]')),size(x)),...
                     'FaceColor','interp', 'EdgeColor','none');
        set(res.dax, 'color',bch.axbgcol, 'xcolor',[.9 .7 .7],...
                     'ycolor',[.7 .9 .7], 'zcolor',[.7 .7 .9], 'box','on')
        set(res.df, 'color',bch.fgbgcol, 'InvertHardCopy','off');
        axis square;
        xlabel('X');ylabel('Y');zlabel('Z');    
        res.cb = colorbar;
        set(res.cb, 'box','off', 'xcolor','w', 'ycolor','w');
        ylabel(res.cb,'direction distribution');
end;
if nargout>0
        varargout{1} = res;
end;
