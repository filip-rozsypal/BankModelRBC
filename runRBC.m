
%% settings

clear all;

% select user
USER = 'Filip';
% USER = 'Rasmus';
% USER = 'Emil';
% USER = 'Jens';

% select model
MODEL = 'rbc_v4b2.mod'; % full estimated model
% MODEL = 'rbc_v5_v0.mod';  % calibrated 1 observable version simpler NE term
% MODEL = 'rbc_v5_v1.mod';% calibrated 1 observable version RW+drift NE term


DATA = 'DSGE_DATA_2025_10_30_v3.csv';

%% run the code
run_dynare;



