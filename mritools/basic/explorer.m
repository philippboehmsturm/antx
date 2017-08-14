
%%open explorerWindow
% function explorer(paths)
% paths: []points to pwd | singlepath | cell of multiple paths
%% examples
% explorer
% explorer(which('ws.m'))
%explorer({'c:\';'T:\'})

function explorer(paths)



if exist('paths')==1
    if ischar(paths);
       paths={paths} ;
    end
else
   paths={pwd} ;
end

for i=1:length(paths)
    [pa2 pa ext]=fileparts(paths{i});
    if isempty(ext)
%     eval(['!start ' paths{i} ]);
     eval(['!explorer ' paths{i} ]);
    else
%      eval(['!start ' pa2 ]) ;  
eval(['!explorer ' pa2 ]) ;  
    end
end

