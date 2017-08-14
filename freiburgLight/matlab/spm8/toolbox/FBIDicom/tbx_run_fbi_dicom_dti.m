function out = tbx_run_fbi_dicom_dti(job)
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
% $Id: tbx_run_fbi_dicom_dti.m 30 2010-06-29 13:41:42Z volkmar $

rev = '$Rev: 30 $'; %#ok<NASGU>

opwd = pwd;
if ~isempty(char(job.outdir))
    cd(char(job.outdir));
end
out.files = {};
for k = 1:numel(job.dirs)
    files = dir(fullfile(job.dirs{k},'*.dcm'));
    if isempty(files)
        cd(opwd)
        error(['No DICOM files found in directory ''%s''. Check that the ' ...
               'files are online and try again.'], job.dirs{k});
    else
        fnames = cellfun(@(fn)fullfile(job.dirs{k},fn),{files.name},'UniformOutput',false);
        hdr = spm_dicom_headers(char(fnames));
        atime = zeros(size(hdr));
        for m = 1:numel(hdr)
            atime(m) = hdr{m}.AcquisitionTime;
        end
        [un aind] = sort(atime);
        if k == 1
            out.files{1} = getfilelocation(hdr{aind(1)},job.root);
        end
        try
            [out.files{1}, status, errorstring] = read_dti_dicom(job.dirs{k}, ...
                                                              files(aind), k > 1, out.files{1}, k);
        catch
            errorstring = 'DTI DICOM import failed.';
        end
        if ~isequal(status,[1 1 1])
            errorstring = 'The Dicom data does not privide all necessary information for the calculation of the tensors.\nThe reason for this might be that you don not work with Siemens Dicom.\n Please use the GUI instead (dti_tool) of the Batch Editor (see manual).\nAnother option would be that you read in your data into an mrstruct (see manual) and set up the batch using this as raw data.';
        end
        if ~isempty(errorstring)
            fprintf(['Data in folder ''%s'' can not be converted. Please ' ...
                     'check whether this folder exists and make sure it ' ...
                     'contains only DTI DICOM data. The original error ' ...
                     'message was:\n %s\n'], job.dirs{k}, errorstring);
        end
    end
end
out.files{1} = [out.files{1} '_raw.bin'];
cd(opwd);

% The following code is copied from spm_dicom_convert (with modification 
% regarding ICE dims and format in filenames)
%_______________________________________________________________________

%_______________________________________________________________________

function fname = getfilelocation(hdr,root_dir,prefix)

if nargin < 3
    prefix = 'f';
end;

if strncmp(root_dir,'ice',3)
    % ICE dims sorting not supported
    root_dir = root_dir(4:end);
end;

if strcmp(root_dir, 'flat')
    % Standard SPM5 file conversion
    %-------------------------------------------------------------------
    if checkfields(hdr,'SeriesNumber','AcquisitionNumber')
        if checkfields(hdr,'EchoNumbers')
            fname = sprintf('%s%s-%.4d-%.5d-%.6d-%.2d', prefix, strip_unwanted(hdr.PatientID),...
                hdr.SeriesNumber, hdr.AcquisitionNumber, hdr.InstanceNumber,...
                hdr.EchoNumbers);
        else
            fname = sprintf('%s%s-%.4d-%.5d-%.6d', prefix, strip_unwanted(hdr.PatientID),...
                hdr.SeriesNumber, hdr.AcquisitionNumber, ...
                hdr.InstanceNumber);
        end;
    else
        fname = sprintf('%s%s-%.6d',prefix, ...
            strip_unwanted(hdr.PatientID),hdr.InstanceNumber);
    end;

    fname = fullfile(pwd,fname);
    return;
end;

% more fancy stuff - sort images into subdirectories
if ~isfield(hdr,'ProtocolName')
    if isfield(hdr,'SequenceName')
        hdr.ProtocolName = hdr.SequenceName;
    else
        hdr.ProtocolName='unknown';
    end;
end;
if ~isfield(hdr,'SeriesDescription')
    hdr.SeriesDescription = 'unknown';
end;
if ~isfield(hdr,'EchoNumbers')
    hdr.EchoNumbers = 0;
end;

m = sprintf('%02d', floor(rem(hdr.StudyTime/60,60)));
h = sprintf('%02d', floor(hdr.StudyTime/3600));
studydate = sprintf('%s_%s-%s', datestr(hdr.StudyDate,'yyyy-mm-dd'), ...
    h,m);
switch root_dir
    case 'date_time',
    id = studydate;
    case {'patid', 'patid_date', 'patname'},
    id = strip_unwanted(hdr.PatientID);
end;
serdes = strrep(strip_unwanted(hdr.SeriesDescription),...
    strip_unwanted(hdr.ProtocolName),'');
protname = sprintf('%s%s_%.4d',strip_unwanted(hdr.ProtocolName), ...
    serdes, hdr.SeriesNumber);
switch root_dir
    case 'date_time',
        dname = fullfile(pwd, id, protname);
    case 'patid',
        dname = fullfile(pwd, id, protname);
    case 'patid_date',
        dname = fullfile(pwd, id, studydate, protname);
    case 'patname',
        dname = fullfile(pwd, strip_unwanted(hdr.PatientsName), ...
            id, protname);
    otherwise
        error('unknown file root specification');
end;
if ~exist(dname,'dir'),
    mkdir_rec(dname);
end;

% some non-product sequences on SIEMENS scanners seem to have problems
% with image numbering in MOSAICs - doublettes, unreliable ordering
% etc. To distinguish, always include Acquisition time in image name
sa = sprintf('%02d', floor(rem(hdr.AcquisitionTime,60)));
ma = sprintf('%02d', floor(rem(hdr.AcquisitionTime/60,60)));
ha = sprintf('%02d', floor(hdr.AcquisitionTime/3600));
fname = sprintf('%s%s-%s%s%s-%.5d-%.5d-%d', prefix, id, ha, ma, sa, ...
        hdr.AcquisitionNumber,hdr.InstanceNumber, ...
        hdr.EchoNumbers);

fname = fullfile(dname, fname);

%_______________________________________________________________________

%_______________________________________________________________________

function suc = mkdir_rec(str)
% works on full pathnames only
opwd=pwd;
if str(end) ~= filesep, str = [str filesep];end;
pos = strfind(str,filesep);
suc = zeros(1,length(pos));
for g=2:length(pos)
    if ~exist(str(1:pos(g)-1),'dir'),
        cd(str(1:pos(g-1)-1));
        suc(g) = mkdir(str(pos(g-1)+1:pos(g)-1));
    end;
end;
cd(opwd);
return;
%_______________________________________________________________________

%_______________________________________________________________________
function ok = checkfields(hdr,varargin)
ok = 1;
for i=1:(nargin-1),
    if ~isfield(hdr,varargin{i}),
        ok = 0;
        break;
    end;
end;
return;
%_______________________________________________________________________

%_______________________________________________________________________
function clean = strip_unwanted(dirty)
msk = (dirty>='a'&dirty<='z') | (dirty>='A'&dirty<='Z') |...
      (dirty>='0'&dirty<='9') | dirty=='_';
clean = dirty(msk);
return;
