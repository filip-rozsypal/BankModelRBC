% Basic RBC Model 
%

close all;
set(groot,'DefaultFigureWindowStyle','docked');
%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var d_log_y_q_obs d_log_c_q_obs d_log_i_q_obs d_log_emp_heads_obs;
var l mu y c k i z a;
var yNE iNE lNE cNE;

varexo eps_a eps_z eps_i; 
varexo eps_yNE eps_cNE eps_iNE eps_lNE;
varexo yNE_noise cNE_noise iNE_noise lNE_noise;

varobs d_log_y_q_obs d_log_c_q_obs d_log_i_q_obs d_log_emp_heads_obs;

parameters beta psi delta alpha sigma GR_a  rho_a rho_z;
parameters rho_yNE rho_iNE rho_lNE rho_cNE;
parameters GR_yNE GR_cNE GR_iNE  GR_lNE;
options_.debug=1;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

alpha   = 0.33;
beta    = 0.99;
delta   = 0.023;
psi     = 1.75;
sigma   = (0.007/(1-alpha));

GR_a     = 0.0056;

GR_yNE = -0.0013;
GR_iNE =  0.0041;
GR_cNE = -0.0010;
GR_lNE =  0.0014;

rho_a   = 0.7857;
rho_z   = 0.8551;
rho_yNE = 0.8368;
rho_iNE = 0.8307;
rho_lNE = 0.8363;
rho_cNE = 0.8337;





%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------



model; 
    [name = 'Euler']
    (1/c) = beta*(1/c(+1)/mu(+1))*(1-delta+alpha*y(+1)*mu(+1)/k);
    
    [name = 'Labor supply']    
    psi*c/(1-l) = (1-alpha)*y/l;
    
    [name = 'budget constraint']    
    c + i = y;
    
    [name = 'output']    
    y = mu^(-alpha)*exp(z)*(k(-1)^alpha)*l^(1-alpha);
    
    [name = 'investment']
    i = exp(eps_i)*k-(1-delta)*k(-1)/mu;   

    [name = 'transitory productivity process']
    z = rho_z*z(-1) + eps_z ;   %     
    
    [name = 'mu']
    log(mu) = a;

    [name = 'a']
    a = (1-rho_a) * GR_a + rho_a*a(-1) + eps_a;    

 
    %% NotExplained components' equations
    [name = 'unexplained y']
    yNE = (1-rho_yNE) * GR_yNE  + rho_yNE * yNE(-1) + eps_yNE;

    [name = 'unexplained i']
    iNE = (1-rho_iNE) * GR_iNE  + rho_iNE * iNE(-1) + eps_iNE;

    [name = 'unexplained c']
    cNE = (1-rho_cNE) * GR_cNE  + rho_cNE * cNE(-1) + eps_cNE;    

    [name = 'unexplained l']
    lNE = (1-rho_lNE) * GR_lNE  + rho_lNE * lNE(-1) + eps_lNE;

    %% observational equations
    [name = 'obs: y']
    d_log_y_q_obs = y - y(-1) + log(mu) + yNE + yNE_noise - yNE_noise(-1);

    [name = 'obs: c']
    d_log_c_q_obs = c - c(-1) + log(mu) + cNE + cNE_noise - cNE_noise(-1);  
    
    [name = 'obs: i']
    d_log_i_q_obs = i - i(-1) + log(mu) + iNE + iNE_noise - iNE_noise(-1); 

    [name = 'obs: l']
    d_log_emp_heads_obs = l-l(-1) + lNE + lNE_noise - lNE_noise(-1);       


end;


steady_state_model;
    mu_ss = exp(GR_a);

    l_over_k_ss = 1/mu_ss* (  (mu_ss-beta*(1-delta))/(alpha*beta) )^(1/(1-alpha));

    const0 = mu_ss^(-alpha)*(l_over_k_ss^(1-alpha));
    const1 = (mu_ss-1+delta)/mu_ss;
    const2 = (const0-const1)/const0;
    const3 = (1-alpha)/psi;
    const4 = const3/(const2+const3);

    l = const4;
    k = l/l_over_k_ss;
    i = (mu_ss-1+delta)/mu_ss*k;
    y = mu_ss^(-alpha)*k^alpha*l^(1-alpha); 
    c = y-i;

    z = 0;
    a = GR_a;

    mu =  exp(GR_a);

    d_log_y_q_obs = GR_a + GR_yNE;
    d_log_c_q_obs = GR_a + GR_cNE;
    d_log_i_q_obs = GR_a + GR_iNE;
    d_log_emp_heads_obs =  GR_lNE;

    yNE = GR_yNE;
    cNE = GR_cNE;    
    iNE = GR_iNE;
    lNE = GR_lNE;
