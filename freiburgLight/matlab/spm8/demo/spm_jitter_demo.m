%% Time and other settings
TR         = 2;
SPM.nscan  = 300;
SPM.xBF.T  = 16;
SPM.xBF.T0 = 1;
SPM.xBF.dt = TR/SPM.xBF.T;
SPM.xBF.UNITS = 'scans';
% time axis - remember 32 bin offset
t=0:SPM.xBF.dt:(TR*SPM.nscan-SPM.xBF.dt);
% onsets in sync with TR
s_onsets = (0:10:SPM.nscan)';
% onset asynchrony with respect to TR
soa = linspace(0,1-1/SPM.xBF.T,numel(s_onsets))';
a_onsets = s_onsets+soa;
%% Expected responses - sync event
% duration 0
SPM.Sess(1).U(1).name = {'event - duration 0'};
SPM.Sess(1).U(1).ons  = s_onsets;
SPM.Sess(1).U(1).dur  = 0;
SPM.Sess(1).U(1).P.name = 'none';
%% Expected responses - async event
% duration 0
SPM.Sess(1).U(2).name = {'event - duration 0'};
SPM.Sess(1).U(2).ons  = a_onsets;
SPM.Sess(1).U(2).dur  = 0;
SPM.Sess(1).U(2).P.name = 'none';
% transform onsets to stick function
SPM.Sess(1).U=spm_get_ons(SPM,1);
%% distribution of onsets with respect to peri-stimulus time
fsamp = figure('name','peri-stimulus sampling');
asamp = axes('parent',fsamp);
plot(asamp,SPM.Sess(1).U(1).pst,ones(size(SPM.Sess(1).U(1).pst)),'rx',...
    SPM.Sess(1).U(2).pst,2*ones(size(SPM.Sess(1).U(2).pst)),'rx');
set(asamp, 'YTick',[1 2], 'YtickLabel',{'sync','async'},'Ylim',[.5 2.5])
xlabel(asamp,'peri-stimulus time (sec)')
%% Expected BOLD response
% BOLD response - get hrf
SPM.xBF.name = 'hrf';
SPM.xBF = spm_get_bf(SPM.xBF);
% BOLD response - convolve stick functions with hrf
[X Xnames Fc] = spm_Volterra(SPM.Sess(1).U, SPM.xBF.bf, 1);
cbin = 10;
bins = (0:SPM.nscan-1)*SPM.xBF.T;
fhrf = figure('name','hrf time course');
chr  = uipanel(fhrf,'position',[0 0 .7 1], 'title', 'Experiment');
clr  = uipanel(fhrf,'position',[.7 0 .3 1], 'title', 'PST sampling');
for k = 1:numel(Fc)
    ax = subplot(2,1,k,'parent',chr);
    plot(ax,t,X(33:end,Fc(k).i(1)),'r-',t(bins+cbin),X(32+bins+cbin,Fc(k).i(1)),'g.');
    ax = subplot(2,1,k,'parent',clr);
    plot(ax,SPM.Sess(1).U(k).pst+(cbin-1)/SPM.xBF.T,X(32+bins+cbin,Fc(k).i(1)),'g.');
    axis(ax,[0 20 -.1 .3])
end
%% Expected responses - sync event, shifted by 1/SPM.xBF.T
% duration 0
SPM.Sess(1).U(3).name = {'event - duration 0'};
SPM.Sess(1).U(3).ons  = s_onsets+1/SPM.xBF.T;
SPM.Sess(1).U(3).dur  = 0;
SPM.Sess(1).U(3).P.name = 'none';
%% Expected responses - async event, shifted by 1/SPM.xBF.T
% duration 0
SPM.Sess(1).U(4).name = {'event - duration 0'};
SPM.Sess(1).U(4).ons  = a_onsets+1/SPM.xBF.T;
SPM.Sess(1).U(4).dur  = 0;
SPM.Sess(1).U(4).P.name = 'none';
% transform onsets to stick function
SPM.Sess(1).U=spm_get_ons(SPM,1);
% BOLD response - convolve stick functions with hrf
[X Xnames Fc] = spm_Volterra(SPM.Sess(1).U, SPM.xBF.bf, 1);
for k = 1:2
    ax = subplot(2,1,k,'parent',chr);
    plot(ax,t,X(33:end,Fc(k).i(1)),'r-',t(bins+cbin),X(32+bins+cbin,Fc(k).i(1)),'g.',...
        t,X(33:end,Fc(k+2).i(1)),'b-',t(bins+cbin),X(32+bins+cbin,Fc(k+2).i(1)),'m.');
    ax = subplot(2,1,k,'parent',clr);
    plot(ax,SPM.Sess(1).U(k).pst+(cbin-1)/SPM.xBF.T,X(32+bins+cbin,Fc(k).i(1)),'g.',...
        SPM.Sess(1).U(k).pst+(cbin-1)/SPM.xBF.T,X(32+bins+cbin,Fc(k+2).i(1)),'m.');
    axis(ax,[0 20 -.1 .3])
end
