
%% setup
close all;

var_set = {'y','c','i','l','k'};
varNE_set = {'yNE', 'cNE', 'iNE', 'lNE'};
shock_set = {'eps_a', 'eps_z', 'eps_i', 'eps_yNE', 'eps_cNE', 'eps_iNE', ...
    'eps_lNE',  'yNE_noise', 'cNE_noise','iNE_noise', 'lNE_noise'};

% fox underscore
shock_set_fixed = [];
for idx = 1:length(shock_set)
    shock_set_fixed{idx} = fix_underscore(shock_set{idx});
end

%% var and shock names order
RES.dif.var_order = NaN*zeros(length(var_set),1);
for i_var = 1:length(var_set)
    for ii_var = 1:length(RES.dif.M_.endo_names)
        temp =  RES.dif.M_.endo_names{ii_var};

        if strcmp(var_set{i_var},temp)
            RES.dif.var_order(i_var) = ii_var;
        end
    end
end

RES.lev.var_order = NaN*zeros(length(var_set),1);
for i_var = 1:length(var_set)
    for ii_var = 1:length(RES.lev.M_.endo_names)
        temp =  RES.lev.M_.endo_names{ii_var};

        if strcmp(var_set{i_var},temp)
            RES.lev.var_order(i_var) = ii_var;
        end
    end
end

% get means
for i_var = 1:length(var_set)
    RES.dif.var_mean(i_var) =  RES.dif.oo_.steady_state(RES.dif.var_order(i_var));
    RES.lev.var_mean(i_var) =  RES.lev.oo_.steady_state(RES.lev.var_order(i_var));
end




RES.dif.shock_order = NaN*zeros(length(shock_set),1);
for i_var = 1:length(shock_set)
    for ii_var = 1:length(RES.dif.M_.exo_names)
        temp =  RES.dif.M_.exo_names{ii_var};

        if strcmp(shock_set{i_var},temp)
            RES.dif.shock_order(i_var) = ii_var;
        end
    end
end

RES.lev.shock_order = NaN*zeros(length(shock_set),1);
for i_var = 1:length(shock_set)
    for ii_var = 1:length(RES.lev.M_.exo_names)
        temp =  RES.lev.M_.exo_names{ii_var};

        if strcmp(shock_set{i_var},temp)
            RES.lev.shock_order(i_var) = ii_var;
        end
    end
end


 
% M_.exo_names  


