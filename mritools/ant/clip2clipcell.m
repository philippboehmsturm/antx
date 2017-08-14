
%% convertse cellstring (pahts) in clipboard to matlabstyle cell (back to clipboard)
function clip2clipcell

% mat2clip(s.folder);



a=clipboard('paste');
a2=strsplit2(a,char(10))';
ro =['{' ; cellfun(@(a) {[ ' ''' a '''']},a2); '};'];
mat2clip(ro);



function Tokens = strsplit2(String, Delim)

Tokens = [];

while (size(String,2) > 0)
    if isempty(Delim)
         [Tok, String] = strtok(String);    
    else
        [Tok, String] = strtok(String, Delim);    
    end
    Tokens{end+1} = Tok;
end


