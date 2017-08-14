function mov=spm_modelfit_demo(X,data,betas,cols,scans,sumfit,betatitle)
% Plot fit of a model to some data
% X     - design matrix (e.g. SPM.xX.X or SPM.xX.xKXs.X)
% data  - time series for a voxel (from eg extract, plot options)
% betas - beta values for this voxel
% cols, scans - index vectors for regressors and scans to consider
% sumfit - Flag to indicate whether individual regressors or summary
%          regressor will be plotted (individual == 0, summary > 0).
%          For more than 3-4 regressors, summary plots are more readable.
% output: mov - Matlab movie

% display data
ffit=figure;
set(ffit,'units','normalized');

axfit=axes('pos',[.05 .55 .6 .35]);

plot(data(scans),'rd','markerf','r');
hold on
fits=zeros(numel(scans),numel(cols));
lb=plot(fits,'linewidth',3);
lmx=[];
title('Data & Fit','fonts',16,'fontw','bold');
axis tight;
axfitlim=axis;
set(gca,'xtick',[]);
axerr=axes('pos',[.05 .05 .6 .35]);

plot(data(scans),'rd','markerf','r');
hold on;
le=plot(data(scans),'linewidth',3,'color',[.7 .7 .7]);
axis tight;
axerrlim=axis;
title('Data & Residuals','fonts',16,'fontw','bold');

cbetas=zeros(numel(cols),1);
axbetas=axes('position',[.7 .05 .25 .85]);
axbetaslim=[0.5 numel(cols)+.5 0 max(X(scans,cols)*betas(cols))];
axis(axbetaslim);
box on;
set(gca,'xtick',[]);
title(betatitle,'fonts',16,'fontw','bold');
lbs=[];

mov(1)=getframe(ffit);

for c=1:numel(cols)
    for k=0:.05*betas(cols(c)):betas(cols(c))
        cbetas(c)=k;
        delete(lb);
        delete(lmx);
        fits(:,c)=k*X(scans,cols(c));
        [mxfits mxind] = max(fits);
        if sumfit
            lb=plot(axfit,sum(fits,2),'linewidth',3);
        else
            fitsplot=fits;
%           fitsplot(fitsplot==0)=NaN;
            lb=plot(axfit,fitsplot,'linewidth',3);
        end;
        lmx=line([1;1]*mxind,[zeros(size(mxfits));mxfits],'linewidth',3);
        axis(axfitlim);
        delete(le);
        le=plot(axerr,data(scans)-sum(fits,2),'linewidth',3,'color',[.7 .7 .7]);
        axis(axerrlim);
        delete(lbs);
        lbs=line([1;1]*(1:numel(mxfits)),[zeros(size(mxfits));mxfits],'linewidth',30,'parent',axbetas);
        axis(axbetaslim);
        set(axbetas,'xtick',[]);
        title(axbetas,betatitle,'fonts',16,'fontw','bold');
        mov(end+1)=getframe(ffit);
    end;
end