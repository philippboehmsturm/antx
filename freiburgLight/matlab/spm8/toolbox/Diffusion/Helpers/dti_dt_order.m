function varargout=dti_dt_order(order)
% Compute index combinations for tensors of order ORDER
% FORMAT [Hind mult Hperm] = dti_dt_order(order)
% ======
% Input argument
%   order - tensor order
% Output arguments
%   Hind  - direction indices
%   mult  - multiplicity of tensor elements
%   iHperm - possible permutations of each Hind (as linear indices into tensor)
% See
%/*\cite{Orszalan2003}*/
% [�M03]       �rszalan, Evren and Thomas H Mareci. Generalized Diffusion 
%              Tensor Imaging and Analytical Relationships Between 
%              Diffusion Tensor Imaging and High Angular Resolution 
%              Diffusion Imaging. Magnetic Resonance in Medicine, 
%              50:955--965, 2003. 
% 
% This function is part of the diffusion toolbox for SPM5. For general 
% help about this toolbox, bug reports, licensing etc. type
%        spm_help vgtbx_config_Diffusion
% in the matlab command window after the toolbox has been launched.
%_______________________________________________________________________
%
% @(#) $Id: dti_dt_order.m 712 2010-06-30 14:20:19Z glauche $

rev = '$Revision: 712 $';
funcname = 'Get DTI indices';

% function preliminaries
Finter=spm_figure('GetWin','Interactive');
spm_input('!DeleteInputObj');
Finter=spm('FigName',funcname,Finter);
SPMid = spm('FnBanner',mfilename,rev);
% function code starts here

  cn = 1;
  n = [];
  nmult = [];
  for n1=order:-1:ceil(order/3)
    for n2=min(n1,(order-n1)):-1:ceil((order-n1)/2)
      n(1:3,cn)=[n1 n2 order-n1-n2]';
      nmult(cn) = prod(1:order)/...
          (prod(1:n(1,cn))*prod(1:n(2,cn))*prod(1:n(3,cn)));
      cn = cn+1;
    end;
  end;
  
  Hind = zeros(order,(order+1)*(order+2)/2);
  mult = zeros(1,(order+1)*(order+2)/2);
  ci = 1;
  for cn=1:size(n,2)
    for il = 1:3
      cind=zeros(order,1);
      cind(1:n(1,cn))=il;
      if n(2,cn) == 0
        Hind(:,ci) = cind;
        mult(ci) = nmult(cn);
        ci = ci+1;
      else
        if n(2,cn) < n(1,cn)
          jind = setdiff(1:3,il);
        else
          jind = (il+1):3;
        end;
        for ij = 1:length(jind)
          cind(n(1,cn)+(1:n(2,cn))) = jind(ij);
          if n(3,cn) == 0
            Hind(:,ci) = cind;
            mult(ci) = nmult(cn);
            ci = ci+1;
          else
            ik = setdiff(1:3,[il jind(ij)]);
            if (n(3,cn) < n(2,cn)) || (n(3,cn) == n(2,cn) && ik>jind(ij))
              cind(n(1,cn)+n(2,cn)+(1:n(3,cn))) = ik;
              Hind(:,ci) = cind;
              mult(ci) = nmult(cn);
              ci = ci+1;
            end;
          end;
        end;
      end;
    end;
  end;
  % sort Hind and mult alphabetically (easier to handle for most functions that
  % need to deal with file names)
  [Hind1 ind]=sortrows(Hind');
  if nargout > 0
    varargout{1} = Hind1';
  end;
  if nargout > 1
    varargout{2} = mult(ind);
  end;
  if nargout > 2
    Hstr=sprintf('Hperm(%d,:),',1:order);

    for k=1:(order+1)*(order+2)/2
      Hperm=unique(perms(Hind1(k,:)),'rows')';
      eval(sprintf('iHperm{k} = sub2ind([3*ones(1,order)],%s);',Hstr(1:end-1)));
    end;
    varargout{3} = iHperm;
  end;
