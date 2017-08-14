function tbxvol_transform_t2x(job)
%CG_T2X transformation of t-maps to P, -log(P), r or d-maps
%
% The following formulas are used:
%
% --------------------------------
% correlation coefficient:
% --------------------------------
%          sign(t)
% r = ------------------
%            df
%     sqrt(------ + 1)
%           t*t
%
% --------------------------------
% effect-size
% --------------------------------
%            2r
% d = ----------------
%     sqrt(1-sqr(r))
%
% --------------------------------
% p-value
% --------------------------------
%
% p = 1-spm_Tcdf
%
% --------------------------------
% log p-value
% --------------------------------
%
% -log10(1-P) = -log(1-spm_Tcdf)
%
% For the last case of log transformation this means that a p-value of p=0.99 (0.01)
% is transformed to a value of 2
%
% Examples:
% p-value	-log10(1-P)
% 0.1		1
% 0.05		1.3
% 0.01		2
% 0.001		3
% 0.0001	4
%
%_______________________________________________________________________
% @(#)cg_t2x.m   1.22 Christian Gaser 2005/11/09


for i=1:numel(job.srcimgs)
	Res = deblank(job.srcimgs{i});
	[pth,nm,xt,vr] = spm_fileparts(Res);

	SPM_name = fullfile(pth, 'SPM.mat');
	
	% SPM.mat exist?
	try
		load(SPM_name);
		spm_mat = 1;
	catch
		spm_mat = 0;		
	end

	if spm_mat
		if any(strcmp(spm('ver'),{'SPM2','SPM5','SPM8'}))
			xCon = SPM.xCon;
			df = SPM.xX.erdf;
		else	
			xCon_name = fullfile(pth, ['xCon.mat' vr]);
			load(xCon_name);
			df = xX.erdf;
		end
	else
		df = spm_input('df ?',1,'e');		
	end

	switch job.option
	  case 1
	  	t2x = ['1-spm_Tcdf(i1,' num2str(df) ')'];
		nm2 = 'P';
	  case 2
	  	t2x = ['-log10(max(eps,1-spm_Tcdf(i1,' num2str(df) ')))'];
		nm2 = 'logP';
	  case 3
	  	t2x = ['sign(i1).*(1./((' num2str(df) './((i1.*i1)+eps))+1)).^0.5'];
		nm2 = 'R';
	  case 4
	  	tmp = ['((' num2str(df) './((i1.*i1)+eps))+1)'];
		t2x = ['2./((1-(1./' tmp ')).*' tmp ').^0.5'];
		nm2 = 'D';
	end

	% name should follow convention spm?_0*.img
	if strcmp(nm(1:3),'spm') && strcmp(nm(4:6),'T_0')	
		num = str2double(nm(length(nm)-2:length(nm)));
		if xCon(num).STAT ~= 'T'
			error('Not a T contrast');
		end
		out = fullfile(pth,[nm(1:3) nm2 nm(5:end) xt]);
	else
		out = fullfile(pth,['spm' nm2 '_' nm xt]);
	end

	spm_imcalc_ui(Res,out,t2x,{0 0 4 1});

end


