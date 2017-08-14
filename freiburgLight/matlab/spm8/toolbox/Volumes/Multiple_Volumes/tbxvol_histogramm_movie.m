function out = tbxvol_histogramm_movie(cmd, bch)
% Create movie of histogramms of image series
% FORMAT tbxvol_histogramm_movie(bch)
% ======
% This tool creates a series of histograms of voxel intensities over a (set of)
% volumes.
%
% This function is part of the volumes toolbox for SPM5. For general help 
% about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Volumes
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: tbxvol_histogramm_movie.m 645 2009-05-04 12:28:27Z glauche $

rev = '$Revision: 645 $';
funcname = 'Intensity histogram';

switch cmd,
    case 'run'
        % function preliminaries
        Finter=spm_figure('GetWin','Interactive');
        Finter=spm('FigName',funcname,Finter);
        SPMid = spm('FnBanner',mfilename,rev);
        % function code starts here

        f = figure;
        ax = axis;
        if all(isfinite(bch.hstart))
            hstart = bch.hstart(bch.hstart <= numel(bch.srcimgs)-(bch.hnum-1));
        else
            hstart = 1:(numel(bch.srcimgs)-(bch.hnum-1));
        end
        if any(strcmp(bch.holdhist,{'first','both'}))
            V = spm_vol(bch.srcimgs(1:bch.hnum));
            X = spm_read_vols([V{:}]);
            [hf hfx] = hist(X(X>bch.int(1) & X<bch.int(2)),bch.nbins);
        end
        if any(strcmp(bch.holdhist,{'last','both'}))
            V = spm_vol(bch.srcimgs(hstart(end):(hstart(end)+(bch.hnum-1))));
            X = spm_read_vols([V{:}]);
            [hl hlx] = hist(X(X>bch.int(1) & X<bch.int(2)),bch.nbins);
        end
        out.movie = getframe(f);
        for k = hstart
            V = spm_vol(bch.srcimgs(k:(k+(bch.hnum-1))));
            X = spm_read_vols([V{:}]);
            [h hx] = hist(X(X>bch.int(1) & X<bch.int(2)),bch.nbins);
            plot(hx,h);
            hold on
            hstr={sprintf('hist #%d',k)};
            if any(strcmp(bch.holdhist,{'first','both'}))
                plot(hfx,hf,'y');
                hstr{end+1} = 'hist #1';
            end
            if any(strcmp(bch.holdhist,{'last','both'}))
                plot(hlx,hl,'g');
                hstr{end+1} = 'hist #last';
            end
            legend(hstr{:});
            hold off;
            out.movie(end+1) = getframe(f);
        end
    case 'vout'
        out = cfg_dep;
        out.sname = 'Movie';
        out.src_output = substruct('.','movie');
        out.tgt_spec   = cfg_findspec({{'strtype','e'}});
    case 'check'
        out = '';
end