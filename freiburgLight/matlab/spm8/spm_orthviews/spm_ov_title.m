function spm_ov_title(varargin)

global st;
if isempty(st)
    error(sprintf('spm:%s', mfilename), '%s: This routine can only be called as a plugin for spm_orthviews!', mfilename);
end;

if nargin < 2
    error(sprintf('spm:%s', mfilename), '%: Wrong number of arguments. Usage: spm_orthviews(''title'', cmd, volhandle, varargin)', mfilename);
end;

cmd = lower(varargin{1});
volhandle = varargin{2};

switch cmd

    %----------------------------------------------------------------------
    % Context menu and callbacks
    case 'context_menu'
        item0 = uimenu(varargin{3}, 'Label', 'Add title', 'Callback', ...
            sprintf('%s(''context_init'', %d);', mfilename, volhandle), ...
            'Tag',['TITLE_0_', num2str(volhandle)]);

    case 'context_init'
        Finter = spm_figure('FindWin', 'Interactive');
        spm_input('!DeleteInputObj', Finter);
        if isfield(st.vols{volhandle}, 'title')
            titlestr = st.vols{volhandle}.title.str;
        else
            titlestr = '';
        end
        st.vols{volhandle}.title.str = spm_input('Title', '!+1', 's', titlestr);
        set_title;
        
    case 'addtitle'
        st.vols{volhandle}.title.str = varargin{3};
        set_title(volhandle);
        
    case 'rmtitle'
        st.vols{volhandle}.title.str = '';
        set_title(volhandle);
        
    case 'redraw'
        % Do nothing
        
    otherwise
        fprintf('spm_orthviews(''rgb'', ...): Unknown action %s', cmd);
end

function set_title(volhandle)
global st
if isempty(st.vols{volhandle}.title.str)
    if isfield(st.vols{volhandle}.title, 'ax')
        delete(st.vols{volhandle}.title.ax);
    end
    st.vols{volhandle} = rmfield(st.vols{volhandle}, 'title');
else
    if isfield(st.vols{volhandle}.title, 't')
        set(st.vols{volhandle}.title.t, 'String', st.vols{volhandle}.title.str);
    else
        axpos = zeros(3,4);
        for k = 1:3
            axpos(k,:) = get(st.vols{volhandle}.ax{k}.ax, 'Position');
        end
        axul = [min(axpos(:,1)), max(axpos(:,2)+axpos(:,4))+.1*(st.vols{volhandle}.area(2)+st.vols{volhandle}.area(4)-max(axpos(:,2)+axpos(:,4)))];
        axsz = [st.vols{volhandle}.area(3) st.vols{volhandle}.area(2)+st.vols{volhandle}.area(4) - axul(2)];
        st.vols{volhandle}.title.ax = axes('Position', [axul axsz], 'Visible', 'off');
        st.vols{volhandle}.title.t  = text(.5, 0, st.vols{volhandle}.title.str, 'HorizontalAlignment', 'Center');
    end
end