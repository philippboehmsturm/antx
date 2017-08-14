function rfx_check
%
% check for some support programs
% -------------------------------------------------------------------------
% $Id: rfx_check.m 14 2010-07-15 08:43:58Z volkmar $

global has_prctile has_quantile has_resample; 
global has_nanmean has_nanstd has_nansem;

has_prctile  = ~isempty(which('prctile'));
has_quantile = ~isempty(which('quantile'));
has_resample = ~isempty(which('resample'));
has_nanmean  = ~isempty(which('nanmean'));
has_nanstd   = ~isempty(which('nanstd'));
has_nansem   = ~isempty(which('nansem'));

if ~has_nanmean || ~has_nanstd || ~has_nansem
    p = fileparts(mfilename('fullpath'));
    if exist(fullfile(p,'nansuite'),'dir')
        addpath(fullfile(p,'nansuite'));
        has_nanmean  = ~isempty(which('nanmean'));
        has_nanstd   = ~isempty(which('nanstd'));
        has_nansem   = ~isempty(which('nansem'));
    end
    if ~has_nanmean || ~has_nanstd || ~has_nansem
        disp('RFXPLOT requires the functions "nanmean, nanstd, and nansem". Please')
        disp('download the Nan-Suite from here: http://rfxplot.sourceforge.net/')
        disp('and install it in your MATLAB path.');
        return;
    end
end

if ~has_quantile
    p = fileparts(mfilename('fullpath'));
    if exist(fullfile(p,'stixbox'),'dir')
        addpath(fullfile(p,'stixbox'));
    end
    has_quantile = ~isempty(which('quantile'));
end
return;
