function spm_hrf_timeshift_demo
%% Modelling time shifts in hemodynamic responses
% In some situations, the time course of the canonical hrf might not fit
% the observed time course. In particular, the observed time-to-peak might
% vary between different areas of the brain (or different event types in
% the same brain area).
%
% This demo shows the strengths and limitations of the commonly used basis
% function sets in capturing time-shifted responses.

%% General timing constants
% dt is the time resolution (in seconds) of the generated hrf.
dt = .05;

%% Create response
% A canonical HRF response is created and shifted in time.
xBFr.name = 'hrf';
xBFr.dt   = dt;
xBFr      = spm_get_bf(xBFr);

%% Create shifted responses
% maximum shift (in +/- sec)
mxshift = 5;
ts = -mxshift:dt:mxshift;
npad = mxshift/dt;
lresp  = npad+size(xBFr.bf,1);
sresp  = zeros(lresp,2*npad+1);
for k = 1:(2*npad+1)
    bflen = min(size(xBFr.bf,1), lresp-k);
    sresp(k:(k-1+bflen),k) = xBFr.bf(1:bflen,1);
end

%% Get basis function set
% SPM uses spm_get_bf to obtain a basis function set for a single, zero
% length event. This basis function set is then used to create the expected
% response time courses. In this demo, we assume a single, zero length
% event at t = 0. We want to model faster and slower responses, therefore
% internal demo time is running from -2 sec to 32 sec (the length of the
% canonical hrf). Plots always start at t = 0, however.
SPM.xBF.dt   = dt;
SPM.xBF      = spm_get_bf(SPM.xBF);
% pad canonical basis function with zeros for time before event
pbf = zeros(lresp, size(SPM.xBF.bf,2));
pbf(npad+(1:size(SPM.xBF.bf,1)),:) = SPM.xBF.bf;
% truncate to length of shifted response
pbf = pbf(1:lresp,:);
ishrftime = ~isempty(regexpi(SPM.xBF.name, '^hrf.*time'));
% post-event time
t = 0:SPM.xBF.dt:(lresp-npad-1)*SPM.xBF.dt;
%% Solve
% solve for regression weights wrt basis set - in real SPM, this would be
% done in spm_spm.
betas = pbf\sresp;
% fitted response and error of full model
fresp = pbf*betas;
err   = fresp - sresp;
ssq   = sum(err.^2);
if ishrftime
    % fitted response of HRF only
    fresp1 = pbf(:,1)*betas(1,:);
end
%% Time to peak and amplitude
% For the shifted response, this is a the same as the time shift
% introduced. For the fitted response, it depends on the basis set used.
% For hrf+derivative, it is similar to the real time shift only in a small
% interval around zero time shift.
[samp stmx] = max(sresp);
[famp ftmx] = max(fresp);
if ishrftime
    [famp1 tmp] = max(fresp1);
end
sttp = t(stmx-npad);
fttp = t(ftmx-npad);
%% Interpretation of parameters for hrf+derivative
% The parameters of the hrf basis set can be interpreted as \Delta t and be
% used to fit a time shift function.
if ishrftime
    %% dt
    % This is the ratio between beta2 and beta1.
    dt = betas(2,:)./betas(1,:);
    %% Fit parameters for function fttp = f(dt)
    % To be able to estimate ttp from the fitted betas, a sigmoid function is
    % fitted to the simulated ttp of the fitted responses.
    l = fminsearch(@(x)ttpfit(x,dt,fttp),[1 1 1]);
    fttpfit=l(1)./(1+exp(l(2)*ts))+l(3);
end
%% Set up figure
figname = sprintf('%s - %s', mfilename, SPM.xBF.name);
f = findobj(0,'tag',figname);
if isempty(f)
    f = figure('tag',figname,'name',figname,'Numbertitle','off');
end
clf(f);
set(f,'position',get(0,'ScreenSize'));
% current time step
cs = 100;
% legend handles and legends
hleg  = [];
hlstr = {};
%% Plot betas
axbetas = axes('parent',f, 'position',[.01 .05 .23 .26]);
bar(betas(:,cs),'parent',axbetas)
set(axbetas,'tag','axbetas');
%% Plot time to peak over timeshift
axttp = axes('parent',f, 'position',[.26 .05 .23 .26]);
plot(axttp,ts,[sttp;fttp]);
if ishrftime
    hold(axttp, 'on');
    hleg(end+1)  = plot(axttp,dt,fttpfit,'r');
    hlstr{end+1} = sprintf('%0.2f./exp(%0.2f*ts))+%0.2f',l(1),l(2),l(3));
