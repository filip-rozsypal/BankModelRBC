% Basic RBC Model 
% data in levels


close all;

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var log_y_q_obs  log_c_q_obs log_i_q_obs log_emp_heads_obs; %    
var yNE  cNE iNE lNE; %  
var l mu y c k i a z; % 
var a_innovation lNE_innovation iNE_innovation yNE_innovation cNE_innovation;

varexo eps_a    eps_z;  %     eps_i 
varexo eps_yNE  eps_cNE  eps_iNE eps_lNE; %l_obs_ME  
varexo iNE_noise lNE_noise yNE_noise cNE_noise;

varobs log_y_q_obs log_c_q_obs log_i_q_obs log_emp_heads_obs; %   




parameters beta psi delta alpha sigma  rho_a  rho_z; %l_obs_const 
parameters GR_a GR_l GR_iNE GR_yNE GR_cNE;
parameters a_start   rho_yNE rho_cNE rho_iNE rho_lNE; %
parameters cNE_start  yNE_start iNE_start lNE_start; %     

options_.debug=1;


%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

alpha   = 0.33;
beta    = 0.99;
delta   = 0.023;
psi     = 1.75;

sigma   = (0.007/(1-alpha));

% growth rate in
% output 0.0040 7.8/7.4/100 = 0.0105
% employment 0.0015 14.92/14.78/100 = 0.01
% investment 0.0064         6.1/5.5/100 = 0.0111
% consumption 0.0040
% 0.0039 mean(diff(oo_.SmoothedVariables.log_y_q_obs))
% 0.0062 mean(diff(oo_.SmoothedVariables.log_i_q_obs))
% 0.0039 mean(diff(oo_.SmoothedVariables.log_c_q_obs))
% 0.0014 mean(diff(oo_.SmoothedVariables.log_emp_heads_obs))
aa = 0.00403679164929413;
ii = 0.00564851251415636 ;


GR_a     = 0.002;% 0.016/4;  %7.8/7.4/100 = 0.0105
GR_l     = 0.0014; % 14.92/14.78/100 = 0.01
GR_iNE     = ii - GR_a; %6.1/5.5/100 = 0.0111
GR_yNE     = aa - GR_a; %6.1/5.5/100 = 0.0111
GR_cNE     = aa - GR_a; %6.1/5.5/100 = 0.0111

rho_a = 0.7;
rho_z = 0.8;


yNE_start = 6.4061; %log(1616.655276)-0.982;
cNE_start = 5.8755; %log(751.059164)-0.746;
iNE_start = 5.4744; %log(238.502500921713);
lNE_start = 14.5; %log(238.502500921713);

a_start = 10;

rho_yNE = 0.9;
rho_cNE = 0.9;
rho_iNE = 0.9;
rho_lNE = 0.9;



%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
% trend_component_model(model_name = toto, 
%     eqtags = ['level_productivity'], targets = ['level_productivity']);

observation_trends;
    log_y_q_obs(GR_a+GR_yNE);
    log_c_q_obs(GR_a+GR_cNE);
    log_i_q_obs(GR_a+GR_iNE);
    log_emp_heads_obs(GR_l);
end;

model; 

%% core model
    [name = 'Euler']
    (1/c) = beta*(1/c(+1)/mu(+1))*(1-delta+alpha*y(+1)*mu(+1)/k);
    
    [name = 'Labor supply']    
    psi*c/(1-l) = (1-alpha)*y/l;
    
    [name = 'budget constraint']    
    c + i = y;
    
    [name = 'output']    
    y = mu^(-alpha)*exp(z)*(k(-1)^alpha)*l^(1-alpha); %
    
    [name = 'investment']
    i = k-(1-delta)*k(-1)/mu;   %exp(eps_i)*

    [name = 'persistent productivity process']
    z = rho_z*z(-1) + eps_z;   
    
    [name = 'productivity innovation']
    a_innovation = (1-rho_a)*GR_a + rho_a*a_innovation(-1) + eps_a;

    [name = 'level_productivity']
    a = a(-1) + (1-rho_a)*GR_a + rho_a*a_innovation(-1) + eps_a;    

    [name = 'level_productivity_gr']
    log(mu) = a_innovation;       


    %% NotExplained components' equations
    % yNE = rho_yNE*yNE(-1) + eps_yNE;


    % cNE 
    [name = 'cNE innovation']
    cNE_innovation = (1-rho_cNE)*GR_cNE + rho_cNE*cNE_innovation(-1) + eps_cNE;

    [name = 'level_cNE']
    cNE = cNE(-1) + (1-rho_cNE)*GR_cNE + rho_cNE*cNE_innovation(-1) + eps_cNE;     


    % yNE 
    [name = 'yNE innovation']
    yNE_innovation = (1-rho_yNE)*GR_yNE + rho_yNE*yNE_innovation(-1) + eps_yNE;

    [name = 'level_yNE']
    yNE = yNE(-1) + (1-rho_yNE)*GR_yNE + rho_yNE*yNE_innovation(-1) + eps_yNE; 

    % iNE 
    [name = 'iNE innovation']
    iNE_innovation = (1-rho_iNE)*GR_iNE + rho_iNE*iNE_innovation(-1) + eps_iNE;

    [name = 'level_iNE']
    iNE = iNE(-1) + (1-rho_iNE)*GR_iNE + rho_iNE*iNE_innovation(-1) + eps_iNE;    

    % lNE 
    [name = 'l innovation']
    lNE_innovation = (1-rho_lNE)*GR_l + rho_lNE*lNE_innovation(-1) + eps_lNE;

    [name = 'level_l']
    lNE = lNE(-1) + (1-rho_lNE)*GR_l + rho_lNE*lNE_innovation(-1) + eps_lNE;    
    
    
    %% measurement equations
    [name = 'obs: y']
    log_y_q_obs  =  y  + a + yNE + yNE_start + yNE_noise; %

    [name = 'obs: c']
    log_c_q_obs  =  c  + a + cNE + cNE_start + cNE_noise; %
    
    [name = 'obs: i']
    log_i_q_obs = i  + a + iNE + iNE_start + iNE_noise;     %


    % [name = 'obs: l']
    log_emp_heads_obs = l + lNE + lNE_start + lNE_noise; 





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

    a_innovation = GR_a;
    lNE_innovation = GR_l;
    iNE_innovation = GR_iNE;
    yNE_innovation = GR_yNE;
    cNE_innovation = GR_cNE;

    z = 0;
    a = 0;

    mu =  exp(GR_a);

    yNE = 0;
    iNE = 0;
    cNE = 0;
    lNE = 0;

    log_y_q_obs = y+yNE_start;
    log_c_q_obs = c+cNE_start;
    log_i_q_obs = i+iNE_start;   
    log_emp_heads_obs = l + lNE_start;




