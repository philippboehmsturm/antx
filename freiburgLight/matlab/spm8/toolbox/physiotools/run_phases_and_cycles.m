function varargout = run_phases_and_cycles(cmd, varargin)
% Run the physiotool functions from SPM8 batch system
% varargout = run_phases_and_cycles(cmd, varargin)
% where cmd is one of
% 'run'      - out = run_phases_and_cycles('run', job)
%              Run a job, and return its output argument
% 'vout'     - dep = run_phases_and_cycles('vout', job)
%              Examine a job structure with all leafs present and return an
%              array of cfg_dep objects.
% 'check'    - str = run_phases_and_cycles('check', subcmd, subjob)
%              Examine a part of a fully filled job structure. Return an empty
%              string if everything is ok, or a string describing the check
%              error. subcmd should be a string that identifies the part of
%              the configuration to be checked.
% 'defaults' - defval = run_phases_and_cycles('defaults', key)
%              Retrieve defaults value. key must be a sequence of dot
%              delimited field names into the internal def struct which is
%              kept in function local_def. An error is returned if no
%              matching field is found.
%              run_phases_and_cycles('defaults', key, newval)
%              Set the specified field in the internal def struct to a new
%              value.
% Application specific code needs to be inserted at the following places:
% 'run'      - main switch statement: code to compute the results, based on
%              a filled job
% 'vout'     - main switch statement: code to compute cfg_dep array, based
%              on a job structure that has all leafs, but not necessarily
%              any values filled in
% 'check'    - create and populate switch subcmd switchyard
% 'defaults' - modify initialisation of defaults in subfunction local_defs
% Callbacks can be constructed using anonymous function handles like this:
% 'run'      - @(job)run_phases_and_cycles('run', job)
% 'vout'     - @(job)run_phases_and_cycles('vout', job)
% 'check'    - @(job)run_phases_and_cycles('check', 'subcmd', job)
% 'defaults' - @(val)run_phases_and_cycles('defaults', 'defstr', val{:})
%              Note the list expansion val{:} - this is used to emulate a
%              varargin call in this function handle.
%
% This code is part of a batch job configuration system for MATLAB. See 
%      help matlabbatch
% for a general overview.
%_______________________________________________________________________
% Copyright (C) 2007 Freiburg Brain Imaging

% Volkmar Glauche
% $Id: run_phases_and_cycles.m 7 2009-07-31 07:34:19Z glauche $

rev = '$Rev: 7 $'; %#ok

