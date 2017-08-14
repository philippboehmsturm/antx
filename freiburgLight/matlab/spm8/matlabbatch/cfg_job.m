classdef cfg_job
    properties (Access=private)
        c0;
        showhints = false;
    end
    methods
        %% Constructor, Access to internal properties
        function obj = cfg_job(c0)
            if nargin == 0
                obj.c0 = cfg_util('getcfg');
            else
                obj.c0 = c0;
            end
        end
        function obj = hints(obj, val)
            if nargin == 1
                obj.showhints = ~obj.showhints;
            else
                if islogical(val)
                    obj.showhints = val;
                elseif ischar(val)
                    switch lower(val)
                        case {'on','yes','true'}
                            obj.showhints = true;
                        case {'off','no','false'}
                            obj.showhints = false;
                    end
                end
            end
        end
        %% Overridden subscript assignment and reference
        function obj = subsasgn(obj, subs, val)
            obj.c0 = subsasgn_job(obj.c0, subs, val);
        end
        function varargout = subsref(obj, subs)
            [ritem varargout{1:max(nargout,1)}] = subsref_job(obj.c0, subs, obj.c0);
            if obj.showhints || nargout == 0
                str = showdetail(ritem);
                fprintf('%s\n', str{:});
            end
        end
        %% Disp method
        function disp(obj)
            str = showdetail(obj.c0);
            fprintf('%s\n', str{:});
            [~, val] = harvest(obj.c0, obj.c0, false, false);
            fprintf('\nCurrent contents:\n')
            disp(val)
        end
        %% Job specific methods
        function [tag, val] = harvest(obj)
            [tag, val] = harvest(obj.c0, obj.c0, false, false);
        end
        function obj = initialise(obj, val)
            obj.c0 = initialise(obj.c0, '<DEFAULTS>', false);
            obj.c0 = initialise(obj.c0, val, false);
        end
        function savejob(obj, filename)
            [~, matlabbatch] = harvest(obj);
            str = gencode(matlabbatch);
            fid = fopen(filename, 'w');
            fprintf(fid, 'matlabbatch = %s;\n', class(obj));
            fprintf(fid, '%s\n', str{:});
            fclose(fid);
        end
    end
end
