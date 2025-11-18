
% variables in DAG

% Y_detrend
% C_detrend
% I_detrend

% X_detrend
% M_detrend

% W_detrend

% H_detrend

% Y_deflator_detrend
% C_deflator_detrend
% I_deflator_detrend

% R_EA
% Y_EA_detrend
% Y_deflator_EA_detrend
% R_DK

%%
% c1 = lines(1);
% c2 = lines(2);
% c2 = c2(2,:);
data = readtable('DSGE_DATA_2025_10_30_v3.csv');

X = 1:length(data.y_q_obs);
lX = length(X);

%%
YY = log([data.y_q_obs,data.c_q_obs,data.i_q_obs,data.y_q_ea_obs/1000]);

fig = figure(1)

lines = plot(X,YY,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 5 8]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('log y','log c','log i','log (y_{eurozone}/1000)');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_1_1.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


fig = figure(2)

temp = [YY(:,1)/YY(1,1) YY(:,2)/YY(1,2) YY(:,3)/YY(1,3) YY(:,4)/YY(1,4)]

lines = plot(X,temp,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.98 1.18]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('log y','log c','log i','log y_{eurozone}/1000');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_1_2.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

fig = figure(3)

temp = diff(YY,1);

lines = plot(X,[NaN,NaN,NaN,NaN;temp],'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 -0.25 0.25]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('log y','log c','log i','log y_{eurozone}/1000');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_1_3.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


%%
YY = log([data.y_q_obs,data.x_q_obs,data.m_q_obs]);

fig = figure(4)

lines = plot(X,YY,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 5.9 8]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('log y','log x','log m');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_2_1.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


fig = figure(5)

temp = [YY(:,1)/YY(1,1) YY(:,2)/YY(1,2) YY(:,3)/YY(1,3)]

lines = plot(X,temp,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.99 1.225]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('log(y(t)/y(0))','log(x(t)/x(0))','log(m(t)/m(0))');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_2_2.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

fig = figure(6)

temp = diff(YY,1);

lines = plot(X,[NaN,NaN,NaN;temp],'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 -0.25 0.25]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('log(y(t)/y(t-1))','log(x(t)/x(t-1))','log(m(t)/m(t-1))');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_2_3.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


%%
YY = ([data.y_p_obs,data.c_p_obs,data.i_p_obs]);

fig = figure(7)

lines = plot(X,YY,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.6 1.3]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('P_y','P_c','P_i');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_3_1.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


fig = figure(8)

temp = [YY(:,1)/abs(YY(1,1)) YY(:,2)/abs(YY(1,2)) YY(:,3)/abs(YY(1,3))]

lines = plot(X,temp,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.9 1.9]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('P_y','P_c','P_i');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_3_2.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

fig = figure(9)

temp = diff(YY,1);

lines = plot(X,[NaN,NaN,NaN;temp],'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 -0.25 0.25]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('P_y','P_c','P_i');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_3_3.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


%%
%%
YY = ([data.y_p_obs,data.x_p_obs,data.m_p_obs,data.y_p_ea_obs]);

fig = figure(10)

lines = plot(X,YY,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.6 1.5]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('P_y','P_x','P_m','P_{ea}');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_4_1.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


fig = figure(11)
temp = [YY(:,1)/abs(YY(1,1)) YY(:,2)/abs(YY(1,2)) YY(:,3)/abs(YY(1,3)) YY(:,4)/abs(YY(1,4))]

lines = plot(X,temp,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.9 2]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('P_y','P_x','P_m','P_{ea}');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_4_2.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

fig = figure(12)

temp = diff(YY,1);

lines = plot(X,[NaN,NaN,NaN,NaN;temp],'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 -0.25 0.25]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('P_y','P_x','P_m','P_{ea}');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_4_3.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


%%
YY = log([data.pop_y16_66_obs,data.emp_private_nonfarm_hours_obs,data.emp_private_nonfarm_heads_obs,data.emp_hours_obs,data.emp_heads_obs]);

fig = figure(13)

lines = plot(X,YY,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 12.5 15.5]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('log(population)','log(prvt nonfarm hours)','log(prvt nonfarm heads)','log(hours)','log(heads)');
legend('Location','east');

name_graph = [FOLDER.work,'fig/trend_5_1.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


fig = figure(14)
temp = [YY(:,1)/abs(YY(1,1)) YY(:,2)/abs(YY(1,2)) YY(:,3)/abs(YY(1,3)) YY(:,4)/abs(YY(1,4))  YY(:,5)/abs(YY(1,5))]

lines = plot(X,temp,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.998 1.025]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('log(population)','log(prvt nonfarm hours)','log(prvt nonfarm heads)','log(hours)','log(heads)');
legend('Location','NorthWest');

name_graph = [FOLDER.work,'fig/trend_5_2.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

fig = figure(15)

temp = diff(YY,1);

lines = plot(X,[NaN,NaN,NaN,NaN,NaN;temp],'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 -0.06 0.06]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('log(population)','log(prvt nonfarm hours)','log(prvt nonfarm heads)','log(hours)','log(heads)');
legend('Location','South');

name_graph = [FOLDER.work,'fig/trend_5_3.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);




%%


YY = ([data.w_manufacturing_hourly_obs,data.w_private_monthly_obs,data.w_private_nonfarm_hourly_obs,data.y_p_obs]);

fig = figure(16)

lines = plot(X,YY,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.4 1.3]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('w man hourly','w prvt monthly','w prvt nonfarm hourly','P_y');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_6_1.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


fig = figure(17)

temp = [YY(:,1)/YY(1,1) YY(:,2)/YY(1,2) YY(:,3)/YY(1,3) YY(:,4)/YY(1,4)]

lines = plot(X,temp,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 1 2.8]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('w man hourly','w prvt monthly','w prvt nonfarm hourly','P_y');
legend('Location','southeast');

name_graph = [FOLDER.work,'fig/trend_6_2.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

fig = figure(18)

temp = diff(YY,1);

lines = plot(X,[NaN,NaN,NaN,NaN;temp],'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 -0.03 0.08]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
set(lines(4), 'linestyle',':');
legend('w man hourly','w prvt monthly','w prvt nonfarm hourly','P_y');
legend('Location','NorthWest');

name_graph = [FOLDER.work,'fig/trend_6_3.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

%%
YY = [data.r_ea_obs/100,[NaN;NaN;NaN;NaN;data.y_p_ea_obs(5:end) - data.y_p_ea_obs(1:end-4)]];

fig = figure(19)

lines = plot(X,YY,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 -0.01 0.08]);
grid on
set(lines(2), 'linestyle','--');

legend('r_{eurozone}','\pi^{4q}_{eurozone}');
legend('Location','north');

hline(0,'-k');

name_graph = [FOLDER.work,'fig/trend_7_1.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


% fig = figure(20)
% 
% temp = [YY(:,1)/YY(1,1) YY(:,2)/YY(1,2)]
% 
% lines = plot(X,temp,'LineWidth',2);
% xticks(1:8:lX);
% xticklabels(data.date(1:8:lX))
% axis([1 122 0.98 1.18]);
% grid on
% set(lines(2), 'linestyle','--');
% 
% legend('r_{eurozone}','\pi^{4q}_{eurozone}');
% legend('Location','southeast');
% 
% name_graph = [FOLDER.work,'fig/trend_7_2.pdf'];
% figuresize(14,9,'centimeters');
% print(fig,'-dpdf', '-r300', name_graph);
% 
% fig = figure(21)
% 
% temp = diff(YY,1);
% 
% lines = plot(X,[NaN,NaN,NaN;temp],'LineWidth',2);
% xticks(1:8:lX);
% xticklabels(data.date(1:8:lX))
% axis([1 122 -0.25 0.25]);
% grid on
% set(lines(2), 'linestyle','--');
% 
% legend('r_{eurozone}','\pi^{4q}_{eurozone}');
% legend('Location','southeast');
% 
% name_graph = [FOLDER.work,'fig/trend_7_3.pdf'];
% figuresize(14,9,'centimeters');
% print(fig,'-dpdf', '-r300', name_graph);


% 
% 
% 
% %%
% fig = figure(2)
% lines = plot([data.pi_obs,data.r_obs],'LineWidth',2);
% xticks(1:8:length(data.L_obs));
% xticklabels(data.date(1:8:length(data.L_obs)))
% grid on
% hline(0,'-k')
% set(lines(2), 'linestyle','--');
% legend('pi','r');
% legend('Location','southeast')
% 
% name_graph = [FOLDER.work,'fig/trend_pi.pdf'];
% figuresize(14,9,'centimeters');
% print(fig,'-dpdf', '-r300', name_graph);
% 
% fig = figure(3)
% lines = plot([data.L_obs],'LineWidth',2);
% xticks(1:8:length(data.L_obs));
% xticklabels(data.date(1:8:length(data.L_obs)))
% grid on
% % hline(0,'-k')
% legend('l');
% legend('Location','northwest');
% 
% name_graph = [FOLDER.work,'fig/trend_l.pdf'];
% figuresize(14,9,'centimeters');
% print(fig,'-dpdf', '-r300', name_graph);
% 
% 
% fig = figure(4)
% lines = plot([data.X_over_Y,data.M_over_Y],'LineWidth',2);
% xticks(1:8:length(data.L_obs));
% xticklabels(data.date(1:8:length(data.L_obs)))
% grid on
% hline(1,'-k')
% set(lines(2), 'linestyle','--');
% legend('X/Y','M/Y');
% legend('Location','northwest');
% 
% name_graph = [FOLDER.work,'fig/trend_XY.pdf'];
% figuresize(14,9,'centimeters');
% print(fig,'-dpdf', '-r300', name_graph);
% 
% 
% 
% data = readtable('fred_data.csv');
% X = 1:length(data.pi_dk);
% dates = cellstr(datestr(data.date,'yyyy'));
% 
% fig = figure(5)
% lines = plot([data.pi_dk,data.pi_eurozone,data.i_dk,data.i_eurozone],'LineWidth',2);
% xticks(1:4:length(data.pi_dk));
% xticklabels(dates(1:4:length(data.pi_dk)))
% 
% 
% 
% 
% grid on
% hline(1,'-k')
% set(lines([2,4]), 'linestyle','--');
% set(lines([1,2]), 'color',c1);
% set(lines([3,4]), 'color',c2);
% legend('inf, DK','inf, EUROZONE','i, DK','i, EUROZONE');
% legend('Location','northeast');
% 
% name_graph = [FOLDER.work,'fig/trend_pi2.pdf'];
% figuresize(14,9,'centimeters');
% print(fig,'-dpdf', '-r300', name_graph);