if ischar(cmd)
    switch lower(cmd)
        case 'run'
            job = local_getjob(varargin{1});
            % do computation, return results in variable out
            % combined estimation of phases&cycles and correction
            % estimation of phases&cycles
            out = struct('PhasesOfSlices', [], 'CyclesOfSlices', [], 'SIGNALS', [],'matfile','');
            % Sort out input arguments
            WhichPhysioStr = char(fieldnames(job.which));
            ChanNames      = fieldnames(job.which.(WhichPhysioStr));
            ChanNames      = ChanNames(1:end-1); % skip 'corr' field
            physiofiles    = cellfun(@(Chan)subsref(job.which.(WhichPhysioStr),substruct('.',Chan,'.','datafile')),ChanNames);
            bandwidth      = cellfun(@(Chan)subsref(job.which.(WhichPhysioStr),substruct('.',Chan,'.','bandwidth')),ChanNames);
            signalyflip    = cellfun(@(Chan)subsref(job.which.(WhichPhysioStr),substruct('.',Chan,'.','flip')),ChanNames);
            switch WhichPhysioStr
                case 'cardiac'
                    WhichPhysio = 0;
                    corrext = {'','Global','Cyclic'}; % dummy for corr == -1
                    channel = job.which.(WhichPhysioStr).cardiac.channel;

                case 'resp'
                    WhichPhysio = 1;
                    corrext = {'Hist','Global','Cyclic'};
                    channel = 1; % dummy
                    
                case 'pulse'
                    WhichPhysio = 2;
                    corrext = {'','Global','Cyclic'}; % dummy for corr == -1
                    channel = 1; % dummy
                    
                case 'respcard'
                    WhichPhysio = 3;
                    corrext = {'GlobalHist','GlobalGlobal','GlobalCyclic','CyclicCyclic'};
                    channel = job.which.(WhichPhysioStr).cardiac.channel;
                    
                case 'cardresp'
                    WhichPhysio = 4;
                    corrext = {'HistGlobal','GlobalGlobal','CyclicGlobal','CyclicCyclic'};
                    channel = job.which.(WhichPhysioStr).cardiac.channel;
                    
                case 'resppulse'
                    WhichPhysio = 5;
                    corrext = {'GlobalHist','GlobalGlobal','GlobalCyclic','CyclicCyclic'};
                    channel = 1; % dummy
                    
                case 'pulseresp'
                    WhichPhysio = 6;
                    corrext = {'HistGlobal','GlobalGlobal','CyclicGlobal','CyclicCyclic'};
                    channel = 1; % dummy
                    
            end
            % compute phases & cycles
            [out.PhasesOfSlices, out.CyclesOfSlices, out.SIGNALS] = PhysioSignal_Plot_PhasesAndCyclesOfSlices23(physiofiles, job.TR, job.nslices, [1 job.nscans], WhichPhysio, job.which.(WhichPhysioStr).corr, [0;0], [0;0], bandwidth, job.TR*job.ndummy, channel, signalyflip);
            % construct output filename based on input and correction
            % method and save results
            if numel(physiofiles) == 1
                [p n e v] = fileparts(physiofiles{1});
            else
                [p n1 e v] = fileparts(physiofiles{1});
                [p n2 e v] = fileparts(physiofiles{2});
                if isequal(n1,n2)
                    n = n1;
                else
                    n = [n1 n2];
                end
            end
            out.which.(WhichPhysioStr).corr = job.which.(WhichPhysioStr).corr; % save info for reference during correction
            out.matfile = {fullfile(p, [n corrext{job.which.(WhichPhysioStr).corr+2} WhichPhysioStr '.mat'])};
            save(out.matfile{1},'-struct','out');
            
            if nargout > 0
                varargout{1} = out;
            end
        case 'vout'
            job = local_getjob(varargin{1});
            % initialise empty cfg_dep array
            dep = cfg_dep;
            dep = dep(false);
            % determine outputs, return cfg_dep array in variable dep
            % output structure
            % out.matfile = filename with correction parameters - cell
            %               strings
            % out.PhasesOfSlices
            % out.CyclesOfSlices
            % out.Signals
            dep(1)            = cfg_dep;
            dep(1).sname      = 'Correction parameters';
            dep(1).src_output = substruct('.','matfile');
            dep(1).tgt_spec   = cfg_findspec({{'type','mat','strtype','e'}});
            WhichPhysioStr = char(fieldnames(job.which));
            switch WhichPhysioStr
                case {'cardiac','pulse','resp'}
                    dep(2)        = cfg_dep;
                    dep(2).sname  = sprintf('PhasesOfSlices - %s(1)', WhichPhysioStr);
                    dep(2).src_output = substruct('.','PhasesOfSlices','()',{1,':'});
                    dep(2).tgt_spec   = cfg_findspec({{'strtype','r'}});
                    dep(3)        = cfg_dep;
                    dep(3).sname  = sprintf('CyclesOfSlices - %s(1)', WhichPhysioStr);
                    dep(3).src_output = substruct('.','PhasesOfSlices','()',{1,':'});
                    dep(3).tgt_spec   = cfg_findspec({{'strtype','r'}});
            end
            varargout{1} = dep;
        case 'check'
            if ischar(varargin{1})
                subcmd = lower(varargin{1});
                subjob = varargin{2};
                str = '';
                switch subcmd
                    % implement checks, return status string in variable str
                    otherwise
                        cfg_message('unknown:check', ...
                            'Unknown check subcmd ''%s''.', subcmd);
                end
                varargout{1} = str;
            else
                cfg_message('ischar:check', 'Subcmd must be a string.');
            end
        case 'defaults'
            if nargin == 2
                varargout{1} = local_defs(varargin{1});
            else
                local_defs(varargin{1:2});
            end
        otherwise
            cfg_message('unknown:cmd', 'Unknown command ''%s''.', cmd);
    end
else
    cfg_message('ischar:cmd', 'Cmd must be a string.');
end

function varargout = local_defs(defstr, defval)
persistent defs;
if isempty(defs)
    % initialise defaults
end
if ischar(defstr)
    % construct subscript reference struct from dot delimited tag string
    tags = textscan(defstr,'%s', 'delimiter','.');
    subs = struct('type','.','subs',tags{1}');
    try
        cdefval = subsref(local_def, subs);
    catch
        cdefval = [];
        cfg_message('defaults:noval', ...
            'No matching defaults value ''%s'' found.', defstr);
    end
    if nargin == 1
        varargout{1} = cdefval;
    else
        defs = subsasgn(defs, subs, defval);
    end
else
    cfg_message('ischar:defstr', 'Defaults key must be a string.');
end

function job = local_getjob(job)
if ~isstruct(job)
    cfg_message('isstruct:job', 'Job must be a struct.');
end