end;



% steady(nocheck);
steady;
resid; 
shocks;
    var eps_a;
    stderr 0.0029;

    var eps_z;
    stderr 0.0046; 

    var eps_i;
    stderr 0.0045;  
  
    %% NE compomenents
    % AR1 component
    var eps_yNE;
    stderr 0.0027;    

    var eps_iNE;
    stderr 0.0154;  

    var eps_lNE;
    stderr 0.0026;   

    var eps_cNE;
    stderr 0.0032;   

    % noise
    var yNE_noise;
    stderr 0.0025;  

    var iNE_noise;
    stderr 0.0422;  

    var cNE_noise;
    stderr 0.0062;  

    var lNE_noise;
    stderr 0.0021;      
end;

estimated_params; 

    rho_z,  NORMAL_PDF, 0.85, 0.015;
    rho_a,  NORMAL_PDF, 0.85, 0.05;

    rho_yNE, NORMAL_PDF, 0.85, 0.03;
    rho_iNE, NORMAL_PDF, 0.85, 0.03;
    rho_lNE, NORMAL_PDF, 0.85, 0.03;
    rho_cNE, NORMAL_PDF, 0.85, 0.03;    

    GR_a,    NORMAL_PDF, 0.02/4, 0.002;
    GR_yNE,  NORMAL_PDF, 0, 0.005;
    GR_iNE,  NORMAL_PDF, 0.005, 0.005;
    GR_lNE,  NORMAL_PDF, 0.001, 0.01;    
    GR_cNE,  NORMAL_PDF, 0, 0.005;    

    stderr eps_z,  0.025,  inv_gamma_pdf, 0.02, 0.025; 
    stderr eps_a,  0.025,  inv_gamma_pdf, 0.005, 0.01; 
    stderr eps_i,  0.025,  inv_gamma_pdf, 0.01, 0.01; 

    stderr eps_yNE, 0.025,  inv_gamma_pdf, 0.0100, 0.1;  
    stderr eps_iNE, 0.025,  inv_gamma_pdf, 0.0500, 0.5;
    stderr eps_lNE, 0.005,  inv_gamma_pdf, 0.0100, 0.1;    
    stderr eps_cNE, 0.010,  inv_gamma_pdf, 0.0100, 0.1;     

    stderr iNE_noise,  inv_gamma_pdf, 0.025, 0.2; 
    stderr lNE_noise,  inv_gamma_pdf, 0.005, 0.1; 
    stderr yNE_noise,  inv_gamma_pdf, 0.005, 0.1; 
    stderr cNE_noise,  inv_gamma_pdf, 0.005, 0.1;     

end;
% calib_smoother(datafile='DSGE_DATA_2025_10_30_v3.csv',diffuse_filter,first_obs=2) dY_obs y c l;


estimation(datafile='DSGE_DATA_2025_10_30_v3', mode_compute=5,
    first_obs=2, diffuse_filter,
    optim=('TolFun',1e-5), irf=0,nobs =99,mh_replic = 150000) y i c yNE iNE cNE;
shock_decomposition d_log_y_q_obs d_log_c_q_obs d_log_i_q_obs d_log_emp_heads_obs 
    z a y c k i l
    yNE  cNE  iNE lNE;

%----------------------------------------------------------------
% 5. Some Results
%----------------------------------------------------------------


%  DSGE_DATA_2025_09_25_v2
% data_in


%%

% data = readtable('DSGE_DATA_2025_09_25_v2.csv')
% data = readtable('DSGE_DATA_2025_09_25_v2.xlsx')
% mean(data.dY_obs(2:end))