% close all;
%% Pitch Axis
root_dir = matlab.project.rootProject().RootFolder;
p_sim_fn = sprintf('%s\\data\\Pitch_Sample.xlsx', root_dir);
e_sim_fn = sprintf('%s\\data\\Elevation_Sample.xlsx', root_dir);

data_p = readmatrix(p_sim_fn);
data_e = readmatrix(e_sim_fn);
ttTest = data_p(:, 1).';

p_log_test = pi/180 * data_p(:, 2).';
p_log_smoothed = movmean(p_log_test, 50);

e_log_test = pi/180 * data_e(:, 2).';
e_log_smoothed = movmean(e_log_test, 50);

tsim = max(ttTest); % Simulation time (s)
nsim = round(tsim / Ts) + 1; % Simulation steps

uTest = data_p(:, 3:4).';
uTestts = timeseries(uTest, ttTest);

x_log_li = zeros(8, nsim);
x_log_li_e = zeros(8, nsim);
x_log_nl = zeros(8, nsim);

% Initial conditions for full state
x_li = x0;
x_nl = x0 + [zeros(6, 1); F_e_real; F_e_real];

x_li_e = [e_log_test(1); zeros(7, 1)];

x_log_li(:, 1) = x_li;
x_log_li_e(:, 1) = x_li_e;

A = sysdt_comb.A;
B = sysdt_comb.B;

for i = 2:nsim

    % Full state
    x_li = A*x_li + B*(uTest(:, i-1));
    x_nl = model_nlRK4(f_comb_nl_handle, x_nl, uTest(:, i-1)+3.4, Ts);
    
    % Elevation only
    x_li_e = A*x_li_e + B*(uTest(2, i-1)*ones(2, 1) - 7.8); % E test only uses Ub

    x_log_li(:, i) = x_li;
    x_log_nl(:, i) = x_nl;
    x_log_li_e(:, i) = x_li_e;

end

Wp = p_log_smoothed - x_log_li(2,:);
We = e_log_smoothed - x_log_li_e(1, :);

% figure;
% plot(ttTest, Wp)

Qp = cov(Wp(round(15/Ts):end)) % Take test after a delay when the speed has settled
Qe = cov(We(round(15/Ts):end)) % Take test after a delay when the speed has settled
Qt = 3

Qx = [Qp Qe Qt];
Qv = 0.5*Qx;

Q_kalman = diag([Qx, Qv, 1 1, 0.1, 0.1])

% figure;
% hold on; grid on;
% plot(ttTest, p_log_smoothed)
% plot(ttTest, x_log_li(2, :))
% legend('Test', 'Model')
% title('Pitch model vs Test')
% 
% figure;
% hold on; grid on;
% plot(ttTest, e_log_smoothed)
% plot(ttTest, x_log_li_e(1, :))
% legend('Test', 'Model')
% title('Elevation model vs Test')


% figure;
% plotTimeseries(ttTest, x_log_li(1:3, :), 'Title', 'x_{comb} Linear - Positions')
% 
% figure;
% plotTimeseries(ttTest, x_log_nl(1:3, :), 'Title', 'x_{comb} Nonlinear - Positions')

% figure;
% plotTimeseries(ttTest, uTest, 'Title', 'Inputs')