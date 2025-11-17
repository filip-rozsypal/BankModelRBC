
%% settings

clear all;

% user
USER = 'Filip';
% USER = 'Rasmus';
% USER = 'Emil';
% USER = 'Jens';

% model
MODEL = 'rbc_levels.mod'; % RBC estimated on levels
% MODEL = 'rbc_diff.mod'; % RBC estimated on 1st differences

% MODEL = 'rbc_v5_v0.mod';  % calibrated 1 observable version simpler NE term
% MODEL = 'rbc_v5_v1.mod';% calibrated 1 observable version RW+drift NE term




DATA = 'DSGE_DATA_2025_10_30_v3.csv';

run_dynare;



