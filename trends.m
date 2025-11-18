
% variables in DAG

% Y_detrend
% C_detrend
% I_detrend
% X_detrend
% M_detrend
% W_detrend
% Y_deflator_detrend
% C_deflator_detrend
% I_deflator_detrend
% H_detrend
% R_EA
% Y_EA_detrend
% Y_deflator_EA_detrend
% R_DK

%%
c1 = lines(1);
c2 = lines(2);
c2 = c2(2,:);
data = readtable('DSGE_DATA_2025_10_30_v3.csv');

X = 1:length(data.y_q_obs);
lX = length(X);

%%
YY = log([data.y_q_obs,data.c_q_obs,data.i_q_obs]);

fig = figure(1)

lines = plot(X,YY,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 5 8]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('log y','log c','log i');
legend('Location','southeast');

name_graph = 'trend_1_1.pdf';
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


fig = figure(2)

temp = [YY(:,1)/YY(1,1) YY(:,2)/YY(1,2) YY(:,3)/YY(1,3)]

lines = plot(X,temp,'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 0.98 1.18]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('log(y(t)/y(0))','log(c(t)/c(0))','log(i(t)/i(0))');
legend('Location','southeast');

name_graph = 'trend_1_2.pdf';
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

fig = figure(3)

temp = diff(YY,1);

lines = plot(X,[NaN,NaN,NaN;temp],'LineWidth',2);
xticks(1:8:lX);
xticklabels(data.date(1:8:lX))
axis([1 122 -0.25 0.25]);
grid on
set(lines(2), 'linestyle','--');
set(lines(3), 'linestyle','-.');
legend('log(y(t)/y(t-1))','log(c(t)/c(t-1))','log(i(t)/i(t-1))');
legend('Location','southeast');

name_graph = 'trend_1_3.pdf';
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);





%%


fig = figure(2)
lines = plot([data.pi_obs,data.r_obs],'LineWidth',2);
xticks(1:8:length(data.L_obs));
xticklabels(data.date(1:8:length(data.L_obs)))
grid on
hline(0,'-k')
set(lines(2), 'linestyle','--');
legend('pi','r');
legend('Location','southeast')

name_graph = ['trend_pi.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);

fig = figure(3)
lines = plot([data.L_obs],'LineWidth',2);
xticks(1:8:length(data.L_obs));
xticklabels(data.date(1:8:length(data.L_obs)))
grid on
% hline(0,'-k')
legend('l');
legend('Location','northwest');

name_graph = ['trend_l.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);


fig = figure(4)
lines = plot([data.X_over_Y,data.M_over_Y],'LineWidth',2);
xticks(1:8:length(data.L_obs));
xticklabels(data.date(1:8:length(data.L_obs)))
grid on
hline(1,'-k')
set(lines(2), 'linestyle','--');
legend('X/Y','M/Y');
legend('Location','northwest');

name_graph = ['trend_XY.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);



data = readtable('fred_data.csv');
X = 1:length(data.pi_dk);
dates = cellstr(datestr(data.date,'yyyy'));

fig = figure(5)
lines = plot([data.pi_dk,data.pi_eurozone,data.i_dk,data.i_eurozone],'LineWidth',2);
xticks(1:4:length(data.pi_dk));
xticklabels(dates(1:4:length(data.pi_dk)))




grid on
hline(1,'-k')
set(lines([2,4]), 'linestyle','--');
set(lines([1,2]), 'color',c1);
set(lines([3,4]), 'color',c2);
legend('inf, DK','inf, EUROZONE','i, DK','i, EUROZONE');
legend('Location','northeast');

name_graph = ['trend_pi2.pdf'];
figuresize(14,9,'centimeters');
print(fig,'-dpdf', '-r300', name_graph);