end;

% % Initial values
histval;
% %     a(0) = -30;
% %     yNE(0) = 0;
%     k(-1) = 8;
    z(0)=0;
        z(-1)=0;
% %     l(0)=0.33;
end;

steady(nocheck);
% steady;
resid; 


shocks;

    var eps_a;
    stderr 0.02;

    var eps_z;
    stderr 0.02; 

    % var eps_i;
    % stderr 0.015;     

    var yNE_noise;
    stderr 0.001;

    var iNE_noise;
    stderr 0.001;

    var lNE_noise;
    stderr 0.001;    

    var eps_yNE;
    stderr 0.001;    

    var eps_cNE;
    stderr 0.001;

    var eps_iNE;
    stderr 0.005;    

    var eps_lNE;
    stderr 0.002;  

  
    % 
    % var l_obs_ME;
    % stderr 0.001;        
  
end;


estimated_params; 

    % rho_z, NORMAL_PDF, 0.75, 0.01;
    rho_a, 0.75, 0.4,0.9 , NORMAL_PDF, 0.85, 0.02;

    rho_yNE, NORMAL_PDF, 0.75, 0.01;
    rho_cNE, NORMAL_PDF, 0.75, 0.01;   
    rho_iNE, NORMAL_PDF, 0.75, 0.01;  

    % GR_a,  NORMAL_PDF, 0.0030, 0.0005;
    % GR_yNE,      NORMAL_PDF, 0.0010, 0.00025;
    % GR_l, NORMAL_PDF, 0.0015, 0.0005;
    % GR_iNE, NORMAL_PDF, 0.0034, 0.001;
    % GR_cNE, NORMAL_PDF,  0.0010, 0.00025;

    % l_obs_const, NORMAL_PDF, -0.335, 0.05;

    stderr eps_z,    0.025,    inv_gamma_pdf, 0.005, 0.02; 
    stderr eps_a,    0.05,    inv_gamma_pdf, 0.005, 0.05; 
    % stderr eps_i,    0.025,    inv_gamma_pdf, 0.00100, 0.01; 

    stderr eps_yNE,  inv_gamma_pdf, 0.005, 0.002; 
    stderr eps_cNE,  inv_gamma_pdf, 0.005, 0.002; 
    stderr eps_iNE,  inv_gamma_pdf, 0.020, 0.02; 
    stderr eps_lNE,  inv_gamma_pdf, 0.005, 0.001; 


    stderr iNE_noise,  inv_gamma_pdf, 0.02, 0.025; 
    stderr lNE_noise,  inv_gamma_pdf, 0.005, 0.002; 
    stderr yNE_noise,  inv_gamma_pdf, 0.005, 0.002; 
    stderr cNE_noise,  inv_gamma_pdf, 0.001, 0.002; 

 
    yNE_start, NORMAL_PDF, 6.4,0.25;
    cNE_start, NORMAL_PDF, 5.9,0.25;
    iNE_start, NORMAL_PDF, 5.5,0.25; 
    lNE_start, NORMAL_PDF, 14.4,0.25; 
    % a_start, NORMAL_PDF, 1,1;  


    


    % stderr eps_i,    0.025,    inv_gamma_pdf, 0.02500, 0.01; 
    % stderr noise_Y,    0.025,    inv_gamma_pdf, 0.02500, 0.01;     
end;
% calib_smoother(datafile='DSGE_DATA_2025_10_30_v2',
%     first_obs=2, diffuse_filter,nobs =99) y c a a_innovation;
% 

estimation(datafile='DSGE_DATA_2025_10_30_v2', mode_compute=5,
    first_obs=1, diffuse_filter, mh_nblocks = 1, mh_replic = 15000,
    optim=('TolFun',1e-7), irf=16,nobs = 99) y z c k a a_innovation;
% 
    shock_decomposition(diffuse_filter) z a 
        a_innovation lNE_innovation iNE_innovation yNE_innovation
        log_y_q_obs log_c_q_obs log_emp_heads_obs log_i_q_obs  
        yNE  cNE  iNE lNE
        y c k i l  ;

        stoch_simul(irf=8) z;

%emp_hours_obs  log_c_q_obs

figure(100)
plot(oo_.SmoothedVariables.z);
figure(101)
plot(oo_.SmoothedShocks.eps_z)

plot([oo_.SmoothedVariables.z(2:end), ...
    0.8*oo_.SmoothedVariables.z(1:end-1)+oo_.SmoothedShocks.eps_z(2:end),... 
    oo_.SmoothedShocks.eps_z(2:end)])