%% ge the dates
data = readtable(DATA);
% X = 1:length(data.L_obs);
% lX = length(X);
% fig = figure(1)
% lines = plot(X',[data.log_y_obs,data.log_c_obs,data.log_i_obs],'LineWidth',2);
% xticks(1:8:lX);
% xticklabels(data.date(1:8:lX))


%% smoothed endogenous variables comparison
for i_var = 1:5

    Y1 = RES.dif.oo_.SmoothedVariables.(var_set{i_var});
    Y1 = (Y1-RES.dif.var_mean(i_var))/RES.dif.var_mean(i_var);
    
    Y2 = RES.lev.oo_.SmoothedVariables.(var_set{i_var});
    Y2 = (Y2-RES.lev.var_mean(i_var))/RES.lev.var_mean(i_var);

    YY=[Y1 Y2];
    XX = 1:length(YY);

    fig = figure(i_var)
    lines = plot(XX,YY,'LineWidth',2);
    set(lines(2), 'linestyle','--');

    grid on; 
    legend('diff','levels');
    title(var_set{i_var})

    hline(0,'-k')
    
    lX = length(XX);
    xticks(1:8:lX);
    xticklabels(data.date(1:8:lX))

    name_graph = [FOLDER.work,'fig/smoothed_comp_',var_set{i_var},'.pdf'];
    figuresize(14,9,'centimeters');
    print(fig,'-dpdf', '-r300', name_graph);    

end

%% smoothed NE variables comparison
% ?
%% variance decomposition endogenous variables
var_decomp1 = [];
var_decomp2 = [];
var_decomp = [];
for i_var = 1:5
    for i_shock = 1:length(shock_set)
        var_decomp1(i_var,i_shock) = ...
            RES.dif.oo_.variance_decomposition(...
                RES.dif.var_order(i_var),RES.dif.shock_order(i_shock));
        var_decomp2(i_var,i_shock) = ...
            RES.lev.oo_.variance_decomposition(...
                RES.lev.var_order(i_var),RES.lev.shock_order(i_shock));        
    end
end

var_decomp(1,:,:) = var_decomp1;
var_decomp(2,:,:) = var_decomp2;

for i_var = 1:5
    fig = figure(10+i_var)
    bar(squeeze(var_decomp(:,i_var,1:3))')
    xticklabels(shock_set_fixed);
    title(var_set{i_var})
    legend('diff','levels');
    grid on; 

    name_graph = [FOLDER.work,'fig/var_decomp_',var_set{i_var},'.pdf'];
    figuresize(14,9,'centimeters');
    print(fig,'-dpdf', '-r300', name_graph);


end

%% conditional variance decomposition observables variables

cond_var_decomp1 = [];
cond_var_decomp2 = [];
cond_var_decomp = [];


% % oo_.conditional_variance_decomposition  
% 
for i_hor = 1:3
    for i_var = 1:4
        for i_shock = 1:length(shock_set)
            cond_var_decomp1(i_hor,i_var,i_shock) = ...
                RES.dif.oo_.conditional_variance_decomposition(...
                    i_var,i_hor,RES.dif.shock_order(i_shock));

            cond_var_decomp2(i_hor,i_var,i_shock) = ...
                RES.lev.oo_.conditional_variance_decomposition(...
                    i_var,i_hor,RES.lev.shock_order(i_shock));        
        end
    end
end

cond_var_decomp(1,:,:,:) = cond_var_decomp1;
cond_var_decomp(2,:,:,:) = cond_var_decomp2;
% 
% 
% 
% for i_var = 1:4
%     figure(20+i_var)
%     bar(squeeze(cond_var_decomp(:,1,i_var,:))')
%     xticklabels(shock_set_fixed);
%     title(var_set{i_var})
%     legend('diff','levels');
%     legend('location','NorthWest');
%     grid on; 
% 
%     axis([0.5 11.5 0 1 ]);
% 
%     vline(7.5,'-k');
%     vline(3.5,'-k');
% end
% 
% for i_var = 1:4
%     figure(30+i_var)
%     bar(squeeze(cond_var_decomp(:,2,i_var,:))')
%     xticklabels(shock_set_fixed);
%     title(var_set{i_var})
%     legend('diff','levels');
%     legend('location','NorthWest');
%     grid on; 
% 
%     axis([0.5 11.5 0 1 ]);
% 
%     vline(7.5,'-k');
%     vline(3.5,'-k');
% end
% 
% for i_var = 1:4
%     figure(40+i_var)
%     bar(squeeze(cond_var_decomp(:,3,i_var,:))')
%     xticklabels(shock_set_fixed);
%     title(var_set{i_var})
%     legend('diff','levels');
%     legend('location','NorthWest');
%     grid on; 
% 
%     axis([0.5 11.5 0 1 ]);
% 
%     vline(7.5,'-k');
%     vline(3.5,'-k');
% end


for i_var = 1:4
    fig = figure(20+i_var);
    temp = reshape(squeeze(cond_var_decomp(:,:,i_var,:)),3*2,11);
    temp2 = NaN*temp;
    temp2(1:3,:) = temp([1 3 5],:);
    temp2(4:6,:) = temp([2 4 6],:);
    temp2 = temp2(:,[1:3,3+i_var,7+i_var]);
    bar(temp2')
    
    xticklabels(shock_set_fixed([1:3,3+i_var,7+i_var]));
    title(var_set{i_var})
    % legend('diff 1q','levels 1q','diff 5q','levels 5q','diff 16q','levels 16q');
    legend('diff 1q','diff 5q','diff 16q','levels 1q','levels 5q','levels 16q');
    legend('location','NorthWest');
    grid on; 

    axis([0.5 5.5 0 1 ]);
    
    vline(4.5,'-k');
    vline(3.5,'-k');


    name_graph = [FOLDER.work,'fig/cond_var_decomp_',var_set{i_var},'.pdf'];
    figuresize(14,9,'centimeters');
    print(fig,'-dpdf', '-r300', name_graph);


end