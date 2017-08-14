function spm_modelvar_demo(X,data,betas,fullcols,redcols,scans,sepfig)
% Plot fit of a model to some data
% X     - design matrix (e.g. SPM.xX.X or SPM.xX.xKXs.X)
% data  - time series for a voxel (from eg extract, plot options)
% betas - beta values for this voxel
% fullcols, redcols, scans - index vectors for regressors (full and reduced model) and scans to consider
% sepfig - flag to decide whether separate figures for each plot should be
% created
% output: mov - Matlab movie

% display data

extcols=setdiff(fullcols,redcols);

fullfit=X(scans,fullcols)*betas(fullcols);
extfit=X(scans,extcols)*betas(extcols);
extfitNaN=extfit;
extfitNaN(extfitNaN==0)=NaN;
redfit=X(scans,redcols)*betas(redcols);
redfitNaN=redfit;
redfitNaN(redfitNaN==0)=NaN;

fext=figure;
set(fext,'units','normalized');

if sepfig
    set(fext,'position',[0 0 1 1/3]);
else
    axext=axes('pos',[.05 .68 .9 .25]);
    set(gca,'xtick',[]);
end;
plot(data(scans),'rd','markerf','r');
hold on
fill([1 1:numel(scans) numel(scans)],[0; extfit; 0],[.7 1 .7],'edgecolor','none');
plot(extfitNaN,'g','linewidth',3);
plot(redfitNaN,'b','linewidth',3);
title('Extra variance','fonts',16,'fontw','bold');
axis tight;
axlim=axis;
set(gca,'ytick',[]);

if sepfig
    fred=figure;
    set(fred,'units','normalized','position',[0 1/3 1 1/3]);
else
    axred=axes('pos',[.05 .36 .9 .25]);
    set(gca,'xtick',[]);
end;
plot(data(scans),'rd','markerf','r');
hold on;
fill([1 1:numel(scans) numel(scans):-1:1 1],[0; data(scans); redfit(end:-1:1); 0],'r','edgecolor','none')
plot(extfit,'linewidth',3,'color',[.7 .7 .7]);
plot(redfit,'b','linewidth',3);

axis(axlim);
set(gca,'ytick',[]);
title('Error variance of reduced model','fonts',16,'fontw','bold');

if sepfig
    ffull=figure;
    set(ffull,'units','normalized','position',[0 2/3 1 1/3]);
else
    axfull=axes('pos',[.05 .04 .9 .25]);
end;
plot(data(scans),'rd','markerf','r');
hold on;
fill([1 1:numel(scans) numel(scans):-1:1 1],[0; data(scans); fullfit(end:-1:1); 0],'r','edgecolor','none')
plot(extfitNaN,'g','linewidth',3);
plot(redfitNaN,'b','linewidth',3);
axis(axlim);
set(gca,'ytick',[]);
title('Error variance of full model','fonts',16,'fontw','bold');
