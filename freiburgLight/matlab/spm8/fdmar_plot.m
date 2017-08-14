%need:
%obj.X --> data
%obj.res --> residuals from glm 
%obj.resgaus --> gaussian distrubuted res
%obj.stimu --> stimu of the experiment
%obj.resar --> residuals of the ar fit
%obj.arspek --> theoretical spektrum build by parameter vector A
function fdmar_plot(obj,figname)
scrsz = get(0,'ScreenSize');
h=figure('Name','ar fit of the glm residuals','Position',[1 1 scrsz(3)/2 scrsz(4)/2]);

%plot data and residuals
subplot(3,2,1);
plot(obj.X,'b')
hold on
plot(obj.res,'r')
plot(obj.stimu,'g')
hold off
title('RAW-data')
legend('RAW-data','GLM-residuals','Location','Best')
%plot qqplot of resgaus
subplot(3,2,2);
plot(sort(obj.res),sort(randn(1,length(obj.res))),'*')
title('qq-Plot glm-residuals')
%plot residual, estimated residual and residuals of the ar fit
subplot(3,2,3);
plot(obj.resar(1:401),'r')
hold on
plot(obj.resest(1:401),'g')
plot(obj.resgaus(obj.order+1:obj.order+401),'b')
hold off
xlim([0,401])
legend('ResAR','ResEst','ResGLM', 'Location','Best')
%plot periodogramm of the residuals of the ar fit
subplot(3,2,4);
periodogram(obj.resar)
ylim([-100,100])
title('residuals arfit')
%plot periodogramm of the gaussian glm residuals
subplot(3,2,5);
periodogram(obj.resgaus)
ylim([-100,100])
title('spectrum glm+gaus residuals')
%plot theoretical ar spectrum
subplot(3,2,6);
semilogy(obj.arspek)
title('theoretical spectrum of est. ar-parameter')
xlim([0,1001])

if nargin > 1
    saveas(h,figname);
end
end