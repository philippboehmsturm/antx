function [Up, Un, Gp, Gn] = moh_FCP_outliers(vp, XC, Vol, Alpha, Lambda)
% function for outliers detection
% based on FCP approach (Fuzzy Clustering with fixed Prototype)
% assess both negative (abnormaly low) and positive (abnormaly high) effects 
% input:
% -------
%   vp: Vol structure of the patient image
%   XC: data of all controls (matrix nvox x nsubj)
%   Vol: indices of meaningful voxels to limit the computation (mask) 
%   Alpha: parameter of sensitivity (i.e. how far is the outlier effect )
%   Lambda: degree of fuzziness
% output:
% -------
%   Up: image for positive outliers (high effects)
%   Un: image for negative outliers (low effects)
%   Gp: Global positive outliers (high effects) (for illustration)
%   Gn: Global negative outliers (low effects) (for illustration)
%
% for more details see: Seghier et al. Neuroimage 2007
% ----------------------------
% Mohamed Seghier, 17.01.2008
%

if ~isstruct(vp), vp = spm_vol(vp) ; end


if isempty(Vol),
    error('ERROR: Plesae check that your mask is not empty...!!') ;
    return ;
end


Nvox = size(XC, 1) ;
c = size(XC, 2) + 1 ;

if nargin==3
    Lambda = -4 ; % default value of the fuzziness degree
    Alpha = 3*std(XC(:)) ; % approx of the variance of controls
    disp(['## Alpha is set to  = ', num2str(Alpha)]) ;
end


% read patient data
im = spm_read_vols(vp) ;


% centroid definition
V = Alpha*eye(c) ;

% distance calculation (TANH)
bet = ([im(Vol), XC]' - repmat(sum([im(Vol), XC]')/c, c,1))'*...
    (V' - repmat(sum(V')/c, c,1)) ./(c-1) ;
bet = bet ./ repmat(var(V'),Nvox ,1) ;
D = (1 - tanh(bet)) ;
D(D == 0) = eps ;

% membership degrees calculation for positive (high) effects
U = [] ;
U = ( power(D, Lambda) ./ repmat(sum(power(D, Lambda)'), c,1)')' ;

Gp = sum(U')/Nvox ;

Up = zeros(vp.dim) ;
Up(Vol(1:Nvox)) = U(1,1:Nvox) ;

disp('### abnormal positive effects (Patient > Controls)..........OK')

% membership degrees calculation for negative (low) effects
U = [] ;
U = ( power(2-D, Lambda) ./ repmat(sum(power(2-D, Lambda)'), c,1)')' ;

Gn = sum(U')/Nvox ;

Un = zeros(vp.dim) ;
Un(Vol(1:Nvox)) = U(1,1:Nvox) ;

disp('### abnormal negative effects (Patient < Controls)..........OK')


return ;

