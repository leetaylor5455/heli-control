nx_ref = 8; % Number of state references (ref for voltages?)

%% Outward trajectory
T0 = 0;
Tf = deg2rad(180);

% Run optimisation
if strcmp(tune, 'fast')
    main_Heli_fast;
else
    main_Heli_robust;    
end

% iterate through states and populate trajectory
t_out_opt = solution.T;
t_out_opt_time = max(t_out_opt);

x_out_opt = getInterpolatedTrajectory(solution, nx_ref, Ts);

%% Inward trajectory
T0 = Tf;
Tf = 0;

% Run optimisation
if strcmp(tune, 'fast')
    main_Heli_fast;
else
    main_Heli_robust;    
end

T0 = 0; % Ensure T0 goes back to 0 to align with trajectory target

% iterate through states and populate trajectory
t_in_opt = solution.T;
t_in_opt_time = max(t_in_opt);

x_in_opt = getInterpolatedTrajectory(solution, nx_ref, Ts);

N_init = round(20 / Ts); % intial wait
N_wait = round((40 - 20 - t_out_opt_time) / Ts);

s_max = max(x_out_opt(3, :));

wait_multiplier = [0; 0; s_max; zeros(5, 1)];

% Normalise the U references at zero
if nx_ref > 6
    for i = 7:8
        x_out_opt(i,:) = x_out_opt(i,:) - U_e_real;
        x_in_opt(i,:) = x_in_opt(i,:) - U_e_real;
    end
end

x_opt_ref = [zeros(8, N_init),...
    x_out_opt,...
    wait_multiplier .* ones(8, N_wait),...
    x_in_opt,...
    zeros(8, N_wait)
];

x_opt_ref_i = [x_opt_ref; zeros(2, size(x_opt_ref, 2))];

if ~(nx_ref > 6)
    x_opt_ref = [x_opt_ref; zeros(2, size(x_opt_ref, 2))];
end

for i = nx_ref:8
    
end

tt_ref_opt = 0:Ts:Ts*(length(x_opt_ref)-1);

e_ref_ts = timeseries(x_opt_ref(1, :), tt_ref_opt);
p_ref_ts = timeseries(x_opt_ref(2, :), tt_ref_opt);
t_ref_ts = timeseries(x_opt_ref(3, :), tt_ref_opt);
ed_ref_ts = timeseries(x_opt_ref(4, :), tt_ref_opt);
pd_ref_ts = timeseries(x_opt_ref(5, :), tt_ref_opt);
td_ref_ts = timeseries(x_opt_ref(6, :), tt_ref_opt);
va_ref_ts = timeseries(x_opt_ref(7, :), tt_ref_opt);
vb_ref_ts = timeseries(x_opt_ref(8, :), tt_ref_opt);

figure;
hold on
% plot(e_ref_ts)
% plot(p_ref_ts)
% plot(t_ref_ts)

for i = 1:6
    plot(tt_ref_opt, x_opt_ref(i, :))
end

grid on
xlabel('Time [s]')
legend('E', 'P', 'T', 'Edot', 'Pdot', 'Tdot')

