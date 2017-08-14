function spm_conv_demo
global defaults;
defaults.stats.fmri.t=16;
RT=.1;
[hrf phrf]=spm_hrf(RT);
hrf=hrf/max(hrf);

t=0:1/defaults.stats.fmri.t:500;
scans=zeros(size(t));
scans(1:defaults.stats.fmri.t:end)=1;


f=figure(2);
clf;

axscans=axes('position',[.3 .1 .6 .2]);
axons=axes('position',[.3 .4 .6 .2]);
axconv=axes('position',[.3 .7 .6 .2]);

plot_sticks(axscans,t,scans);
title('Scan time points');

for k=200:-2:40
        ons=zeros(size(t));
        ons(50+(1:k:20*k))=1;
        plot_sticks(axons,t,ons);
        chrf=conv(ons,hrf);
        chrf=chrf(1:numel(t));
        chrf=chrf/max(chrf);
        plot(axconv,t,chrf);
        pause(.1);
end

function h=plot_sticks(ax,t,x)
x1=find(x);

tn=kron(t(x1),[1 1 1]);
xn=kron(x(x1),[0 1 0]);
h=plot(ax,tn,xn);
axis(ax,[min(t) max(t) min(x) max(x)]);