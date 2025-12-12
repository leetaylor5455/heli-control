data_test = readmatrix('data/traj_4.xlsx');
data_sim = readmatrix('data/traj_sim.xlsx');

bounds = 1:round(60/Ts);

ttt = data_test(bounds, 1);
Pt = data_test(bounds, 2);
Et = data_test(bounds, 3);
Tt = data_test(bounds, 4);
Ert = data_test(bounds,5);
Trt = data_test(bounds,6);
Uat = data_test(bounds,7);
Ubt = data_test(bounds,8);

tts = data_sim(:, 1);
Ps = data_sim(:, 4);
Es = data_sim(:, 2);
Tsi = data_sim(:, 3);
Ers = data_sim(:,5);
Trs = data_sim(:,6);
Uas = data_sim(:,7);
Ubs = data_sim(:,8);

figure


msize = 8;

%% Elevation
subplot(4, 1, 1)
plot(ttt, Et+1.2, 'LineWidth', 1.5);
grid on; hold on
% plot(tts, 180/pi * Es, 'LineWidth', 1.5);
title('Test Trajectory')
% Bounds
line([0 60], [10 10], 'LineStyle', '--', 'Color','black', 'LineWidth', 1.5)
line([20 60], [-10 -10], 'LineStyle', '--', 'Color','black', 'LineWidth', 1.5)

% Checkpoints
Ecpx = [20 40 60];
Ecpyu = [0 0 0] + 4 + msize/4;
Ecpyl = [0 0 0] - 4 - msize/4;
plot(Ecpx, Ecpyu, 'v', 'MarkerSize', msize, 'Color', 'black')
plot(Ecpx, Ecpyl, '^', 'MarkerSize', msize, 'Color', 'black')

% plot(tt, 180/pi*Er, '--', 'LineWidth', 1.5)
xlabel('Time (s)')
ylabel('$E$ (deg)', 'Interpreter','latex')
% legend('Test', 'Reference')
yticks(-20:5:20)
ylim([-20 20])

%% Travel
subplot(4, 1, 2)
plot(ttt, 180/pi*Trt, '-.', 'Color', 'black', 'LineWidth', 1.5)
grid on; hold on
plot(tts, 180/pi*Tsi, '-', 'LineWidth', 1)
plot(ttt, Tt, 'Color', [0 0.4470 0.7410], 'LineWidth', 1.5);

% Bounds
line([0 20], [20 20], 'LineStyle', '--', 'Color','black', 'LineWidth', 1.5)
line([0 60], [-20 -20], 'LineStyle', '--', 'Color','black', 'LineWidth', 1.5)
line([20 60], [200 200], 'LineStyle', '--', 'Color','black', 'LineWidth', 1.5)

% Checkpoints
Tcpx = [20 40 60];
Tcpyu = [0 180 0] + 26 + msize/4;
Tcpyl = [0 180 0] - 26 - msize/4;
plot(Tcpx, Tcpyu, 'v', 'MarkerSize', msize, 'Color', 'black')
plot(Tcpx, Tcpyl, '^', 'MarkerSize', msize, 'Color', 'black')
% Tctxt = {'1B', '2B', '3B'};
% 
% text(Tcpx + .5, Tcpy, Tctxt)

xlabel('Time (s)')
ylabel('$\Theta$ (deg)', 'Interpreter','latex')
legend('Reference', 'Simulation', 'Test', 'Location', 'northeast')
% yticks(-20:20:200)
ylim([-45 225])

%% Pitch
subplot(4, 1, 3)
plot(ttt, Pt, 'LineWidth', 1.5);
hold on; grid on
% plot(tts, 180/pi*Ps, 'LineWidth', 1.5);
xlabel('Time (s)')
ylabel('$\Psi$ (deg)', 'Interpreter','latex')
ylim([-60 30])

%% U
subplot(4, 1, 4)
plot(ttt, Uat, 'LineWidth', 1.5);
grid on; hold on
plot(ttt, Ubt, 'LineWidth', 1.5);
xlabel('Time (s)')
ylabel('$U$ (V)', 'Interpreter','latex')
legend('$U_a$', '$U_b$', 'Interpreter','latex', 'Location','southeast')
ylim([0 12])

set(gcf, 'position',[0, 0, 680, 880]) % Enlarge

% matlab2tikz()

u_sata = 100 * sum(Uat == 10) / numel(Uat)
u_satb = 100 * sum(Ubt == 10) / numel(Ubt)