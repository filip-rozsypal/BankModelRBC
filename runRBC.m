
%% settings

clear all;

% user
USER = 'Filip';
% USER = 'Rasmus';
% USER = 'Emil';
% USER = 'Jens';

% model
% MODEL = 'rbc_v4b2.mod'; % full estiamted model
% MODEL = 'rbc_v5_v0.mod';  % calibrated 1 observable version simpler NE term
% MODEL = 'rbc_v5_v1.mod';% calibrated 1 observable version RW+drift NE term
MODEL = 'rbc_v5_v3.mod';% calibrated 1 observable version RW+drift NE term



DATA = 'DSGE_DATA_2025_10_30_v2.csv';

run_dynare;



