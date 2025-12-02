data_u = readmatrix('pitch_unforced.xlsx');
data_f = readmatrix('pitch_forced.xlsx');

%% Unforced dataset
tt_u = data_u(:, 1);
log_u = pi/180 * data_u(:, 2) - 6.93;
log_u = movmean(log_u, 40);

% plot(tt_u, log_u);
% grid on

%% Forced dataset
tt_f = data_f(:, 1);
ulog_f = data_f(:, 2);
log_f = pi/180 * data_f(:, 2:3);
log_f = movmean(log_f, 40);


% pitchiddata = iddata(log_u, zeros(length(log_u), 1), Ts_fan);
pitchiddata = iddata(log_f, ulog_f, Ts_fan);

sys_pitch = n4sid(pitchiddata, 2, 'Ts', 0, ...
    'Form', 'canonical')
% sys_pitch = n4sid(pitchiddata, 2, 'Ts', 0, ...
%     'Form', 'canonical')

[y_sim, ~, x_sim] = sim(sys_pitch, pitchiddata); % Simulate response

close all
figure;
plot(tt_f, y_sim.OutputData, '--', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Pitch Angle (rad)');
title('Measured Step Response vs. State-Space Model');
legend('Measured', 'Model Simulated Response', 'Location', 'Best');
grid on;