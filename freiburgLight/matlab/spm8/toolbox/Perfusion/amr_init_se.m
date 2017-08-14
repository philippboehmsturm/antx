amr_global

% global parameters for perfusion processing
%-----------------------------------------------------------------------
% default,min,max
DEFAULT_PERF_BOLUS_AT = [11, 5, 18]; 		%arrival time in scans
DEFAULT_PERF_ALPHA = [3.0, 0.2, 9.0]; 	    %steepnes signal drop (smaller => steeper)
DEFAULT_PERF_BETA = [1.0, 0.1, 5.0]; 		%steepnes signal return (smaller => steeper)
DEFAULT_POWELL = [2, 8, 5, 15, 10, 0.5]; 	%S0_start,S0_stop,SE_int,W_start,W_sig,nois
DEFAULT_PERF_SKIP = 1; 							% # of first scans to skip


% global parameters for multi-echo processing
%-----------------------------------------------------------------------
DEFAULT_T2 = [40, 10, 90];
DEFAULT_T2LONG = [250, 150, 1000];

% global for all
%-----------------------------------------------------------------------
DEFAULT_THRESH = 0.075;							%threshold for masking
