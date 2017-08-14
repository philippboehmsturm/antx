 function mrs_out = correct_t1(mrs_in)

%  T1 - correction                                                                                  
%  mrs_out = correct_t1(mrs_in)

DEFAULT_THRESH = 0.075;


%%%%%%%% reshape data %%%%%%%%%%%%%%
[sx, sy, sz, st] = size(mrs_in.dataAy);
data = reshape(mrs_in.dataAy, sx*sy*sz,st);
data(:,1) = data(:,2);
max_int = max(max(data));


%%%%%%%% calc base, noise
base = mean(data(:,2:7), 2);
noise = std(data(:,2:7), 1, 2);



%%%%%%%%%%%%  find out signal areas (-> ind) 
count = 1;
count1 = 1;
count2 = 1;

for k = 1 : size(data,1)
    
	if length(find(data(k,: ) > max_int*DEFAULT_THRESH)) > 10 & (all(data(k,:)~= 0) )
        % ind contains all significant data
		ind(count) = k;
		count = count + 1;
        
        if length(find(data(k,8:st) > base(k) + noise(k))) < 3; 
            % ind1 contains all data without leakage
            ind1(count1) = k;
            count1 = count1 + 1;
        else
            % ind2 contains all data with leakage
            % all data that shows signal enhancement of more than 1 std
            ind2(count2) = k;
            count2 = count2 + 1;
        end
	end

end

%%%%%%%%%%%%% calc R effective
R_eff = zeros(size(data));
for k = 1 : st
    R_eff(ind,k)   = - log( data(ind,k) ./ base(ind) ) ./ mrs_in.te;
end

%%%%%%%%%%%%%%   calc mean over all
Rm = mean(R_eff(ind1,:),1)'; % mean over all pixels


%%%%%%%%%%%%%%   calc cumulative sum
Rm_cum = zeros(size(Rm));
Rm_cum(1) = Rm(1);
for k = 2 : st
    Rm_cum(k) = Rm_cum(k - 1) + (Rm(k - 1) + Rm(k))/2; % cumulative sum - trapezoidal integration
end



%%%%%%%%%%%%%%   Fit K map
R_Matr = [Rm   -Rm_cum]; % construct matrix for svd
iM = pinv(R_Matr);
K = iM * R_eff(ind2,:)'; % K(1,:) T2 weighting, K(2,:) -> memory effect


%%%%%%%%%  correct R_eff to R and restore signal
data_out = zeros(sx*sy*sz,st);
R = zeros(sx*sy*sz,st);
R = R_eff;
% ind_k = find(K(1,:)) > 0;
for k = 1 : st
    R(ind2,k) = R_eff(ind2,k) + K(2,:)'.*Rm_cum(k);
    data_out(ind,k) = base(ind).*exp(-R(ind,k).*mrs_in.te);
end
mrs_out = mrs_in;
mrs_out.dataAy = reshape(data_out, sx,sy,sz,st);

% clean up
clear Rm Rm_cum R K R_eff ind_k ind ind1 ind2 data base noise
