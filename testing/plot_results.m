data = readmatrix('data/traj_3.xlsx');

bounds = 1:round(60/Ts);

tt = data(bounds, 1);
P = data(bounds, 2);
E = data(bounds, 3);
T = data(bounds, 4);
Er = data(bounds,5);
Tr = data(bounds,6);
Ua = data(bounds,7);
Ub = data(bounds,8);

figure


msize = 8;

%% Elevation
subplot(4, 1, 1)
plot(tt, E+1.2, 'LineWidth', 1.5);
grid on; hold on
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
plot(tt, T, 'LineWidth', 1.5);
grid on; hold on
plot(tt, 180/pi*Tr, ':', 'LineWidth', 1.5)

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
legend('Test', 'Reference', 'Location', 'east')
% yticks(-20:20:200)
ylim([-45 225])

%% Pitch
subplot(4, 1, 3)
plot(tt, P, 'LineWidth', 1.5);
grid on
xlabel('Time (s)')
ylabel('$\Psi$ (deg)', 'Interpreter','latex')
ylim([-60 30])

%% U
subplot(4, 1, 4)
plot(tt, Ua, 'LineWidth', 1.5);
grid on; hold on
plot(tt, Ub, 'LineWidth', 1.5);
xlabel('Time (s)')
ylabel('$U$ (V)', 'Interpreter','latex')
legend('$U_a$', '$U_b$', 'Interpreter','latex', 'Location','southeast')
ylim([0 12])

set(gcf, 'position',[0, 0, 680, 900]) % Enlarge

matlab2tikz()