function M=render
load(spm_select(1,'SPM.*mat','SPM.mat'));
load(spm_select(1,'fr.*mat','fr.mat'));
VM=spm_vol(spm_select(1,'.*img','Mask'));
fr.slicescuts={};
fr.surf{1}.quality=.2;
fr.surf{1}.data = load(fr.surf{1}.data );
f=figure(2);
delete(findobj(0,'tag','tbxrend_fancy_render'));
subplot(1,2,1);
ax=gca;
daspect([1 1 1]);
    axis image off;
    box on;
    rotate3d on;
    view(3);
set(ax,'tag','tbxrend_fancy_render','userdata',fr);
tbxrend_fancy_render('redraw');
cd(SPM.swd);
active=kron([1 0 1 0 1 0],ones(1,10));
for k=1:numel(active)
        fr.blobs{1} = SPM.xY.VY(k);
        fr.blobs{1}.VMean=SPM.Vbeta(7);
        fr.blobs{1}.VM = VM;
        fr.blobs{1}.min= -4;
        fr.blobs{1}.max= 8;
        fr.blobs{1}.scaling='minmax';
        fr.blobs{1}.interp=0;
        subplot(1,2,1);
        set(gca,'userdata',fr);
        tbxrend_fancy_render('redraw');
        disp(k);
        subplot(1,2,2);
        for l=1:10
                plot([0 0 active(k)*.2*sin(l/5*pi)],'linewidth',5, ...
                     'color',[~active(k) active(k) 0]);
                axis([1 3 -1 1]);axis off;
                pause(.001);
        
                M((k-1)*10+l)=getframe(f);
        end;
end;
save movie M
movie2avi(M,'motor.avi');