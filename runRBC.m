
%% settings

clear all;

% select user
USER = 'Filip';
% USER = 'Rasmus';
% USER = 'Emil';
% USER = 'Jens';

% model
% MODEL = 'rbc_levels.mod'; % RBC estimated on levels
MODEL = 'rbc_diff.mod'; % RBC estimated on 1st differences


% MODEL = 'rbc_v5_v0.mod';  % calibrated 1 observable version simpler NE term
% MODEL = 'rbc_v5_v1.mod';% calibrated 1 observable version RW+drift NE term


DATA = 'DSGE_DATA_2025_10_30_v3.csv';

%% run the code
MODEL = 'rbc_diff.mod'; % RBC estimated on 1st differences
run_dynare;
RES.dif.oo_ = oo_;
RES.dif.M_ = M_;

MODEL = 'rbc_levels.mod'; % RBC estimated on 1st differences
run_dynare;
RES.lev.oo_ = oo_;
RES.lev.M_ = M_;

%% compare the results
run_comparison;
close all;
figure(1)
plot([RES.dif.oo_.SmoothedVariables.y RES.lev.oo_.SmoothedVariables.y])
legend('diff','levels');







