
function rmricron(pa,tmp,ovl,cols, trans)
%% use MRICRON to plot data
% function rmricron(pa,tmp,ovl,cols, trans)
%  rmricron(pa,tmp,ovl,cols, trans)
%  pa : path
%  tmp : template (without path)
%  ovl: overlaying images (struct, without path)
%  cols: colors =numeric idx from pulldown LUT in mricron
%  trans: 2 values: transparency background/overlay & transperancy between overlays
%% example
% pa='V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1'
% tmp='_AwAVGT.nii'
% ovl={...
% 'H_wc1T2_left.nii'   
% 'H_wc1T2_right.nii'
% 'H_wc2T2_right.nii' 
% 'H_wc2T2_left.nii' 
% }
% cols=[ 2 2 1 1  ];
% trans=[20 -1]
%  rmricron(pa,tmp,ovl,cols, trans)

if 0
    pa='V:\projects\atlasRegEdemaCorr\niiSubstack\s20150908_FK_C1M01_1_3_1_1'
    tmp='_AwAVGT.nii'
    ovl={...
        'H_wc1T2_left.nii'
        'H_wc1T2_right.nii'
        'H_wc2T2_right.nii'
        'H_wc2T2_left.nii'
        }
    cols=[ 2 2 1 1  ];
    trans=[20 -1]
    rmricron(pa,tmp,ovl,cols, trans)
end




%   start mricron .\templates\ch2.nii.gz -c -0 -l 20 -h 140 -o .\templates\ch2bet.nii.gz -c -1 10 -h 130
  % color:   "-c bone",  "-c 0",  gray, -c 1 is red...

% start /MAX c:\mricron\mricron 

% clim: -l  and -h for lower/upper value
% trasnparency of overlays:            -b :   -1, 0:20:100,   -1=addititive
% trasnparency between overlays:  -t :   -1, 0:20:100,   -1=addititive

  
%   H_wmask2_left.nii   
% H_wT2_left.nii        H_whemi2_left.nii   
% H_wT2_right.nii       H_whemi2_right.nii  

% pa='V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1'
% ovl={...
% 'H_wc1T2_left.nii'   
% 'H_wc1T2_right.nii'
% 'H_wc2T2_right.nii' 
% 'H_wc2T2_left.nii' 
% }
% tmp='_AwAVGT.nii'

ov=fullpath(pa,ovl);
tmp=char(fullpath(pa,tmp));

% trans=[20 -1]
% col={ 'r'  '1'
%     'b'  '2'
%     'g'  '3'
%     'v'  '4'
%     'y'  '5'
%     'c' '6'
%     }


% cols=[ 2 2 1 1  ]% 2 2]
cols2=[];
for i=1:length(ov)
    cols2{i,1}=[' -c -' num2str(cols(i)) ' '];
end
ov2=cellfun(@(a,b) [' -o ' a b] ,ov,cols2,'UniformOutput',0);
o = reshape(char(ov2)',   1,  []);
btrans=[' -b ' num2str(trans(1)) ];
ttrans=['  -t ' num2str(trans(2)) ];

mri='!start c:\mricron\mricron ';
mri='!start /MAX c:\mricron\mricron ';
tmp=fullfile(pa, '_AwAVGT.nii');
c=[mri   tmp   o  btrans ttrans];
eval(c);




% !start c:\mricron\mricron V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\_AwAVGT.nii -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc1T2_right.nii -c - 4  -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc2T2_right.nii -c - 1  -b -50  -t - 50


% 
% !start c:\mricron\mricron V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\_AwAVGT.nii -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc1T2_right.nii -c -6 -b -50
% -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc2T2_right.nii -c 1  -b 50 -t 50
% 
% 
% !start c:\mricron\mricron V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\_AwAVGT.nii -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc1T2_right.nii -c 4  -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc2T2_right.nii -c 1  -b 50 -t 50
% 
% 
% 
% % mri='!start /MAX c:\mricron\mricron'
% mri='!start c:\mricron\mricron '
% tmp=fullfile(pa, '_AwAVGT.nii')
% f1=fullfile(pa, 'H_wT2_left.nii')
% f1=ov{1}
% box=[' -o ' f1 ]
% 
% c=[mri   tmp box ]
%  eval(c)
%  
%  
%  
 
 
 
 
 
 
 
 
 
 