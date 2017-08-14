function plot_parameters(P)
% excerpt from spm_realign.m
% plot realignment params without estimating them 
fg=spm_figure('FindWin','Graphics');
ls = {'.','-','-.','--',':'};
if ~isempty(fg),
%	P = cat(1,P{:});
% overlay multiple sessions
	if numel(P)<1, return; end;
	for k = 1:numel(P)
	  Params{k} = zeros(numel(P{k}),12);
	  for i=1:numel(P{k}),
	    Params{k}(i,:) = spm_imatrix(P{k}(i).mat/P{k}(1).mat);
	  end
	end;
	% display results
	% translation and rotation over time series
	%-------------------------------------------------------------------
	spm_figure('Clear','Graphics');
%	ax=axes('Position',[0.1 0.65 0.8 0.2],'Parent',fg,'Visible','off');
%	set(get(ax,'Title'),'String','Image realignment','FontSize',16,'FontWeight','Bold','Visible','on');
%	x     =  0.1;
%	y     =  0.9;
% 	for i = 1:min([numel(P) 12])
% 		text(x,y,[sprintf('%-4.0f',i) P(i).fname],'FontSize',10,'Interpreter','none','Parent',ax);
% 		y = y - 0.08;
% 	end
% 	if numel(P) > 12
% 		text(x,y,'................ etc','FontSize',10,'Parent',ax); end

	ax=axes('Position',[0.1 0.5 0.8 0.4],'Parent',fg,'XGrid','on','YGrid','on');
	for k = 1:numel(Params)
	  axes(ax);
	  plot(Params{k}(:,1:3), ls{rem(k,numel(ls))+1}, 'Parent',ax); hold on;
	end;
	s = ['x translation';'y translation';'z translation'];
	%text([2 2 2], Params(2, 1:3), s, 'Fontsize',10,'Parent',ax)
	legend(ax, s, 0)
	set(get(ax,'Title'),'String','translation','FontSize',16,'FontWeight','Bold');
	set(get(ax,'Xlabel'),'String','image');
	set(get(ax,'Ylabel'),'String','mm');


	ax=axes('Position',[0.1 0.05 0.8 0.4],'Parent',fg,'XGrid','on','YGrid','on');
	for k = 1:numel(Params)
	  axes(ax);
	  plot(Params{k}(:,4:6)*180/pi, ls{rem(k,numel(ls))+1}, 'Parent',ax); hold on;
	end;
	s = ['pitch';'roll ';'yaw  '];
	%text([2 2 2], Params(2, 4:6)*180/pi, s, 'Fontsize',10,'Parent',ax)
	legend(ax, s, 0)
	set(get(ax,'Title'),'String','rotation','FontSize',16,'FontWeight','Bold');
	set(get(ax,'Xlabel'),'String','image');
	set(get(ax,'Ylabel'),'String','degrees');

	% print realigment parameters
	spm_print
end
return;
