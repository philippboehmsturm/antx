function [hReg,xSPM,SPM]=spm_results_ui_nS
%
% function spm_results_ui_nS.m
%
% A function to display non-stationarity corrected cluster size
% p-values. 
%
% FORMAT: spm_results_ui_nS
%
%----------------------------------------------------------------------
% DETAILS:
% This function assess the results by calling spm_results_ui.m, then 
% calls a function spm_list_nS.m which calculates cluster p-values 
% adjusted for local smoothness differences (or non-stationarity). 
% Function spm_results_ui produces a variable called xSPM containing 
% all the information necessary for statistical inference. This 
% program uses xSPM (and the graphical handle for the results windown 
% hReg) to call spm_list_nS.m, which generates a list of p-values for 
% clusters adjusted for non-stationarity. 
%
% For more technical details on p-value calculation under non-
% stationarity, see spm_list_nS.m and stat_thresh.m distributed with 
% this package.
%
%---------------------------------------------------------------------
% Version 0.76 beta, March 28, 2007 by Satoru Hayasaka
%

%-first, assessing the results
[hReg,xSPM,SPM] = spm_results_ui;

%-then calling the non-stationary correction
spm_list_nS('list',SPM.xVol.VRpv,xSPM,hReg);

