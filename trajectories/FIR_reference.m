% Elevation target is zero throughout, so just nonzero xr for T and T.

%% Step commands
xr_T0 = 0;
xr_T1 = deg2rad(180);
xr_T2 = 0;

t_interval = 20; % seconds between commands

%% Calculate velocity pulse (before the interval)
t_trans = t_interval / 4;

%% Calculate the velocity required to travel the distance;
s_trans = xr_T1 - xr_T0;
v_trans = s_trans / t_trans;

%% Convolution kernel width based on max acceleration

F_max = k_fan * 10; % Maximum force from a single fan
p_max = 20; % Maximum pitch angle that we can choose

a_max = (2*F_max*l1*cosd(90-p_max)) / (2*m1*(l1^2+l2^2)+m2*l3^2);

T1 = v_trans / a_max;

%% Create vectors for convolutions
v_rec = v_trans * ones(1, round(t_trans / Ts));
kern = 1/(T1/Ts) * ones(1, round(T1/Ts));

% N1 = round(T1 / Ts);          % Number of samples in kernel
% kern = ones(1, N1);
% kern = kern / (sum(kern) * Ts);

v_trap = conv(v_rec, kern);
v_smooth = conv(v_trap, kern);

v_ref_trans = (v_trans/max(v_smooth)) * v_smooth;
s_ref_trans = Ts * cumtrapz(v_ref_trans);

tt_trans = 0:Ts:Ts*(length(v_smooth)-1);

close all;

figure;
hold on
plot(tt_trans, v_ref_trans)
plot(tt_trans, s_ref_trans)

N_zeros = round(2*t_trans / Ts) - 2*length(kern); % How long to wait between transitions
% N_initial = round(t_interval / Ts); % 20 seconds worth of zeros
N_initial = round(10 / Ts); % 20 seconds worth of zeros

s_ref = [zeros(1, N_initial).'
         s_ref_trans.'
         s_trans * ones(1, N_zeros).'
         s_trans - s_ref_trans.'
         zeros(1, N_zeros).'
].';

v_ref = [zeros(1, N_initial).'
         v_ref_trans.'
         zeros(1, N_zeros).'
         -v_ref_trans.'
         zeros(1, N_zeros).'
].';

tt_ref = 0:Ts:Ts*(length(s_ref)-1);

figure;
hold on
plot(tt_ref, v_ref)
plot(tt_ref, s_ref)

s_ref_ts = timeseries(s_ref, tt_ref);
v_ref_ts = timeseries(v_ref, tt_ref);