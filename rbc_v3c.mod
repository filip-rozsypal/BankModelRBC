% Basic RBC Model 
%

close all;
set(groot,'DefaultFigureWindowStyle','docked');
%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var l d_y_obs d_i_obs d_c_obs l_obs mu y c k i z a yNE iNE lX cNE;

varexo eps_a eps_i eps_z  ; 
varexo eps_yNE eps_iNE eps_lX eps_cNE;
varexo y_obs_noise i_obs_noise c_obs_noise l_obs_noise;


varobs d_y_obs d_i_obs d_c_obs l_obs;



parameters beta psi delta alpha sigma exo_gr_a  rho_a rho_z l_obs_const;
parameters rho_yNE rho_iNE rho_lX rho_cNE;
parameters exo_gr_yNE exo_gr_iNE exo_gr_cNE exo_lX;
options_.debug=1;

% observation_trends;
%     dY_obs(exo_gr_a);
% end;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

alpha   = 0.33;
beta    = 0.99;
delta   = 0.023;
psi     = 1.75;
sigma   = (0.007/(1-alpha));

exo_gr_a     = 0.02/4;
exo_gr_yNE     = 0;
exo_gr_iNE     = 0;
exo_gr_cNE     = 0;
exo_lX = 0;

rho_a = 0.95;
rho_z = 0.8;
rho_yNE = 0.8;
rho_iNE = 0.8;
rho_lX = 0.9;
rho_cNE = 0.9;

l_obs_const = 0.335;




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
    a = (1-rho_a) * exo_gr_a + rho_a*a(-1) + eps_a;    
    



    %% observational equations
    [name = 'obs: y']
    d_y_obs =  y - y(-1) + log(mu) + yNE-yNE(-1) + y_obs_noise; %d_y_obs_ME

    [name = 'obs: c']
    d_c_obs =  c - c(-1) + log(mu) + cNE-cNE(-1)+ c_obs_noise; %d_c_obs_ME;  
    
    [name = 'obs: i']
    d_i_obs = i  - i(-1) + log(mu)  + iNE-iNE(-1)+ i_obs_noise; %d_i_obs_ME 

    [name = 'obs: l']
    l_obs = -l_obs_const + l + lX+ l_obs_noise;    



    [name = 'unexplained y']
    yNE = (1-rho_yNE) * exo_gr_yNE  + rho_yNE * yNE(-1) + eps_yNE;

    [name = 'unexplained i']
    iNE = (1-rho_iNE) * exo_gr_iNE  + rho_iNE * iNE(-1) + eps_iNE;

    [name = 'unexplained c']
    cNE = (1-rho_cNE) * exo_gr_cNE  + rho_cNE * cNE(-1) + eps_cNE;    

    [name = 'unexplained l']
    lX = (1-rho_lX) * exo_lX  + rho_lX * lX(-1) + eps_lX;


end;


steady_state_model;

    mu_ss = exp(exo_gr_a);


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
    a = exo_gr_a;

    mu =  exp(exo_gr_a);

    d_y_obs = exo_gr_a + exo_gr_yNE;
    d_c_obs = exo_gr_a + exo_gr_cNE;
    d_i_obs = exo_gr_a + exo_gr_iNE;

    l_obs = -l_obs_const + l;

    yNE = exo_gr_yNE;
    iNE = exo_gr_iNE;
    iNE = exo_gr_cNE;
    lX = exo_lX;
    cNE = exo_gr_cNE;


end;



% steady(nocheck);
steady;
resid; 
shocks;

    var eps_a;
    stderr 0.002;

 

    var eps_z;
    stderr 0.05; 

    var eps_i;
    stderr 0.015;      

    var y_obs_noise;
    stderr 0.001;  

    var i_obs_noise;
    stderr 0.015;  

    var c_obs_noise;
    stderr 0.001;  

    var l_obs_noise;
    stderr 0.02;      

    var eps_yNE;
    stderr 0.001;    

    var eps_iNE;
    stderr 0.002; 

    var eps_lX;
    stderr 0.002;  

    var eps_cNE;
    stderr 0.001;        
 
    
end;

estimated_params; 

    rho_z,  NORMAL_PDF, 0.85, 0.01;
    rho_a,  NORMAL_PDF, 0.85, 0.01;
    rho_yNE, NORMAL_PDF, 0.85, 0.01;
    rho_iNE, NORMAL_PDF, 0.85, 0.01;
    rho_lX, NORMAL_PDF, 0.85, 0.01;
    rho_cNE, NORMAL_PDF, 0.85, 0.01;    

    exo_gr_a,   NORMAL_PDF, 0.02/4, 0.001;
    exo_gr_yNE,  NORMAL_PDF, 0, 0.005;
    exo_gr_iNE,  NORMAL_PDF, 0, 0.005;
    exo_lX,     NORMAL_PDF, 0, 0.01;    
    exo_gr_cNE,  NORMAL_PDF, 0, 0.005;    


    l_obs_const, NORMAL_PDF, 0.335, 0.05;

    stderr eps_z,  0.025,  inv_gamma_pdf, 0.02, 0.005; 
    stderr eps_a,  0.025,  inv_gamma_pdf, 0.005, 0.005; 
    stderr eps_i,  0.025,  inv_gamma_pdf, 0.01, 0.01; 

    % stderr eps_yNE, 0.025,  inv_gamma_pdf, 0.0100, 0.1;  
    % stderr eps_iNE, 0.025,  inv_gamma_pdf, 0.0500, 0.5;
    % stderr eps_lX, 0.005,  inv_gamma_pdf, 0.0100, 0.1;    
    % stderr eps_cNE, 0.010,  inv_gamma_pdf, 0.0100, 0.1;       

end;
% calib_smoother(datafile='DSGE_DATA_2025_09_25_v3.csv',diffuse_filter,first_obs=2) dY_obs y c l;


estimation(datafile='DSGE_data', mode_compute=5,
    first_obs=2, diffuse_filter,
    optim=('TolFun',1e-5), irf=0,nobs =99,mh_replic = 30000) y i c yNE iNE cNE;
shock_decomposition d_y_obs d_c_obs d_i_obs l_obs y c i l;

%----------------------------------------------------------------
% 5. Some Results
%----------------------------------------------------------------


%  DSGE_DATA_2025_09_25_v2
% data_in


%%

% data = readtable('DSGE_DATA_2025_09_25_v2.csv')
% data = readtable('DSGE_DATA_2025_09_25_v2.xlsx')
% mean(data.dY_obs(2:end))