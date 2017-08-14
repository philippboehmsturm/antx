%% #b parameter-settings of [ANT]  (not the function for studiy-project-settings!!)
% #r  be carefull with any modifications here!
% #by CHANGEABLE PARAMETERS 
% settings.show_instant_help      :  show menubar-help on the fly [0,1]
% settings.show_intro             :  show intro [0,1],  ..if [1] intro is shown only when
%                                    ANT is started for the first time 
% 
% #by NOTE
% in some cases [ANT] needs to be updated to execute soome parameter settings :
% to restart-->  type   - ant              - to just load the [ANT]-GUI
%                    or - antcb('reload')  - to re-load the study-project and previous selected
%               mouse-folders 
% 
% #by RESTART IS only NECESSARY FOR CAHNGES OF THE FOLLOWING PARAMETERS:  -none-
% 

function settings=antsettings

%———————————————————————————————————————————————
%%   MODIFY HERE
%———————————————————————————————————————————————

settings.show_instant_help  =  1          ;%[0,1] displays on-the-fly-function's help
settings.show_intro         =  1          ;%[0,1] shows intro upon ANT-start


