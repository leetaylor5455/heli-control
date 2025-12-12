%% Show that the combined model is better than the original

% Parameters
% Ts      = 0.001;        % sampling time (example)
f_start = 0;          % Hz
f_end   = 1;           % Hz
A_min   = 0.3;          % minimum amplitude
A_max   = 10;           % maximum amplitude
tsim = 18;           % duration of sweep in seconds

% Time vector
tt_exp = 0:Ts:tsim;

% Raw chirp: sine between [-1, 1], frequency-swept
u_raw = chirp(tt_exp, f_start, tt_exp(end), f_end, 'linear');

% Scale to [A_min, A_max]
mid = (A_max + A_min)/2;
amp = (A_max - A_min)/2;

u = mid + amp * u_raw;

nsim = length(u);

% wn = sqrt(ksp / (2*m1));
% zeta = kdp / (2 * sqrt(ksp * 2*m1));
% wd = wn * sqrt(1 - zeta^2);
% fd = wd/(2*pi)

% f = 1/(2*pi * 0.87)

u_a = 4.7*cos(2*tt_exp) + 5;
u_b = 4.7*sin(2*tt_exp) + 5;

u_a_ts = timeseries(u_a, tt_exp);
u_b_ts = timeseries(u_b, tt_exp);

% u_sim = [u; zeros(1, nsim)];
u_sim = [u_a; u_b];

uTestts = timeseries(u_sim, tt_exp);

% figure
% plot(tt_exp, u_a)

nx_rb = size(A_rb_real, 1);
nx_comb = size(A_comb_real, 1);

x0_rb = zeros(nx_rb, 1);
x0_comb = zeros(nx_comb, 1);

x_rb_log = zeros(nx_rb, nsim);
x_comb_log = zeros(nx_comb, nsim);


% Setup state space models
Ad_rb = sysdt_rb.A;
Bd_rb = sysdt_rb.B;
Ad_comb = sysdt_comb.A;
Bd_comb = sysdt_comb.B;

for i = 1:nsim

    x_rb_log(:, i) = x0_rb;
    x_comb_log(:, i) = x0_comb;

    x0_rb = Ad_rb * x0_rb + Bd_rb * u_sim(:, i);
    x0_comb = Ad_comb * x0_comb + Bd_comb * u_sim(:, i);

end

%% Get test data
root_dir = matlab.project.rootProject().RootFolder;
p_sim_fn = sprintf('%s\\data\\Pitch_sine.xlsx', root_dir);

data_p = readmatrix(p_sim_fn);
p_log_test = pi/180 * data_p(:, 2).' - 0.1;
% p_log_smoothed = movmean(p_log_test, 20);
p_log_smoothed = p_log_test(1:round(tsim/Ts)+1);

figure
plot(tt_exp, p_log_smoothed, '-.', 'Color', 'black', 'LineWidth', 1)
hold on; grid on;
plot(tt_exp.', x_rb_log(2, :), 'LineWidth', 1)
plot(tt_exp.', x_comb_log(2, :), 'Color', [0 0.4470 0.7410], 'LineWidth', 1.5)
legend('Test (Raw)', 'Original Model', 'Augmented Model', ...
    'Location', 'southeast')
title('Pitch Models vs Test')
xlabel('Time (s)')
ylabel('Pitch (rad)')
ylim([-2.5 2])
set(gcf, 'position',[0, 0, 650, 300]) % Enlarge
matlab2tikz()

mse(x_rb_log(2, :), p_log_smoothed)
mse(x_comb_log(2, :), p_log_smoothed)