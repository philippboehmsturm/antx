

%% #b displays the  last updates of [ANT]-TBX

function antver

% clc
% cprintf([0 .5 0],                    '     •••••••••••••••••••••••••\n');
% cprintf([0 .5 0],                    '•••');
% cprintf([0.9294    0.6941    0.1255],'    ANT-TOOLBOX    ');
% cprintf([0 .5 0],                    '•••\n');
% cprintf([0 .5 0],                    '     •••••••••••••••••••••••••\n');

clc
cprintf('*[0 .5 0]',                    '  •••••••••••••••••••••••••\n');
cprintf('*[0 .5 0]',                    '  •••');
cprintf('*[0.9294    0.6941    0.1255]','    ANT-TOOLBOX    ');
cprintf('*[0 .5 0]',                    '•••\n');
cprintf('*[0 .5 0]',                    '  •••••••••••••••••••••••••\n');

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

space=[repmat(' ',[1 32] ) ' •' ];

cprintf('*[0.8510    0.3255    0.0980]',[ ['modified: 18 Nov 2016 (04:05:03)']  ]);
cprintf([0 0 0],[  [    ' •new copy/rename function & nifti-volume expansion (4D-nii)'] '\n']);
cprintf([0 0 0],[ space  [ 'listing of the main functions'] '\n']);
cprintf([0 0 0],[ space  [ 'deBuged: coregistration using vol>1 of 4dim data'] '\n']);
cprintf([0 0 0],[ space  [ 'update-& version-control'] '\n']);
cprintf('*[0.8510    0.3255    0.0980]',[ ['modified: 18 Nov 2016 (18:14:33)']  ]);
cprintf([0 0 0],[  [       ' •deBUGed: [brukerImport] case: incorect magnitudes, sol:dataType set to float64' ] '\n']);
cprintf([0 0 0],[ space  [ '[xfastviewer.m] implemented for fast imagedisplay 3/4dimDATA+infos'] '\n']);

cprintf('*[0.8510    0.3255    0.0980]',[ ['modified: 23 Nov 2016 (15:17:24)']  ]);
cprintf([0 0 0],[  [      ' •deBUGed: xoverlay & xfastview (trating missing files)'] '\n']);

cprintf('*[0.8510    0.3255    0.0980]',[ 'modified: 27 Nov 2016 (01:36:07)'  ]);
cprintf([0 0 0],[  [      ' •Mask-Generator created [xmaskgenerator.m]'] '\n']);

cprintf('*[0.8510    0.3255    0.0980]',[ 'modified: 28 Nov 2016 (17:42:04)'  ]);
cprintf([0 0 0],[  [      ' DEBUG: readout Mask-Generator...incorrect volumes extracted'] '\n']);
cprintf([0 0 0],[ space  [ '[xdistributefiles.m]: to copy /and rename all possible file(s) from outside into pre-selected mousefolder(s)'] '\n']);

cprintf('*[0.8510    0.3255    0.0980]',[  'modified: 29 Nov 2016 (01:59:00)' ]);
cprintf([0 0 0],[  [      ' •[xselect.m]: pre-select folders by either file/id/folder or textfile '] '\n']);
cprintf([0 0 0],[ space  [ 'added contextmenu (folder-listbox): clipboard selected folders as path or fullpath'] '\n']);
cprintf([0 0 0],[ space  [ 'added contextmenu (folder-listbox): clipboard selected folders as path or fullpath in matlab-cell-style (for batch-stuff)'] '\n']);

cprintf('*[0.8510    0.3255    0.0980]',[     'modified: 06 Dec 2016 (12:30:41)'     ]);
cprintf([0 0 0],[  [      ' •debug: antcb(''load'',study); -->opens ANT-gui before'] '\n']);
cprintf([0 0 0],[ space  [ 'debug: antcb(''getallsubjects'')-->exclude the "excluded cases"'] '\n']);

cprintf('*[0.8510    0.3255    0.0980]',[  'modified: 14 Dec 2016 (02:16:33)'        ]);
cprintf([0 0 0],[  [      ' •[xreplaceheader.m] replace header of within-path file(s) using refIMG (simple method - ) •'] '\n']);
cprintf([0 0 0],[ space  [ '[xdeletefiles.m]  DELETE within-path file(s)'] '\n']);

cprintf('*[0.8510    0.3255    0.0980]',[    'modified: 19 Dec 2016 (17:16:55)'      ]);
cprintf([0 0 0],[  [      ' • MRICRON-linkage in case-file-matrix (mouse-click-dependence-->see help)'] '\n']);
cprintf([0 0 0],[  [   space   '[xrename] RENAME/DELETE/EXTRACT/EXPAND/COPY file(s) from selected ant-mousefolders'] '\n']);
cprintf([0 0 0],[  [   space   'created "on-the-fly-help" for menubar-functions'] '\n']);
cprintf([0 0 0],[  [  space    '"on-the-fly-help" for menubar-functions can be switched on/off using [antsettings]'] '\n']);

cprintf('*[0.8510    0.3255    0.0980]',[   'modified: 03 Jan 2017 (14:27:33)'       ]);
cprintf([0 0 0],[  [      ' •[xstat_2sampleTtest.m] -    2-sample-t-test'] '\n']);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
a=preadfile(which('antver.m'));
a=a.all;
b=a(max(regexpi2(a,'changes_on')+1):max(regexpi2(a,'changes_off')-1)) ;
for i=1:size(b,1)
    if ~isempty(regexpi2(b(i),'#T'))
    cprintf('*[0.8510    0.3255    0.0980]',[b{i}(2:end) '\n' ]);
    else
     cprintf([0 0 0],[b{i}(2:end) '\n' ]);
    end
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

% 
% ## changes_on
% #T 31 Jan 2017 (10:18:53)
% [antintro] -click onto brain to immediately diappear
% [selector2]: bugfix -sorting
% [xgetlabels3]: now works with both/left/right-hemispheres in Allen and Native Space, in Native space, this is
%   realized by warping the semi-bounding box (based on semiAVGTmask) back in native space
%  ..new pseudo-labels: BrainMasked      --> Params of thresholded,masked & hemisphere-masked brain ('TOTAL-BRAIN')
%                       HemisphereInBBox --> Params of hemisphere-masked field-of-view ('TOTAL-within-Bounding-box'); 
%   .. trailing rows in excel removed
% ## changes_off


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

 if 0   
         cprintf('*[0.8510    0.3255    0.0980]',[          ]);
     cprintf([0 0 0],[  [      ' •'] '\n']);
    cprintf([0 0 0],[ space  [ ''] '\n']);
    cprintf([0 0 0],[ space  [ ''] '\n']);
    
    clipboard('copy', [    ['''modified: '   datestr(now,'dd mmm yyyy (HH:MM:SS)') '''' ]           ]);
    
  
    
end

