%% open matlabpool depending on Matlab-version
% no args: open max number of pools
% args1: 'close'  -->forces to close pools
%% EXAMPLES:
% createParallelpools;
% createParallelpools('close');

function createParallelpools(arg1)



if isempty(which('matlabpool')); %older versions
    vers=1;
end
if isempty(which('paarpool')); %replaced in R2013b
    vers=2;
end


%% open pool
if exist('arg1')~=1
    if vers==1
        mpools=[4 3 2];
        for k=1:length(mpools)
            try;
                matlabpool(mpools(k));
                disp(sprintf('process with %d PARALLEL-CORES',mppols(k)));
                break
            end
        end
    end
    
    if vers==2
        if isempty(gcp('nocreate'));
            %local mpiexec disabled in version 2010a and newer
             versrelease=version('-release');
             if str2num(versrelease(1:end-1))>2010
             
             distcomp.feature('LocalUseMpiexec',false);
             end
             
            parpool
        end
    end
    
    return
end

%% close pool
if exist('arg1')==1
    if strcmp(arg1,'close')
        if vers==1
            matlabpool close;
        elseif vers==2
            delete(gcp('nocreate'))
        end
    end
    
end

