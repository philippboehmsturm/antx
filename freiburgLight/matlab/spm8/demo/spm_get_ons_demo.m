%% Time and other settings
TR         = 2;
SPM.nscan  = 300;
SPM.xBF.T  = 16;
SPM.xBF.T0 = 1;
SPM.xBF.dt = TR/SPM.xBF.T;
SPM.xBF.UNITS = 'scans';
% time axis - remember 32 bin offset
t=0:SPM.xBF.dt:(TR*SPM.nscan-SPM.xBF.dt);
% onsets (and duration for block)
onsets   = (10:20:SPM.nscan)';
duration = 10;
% onsets and time within block in time bins to mimic block design. Duration
% for each of the events is then 1/SPM.xBF.T
blk = (0:1/SPM.xBF.T:duration)';
time_within_block   = repmat(blk,size(onsets));
onsets_within_block = kron(onsets,ones(size(blk))) + time_within_block;
%% Expected responses - event
% duration 0
SPM.Sess(1).U(1).name = {'event - duration 0'};
SPM.Sess(1).U(1).ons  = onsets;
SPM.Sess(1).U(1).dur  = 0;
% transform onsets to stick function - ask for parametric modulation
SPM.Sess(1).U=spm_get_ons(SPM,1);
% plot each parametric modulation
npar = size(SPM.Sess(1).U(1).u,2);
fpm(1) = figure('name',SPM.Sess(1).U(1).name{1});
for k = 1:npar
    ax = subplot(npar,1,k);
    plotsf(ax,t,SPM.Sess(1).U(1).u(33:end,k));
end
%% Expected responses - block
% duration 10
SPM.Sess(1).U(2).name = {'block - duration 10'};
SPM.Sess(1).U(2).ons  = onsets;
SPM.Sess(1).U(2).dur  = duration;
% transform onsets to stick function - ask for parametric modulation
SPM.Sess(1).U=spm_get_ons(SPM,1);
% plot each parametric modulation
npar = size(SPM.Sess(1).U(2).u,2);
fpm(2) = figure('name',SPM.Sess(1).U(2).name{1});
for k = 1:npar
    ax = subplot(npar,1,k);
    plotsf(ax,t,SPM.Sess(1).U(2).u(33:end,k));
end
%% Expected responses - mimic block
% onsets for each time bin
% duration 1/SPM.xBF.T (length of time bin)
SPM.Sess(1).U(3).name = {'block - duration 10 - selfmade'};
SPM.Sess(1).U(3).ons  = onsets_within_block;
SPM.Sess(1).U(3).dur  = 1/SPM.xBF.T;
% transform onsets to stick function - ask for parametric modulation
SPM.Sess(1).U=spm_get_ons(SPM,1);
% plot each parametric modulation
npar = size(SPM.Sess(1).U(3).u,2);
fpm(3) = figure('name',SPM.Sess(1).U(3).name{1});
for k = 1:npar
    ax = subplot(npar,1,k);
    plotsf(ax,t,SPM.Sess(1).U(3).u(33:end,k));
end
%% Expected responses - mimic block, custom parametric modulation
% onsets for each time bin
% duration 1/SPM.xBF.T (length of time bin)
% parametric mod within block
SPM.Sess(1).U(4).name = {'block - duration 10 - selfmade within block pmod'};
SPM.Sess(1).U(4).ons  = onsets_within_block;
SPM.Sess(1).U(4).dur  = 1/SPM.xBF.T;
SPM.Sess(1).U(4).P.name = 'other';
SPM.Sess(1).U(4).P.P    = time_within_block;
SPM.Sess(1).U(4).P.h    = 2;
SPM.Sess(1).U=spm_get_ons(SPM,1);
% plot each parametric modulation
npar = size(SPM.Sess(1).U(4).u,2);
fpm(4) = figure('name',SPM.Sess(1).U(4).name{1});
for k = 1:npar
    ax = subplot(npar,1,k);
    plotsf(ax,t,SPM.Sess(1).U(4).u(33:end,k));
end
%% Expected BOLD response
% BOLD response - get hrf
SPM.xBF.name = 'hrf';
SPM.xBF = spm_get_bf(SPM.xBF);
% BOLD response - convolve stick functions with hrf
[X Xnames Fc] = spm_Volterra(SPM.Sess(1).U, SPM.xBF.bf, 1);
% plot convolved responses - add to corresponding stick function display
for l = 1:numel(Fc)
    figure(fpm(l));
    npar = numel(Fc(k).i);
    for k = 1:npar
        ax = subplot(npar,1,k);
        hold(ax,'on');
        plot(ax,t,X(33:end,Fc(l).i(k)),'r')
    end
end
% design-Matrix like
figure('name','Design matrix representation');imagesc(spm_DesMtx('Sca',X(33:end,:),Xnames));
colormap gray
%% Observed responses
% 1st response - event at the beginning of each block
% 2nd response - block
% 3rd response - block, decaying
resp(:,1) = X(:,Fc(1).i)*[1 0 0]';          rname{1} = 'event - const';
resp(:,2) = X(:,Fc(2).i)*[1 0 0]';          rname{2} = 'block - const';
resp(:,3) = X(:,Fc(2).i)*[1 -1 0]'/sqrt(2); rname{3} = 'block - decay';
figure('name','Observed responses');plot(spm_DesMtx('sca',resp))
nresp = size(resp,2);
% Fit & plot them with respect to the different models
for l = 1:numel(Fc)
    betas = X(:,Fc(l).i)\resp;
    ffr(l) = figure('name',Xnames{Fc(l).i(1)});
    bpanel = uipanel(ffr(l),'position',[0 0 .25 1],'title','betas');
    fpanel = uipanel(ffr(l),'position',[.25 0 .75 1],'title','fitted response');
    for k = 1:nresp
        bsub = subplot(nresp,1,k,'parent',bpanel);
        bar(betas(:,k),'parent',bsub);
        fsub = subplot(nresp,1,k,'parent',fpanel);
        plot(fsub,t,resp(33:end,k),'r',t,X(33:end,Fc(l).i)*betas(:,k));
        ylabel(fsub,rname{k});
    end
end