end
axlim = axis(axttp);
line([ts(cs) ts(cs)],axlim([3 4]),'parent',axttp,'color','k','tag','tsline');
xlabel(axttp,'Real response - time shift');
ylabel(axttp,'Time to peak');
% set update function, hit test
set(axttp,'ButtonDownFcn',@update_lines);
set(allchild(axttp),'HitTest','off');
%% Plot dt over timeshift
if ishrftime
    axdt = axes('parent',f, 'position',[.51 .05 .23 .26]);
    plot(axdt,ts, [-ts; dt]);
    axlim = axis(axdt);
    line([ts(cs) ts(cs)],axlim([3 4]),'parent',axdt,'color','k','tag','tsline');
    xlabel(axdt,'Real response - time shift');
    ylabel(axdt,'\Delta t');
    % set update function, hit test
    set(axdt,'ButtonDownFcn',@update_lines);
    set(allchild(axdt),'HitTest','off');
else
    axdt = [];
end
%% Plot fitted amplitudes over timeshift
axamp = axes('parent',f,'position',[.76 .05 .23 .26]);
if ishrftime
    set(axamp,'colororder',[0 0 1; 0 .5 0;0 .5 0]);
    hold(axamp, 'on');
    tmp = plot(axamp,ts,samp,'-',ts,famp,'-',ts,famp1,'--');
    hold(axamp, 'off');
    hleg(end+1)  = tmp(3);
    hlstr{end+1} = 'Fitted response HRF only';
else
    plot(axamp,ts,[samp;famp]);
end
axlim = axis(axamp);
line([ts(cs) ts(cs)],axlim([3 4]),'parent',axamp,'color','k','tag','tsline');
xlabel(axamp,'Real response - Time shift');
ylabel(axamp,'Peak amplitude');
% set update function, hit test
set(axamp,'ButtonDownFcn',@update_lines);
set(allchild(axamp),'HitTest','off');
%% plot fitted response - coloured with error
axfit = axes('parent',f,'position',[.05 .4 .47 .47]);
hfresp = surf(axfit,t,ts,fresp(npad+1:end,:)',abs(err(npad+1:end,:)'),'linestyle','none');
colormap(axfit,'gray')
xlabel(axfit,'Post-event time')
ylabel(axfit,'Time shift')
zlabel(axfit,'Response')
title(axfit,'Fitted response')
% add canonical response
hold(axfit, 'on');
hleg(end+1)  = line(t,ts(cs)*ones(size(t)),sresp(npad+1:end,cs),'parent',axfit,'color','b','linewidth',5,'tag','lsresp');
hlstr{end+1} = 'Real HRF';
%% plot real response - coloured with error
axreal = axes('parent',f,'position',[.53 .4 .47 .47]);
hsresp = surf(axreal,t,ts,sresp(npad+1:end,:)',abs(err(npad+1:end,:)'),'linestyle','none');
colormap(axreal,'gray')
xlabel(axreal,'Post-event time')
ylabel(axreal,'Time shift')
zlabel(axreal,'Response')
title(axreal,'Real response')
% add fitted response
hold(axreal, 'on');
hleg(end+1)  = line(t,ts(cs)*ones(size(t)),fresp(npad+1:end,cs),'parent',axreal,'color',[0 .5 0],'linewidth',5,'tag','lfresp');
hlstr{end+1} = 'Fitted HRF';
% set legend, let MATLAB figure out its size
legend(hleg(end:-1:1),hlstr(end:-1:1),'position', [0.5    0.9    0    0])
hl=linkprop([axfit axreal],'View');
set(f,'userdata',struct('links',hl,'t',t,'npad',npad,'ts',ts,'fresp',fresp,'sresp',sresp,'betas',betas))

function update_lines(ob,ev)
ud = get(gcbf, 'userdata');
cp = get(ob, 'CurrentPoint');
[tmp cs] = min(abs(ud.ts-cp(1,1)));
tslines = findobj(gcbf, 'tag','tsline');
set(tslines,'xdata',[ud.ts(cs),ud.ts(cs)]);
lfresp  = findobj(gcbf, 'tag','lfresp');
set(lfresp,'ydata',ud.ts(cs)*ones(size(ud.t)),'zdata',ud.fresp(ud.npad+1:end,cs));
lsresp  = findobj(gcbf, 'tag','lsresp');
set(lsresp,'ydata',ud.ts(cs)*ones(size(ud.t)),'zdata',ud.sresp(ud.npad+1:end,cs));
axbetas = findobj(gcbf,'tag','axbetas');
bar(ud.betas(:,cs),'parent',axbetas)
set(axbetas,'tag','axbetas');

function err = ttpfit(l,t,y)
% This function computes the error between data y and a sigmoid function
% parameterised by l(1:3).
y1 = l(1)./(1+exp(l(2)*t))+l(3);
err = norm(y1-y);
