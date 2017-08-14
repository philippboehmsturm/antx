function out = tbx_run_fbi_dicom(job)
% SPM job execution function
% takes a harvested job data structure and call SPM functions to perform
% computations on the data.
% Input:
% job    - harvested job data structure (see matlabbatch help)
% Output:
% out    - computation results, usually a struct variable.

% tbx_run_fbi_dicom.m,v 1.3 2008/05/21 11:43:30 vglauche Exp
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: $

rev = '$Rev: 218 $'; %#ok<NASGU>

switch char(fieldnames(job.data))
    case 'files'
        files = {job.data.files};
    case 'dirs'
        files1 = cell(size(job.data.dirs));
        for k = 1:numel(job.data.dirs)
            files1{k} = recurse_dirs(deblank(job.data.dirs{k}),{});
        end;
        files = [files1{:}];
        if numel(files) == 0
            dstr = sprintf('%s\n', job.data.dirs{:});
            error('tbx_fbi_dicom:failed', ...
                  ['DICOM import failed:\n' ...
                   'No files/directories to convert.\n' ...
                   'Check that you have read permissions on the directories.\n%s'], dstr);
        end;
    case 'dicomdirs'
        files1 = cell(size(job.data.dicomdirs));
        for k = 1:numel(job.data.dicomdirs)
            files1{k} = read_dicomdirs(job.data.dicomdirs{k});
        end;
        files = [files1{:}];
        if numel(files) == 0
            dstr = sprintf('%s\n', job.data.dirs{:});
            error('tbx_fbi_dicom:failed', ...
                  ['DICOM import failed:\n' ...
                   'No files/directories to convert.\n' ...
                   'Check that you have read permissions on the directories.\n%s'], dstr);
        end;
        
end;

out.files = {};
rjob = cell(size(files));
switch spm('ver')
    case 'SPM5'
        for k = 1:numel(files)
            rjob{k}.util{1}.dicom = job;
            rjob{k}.util{1}.dicom.data = files{k};
        end
        % no detection of failed jobs
        spm_jobman('run',rjob);
    case {'SPM8','SPM8b'}
        for k = 1:numel(files)
            rjob{k}.spm.util.dicom = job;
            rjob{k}.spm.util.dicom.data = files{k};
        end
        cjob = cfg_util('initjob', rjob);
        cfg_util('run', cjob);
        jout = cfg_util('getalloutputs', cjob);
        cfg_util('deljob', cjob);
        for k = 1:numel(jout)
            if isfield(jout{k},'files')
                out.files = [out.files(:); jout{k}.files(:)];
            end
        end
end

%______________________________________________________________________
% Recursively get all files from a directory and all its subdirectories

function pp = recurse_dirs(cdir,pp)
pp1 = {};
if exist(cdir, 'dir')
    ad = dir(cdir);
    for i=1:length(ad)
        if ad(i).isdir
            if ~strcmp(ad(i).name,'.') && ~strcmp(ad(i).name,'..')
                pp = recurse_dirs([cdir filesep ad(i).name],pp);
            end;
        else
            pp1{end+1} = fullfile(cdir, ad(i).name);
        end;
    end;
    if ~isempty(pp1)
        pp{end+1} = pp1;
    end
else
    warning('tbx_run_fbi_dicom:recurse_dirs', 'Can not access folder ''%s''. Data from this folder may be archived already.', cdir);
end

%______________________________________________________________________
% Read a dicomdirs file and parse its contents to get a series-wise list
% of files

function files = read_dicomdirs(dicomdirs)

p        = fileparts(dicomdirs);
hdcmdirs = spm_dicom_headers(dicomdirs);
drs      = hdcmdirs{1}.DirectoryRecordSequence;
% Get directory record types
hdrt     = deblank(cellfun(@(item)subsref(item,substruct('.','DirectoryRecordType')), ...
                   drs,'UniformOutput', ...
                   false));
% Get start and end of series lists
% Assume that DirectoryRecordSequence is a linear listing of all items on
% CD and no files are listed "outside" of a SERIES 
isseries  = find(strcmp(hdrt, 'SERIES'));
files = cell(size(isseries));
if ~isempty(isseries)
    ieseries  = [isseries(2:end)-1 numel(hdrt)];
    for cs = 1:numel(isseries)
        files{cs} = {};
        for ce = isseries(cs):ieseries(cs)
            if isfield(drs{ce}, 'ReferencedFileID')
                % canonicalise file names, assume filenames relative to
                % dicomdir file location
                cf = fullfile(p, ...
                              strrep(lower(deblank(drs{ce}.ReferencedFileID)),'\',filesep));
                if exist(cf, 'file')
                    files{cs}{end+1} = cf;
                else
                    cf = fullfile(p, ...
                                  strrep(deblank(drs{ce}.ReferencedFileID),'\',filesep));
                    if exist(cf, 'file')
                        files{cs}{end+1} = cf;
                    end
                end
            end
        end
    end
    % prune empty series
    files = files(~cellfun(@isempty,files));
end
