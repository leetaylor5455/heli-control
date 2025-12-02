clear;
close all

% addpath data functions modelling helpers controllers MPC LQR simulink quanser NI testing

%% Symbolic variables
syms t E(t) Psi(t) Theta(t) F_a(t) F_b(t)
syms E_dot(t) Psi_dot(t) Theta_dot(t)
syms E_ddot(t) Psi_ddot(t) Theta_ddot(t)
syms g c l_1 l_2 l_3 m_1 m_2 k_sp k_dp J_E J_Psi J_Theta k_de k_se k_dt
syms alpha beta k_a U_a U_b U_e

% For substitution into function handles (not f(t))
syms E_ Psi_ Theta_
syms E_dot_ Psi_dot_ Theta_dot_
syms F_a_ F_b_ F_dot_a_ F_dot_b_
syms V_a_ V_b_

%% Model initial conditions
E0 = deg2rad(-23);
P0 = deg2rad(0);
T0 = deg2rad(0);

%% Set global helicopter variables (share across scripts)
use_cad_params = false; % Solve params from CAD model

if use_cad_params
    cad_rb_params;
    m1 = m1_cad;
    m2 = m2_cad;
    l1 = l_cad(1);
    l2 = l_cad(2);
    l3 = l_cad(3);
else
    m1 = 0.0505;   % mass of one fan assembly (kg)
    m2 = 0.100;    % mass of counterweight (kg)
    l1 = 0.110;    % distance from helicopter arm to elevation axis (m);
    l2 = 0.070;    % distance from fan centres to pitch axis (m);
    l3 = 0.108;    % distance from counterweight to elevation axis (m);
end

g_real = 9.807;
ksp = 0.0005; % pitch axis spring coefficient
kdp = 0.0005; % pitch axis damping coefficient
% kde = 0.014;   % elevation axis damping
kde = 0.0014; % elevation axis damping
% kse = -g_real/E0 * (2*m1*l1 - l3*m2); % elevation axis spring
% kse = 0.02; % elevation axis spring
kse = 0.0002; % elevation axis spring
kdt = 0.0004;

mech_vars = [l_1, l_2, l_3, m_1, m_2, g,      k_sp, k_dp, k_de, k_se, k_dt];
mech_vals = [l1,  l2,  l3,  m1,  m2,  g_real, ksp,  kdp,  kde,  kse,  kdt];

ADC_Vres    = 20/((2^16)-1);    % ADC voltage resolution (V/bit)
Encoder_res = 2*pi/500;         % Encoder resolution (rad/wheel count)
DAC_Vres    = 20/((2^16)-1);    % DAC voltage resolution (V/bit)
DAC_lim_u   = 10;               % DAC upper saturation limit (V)
DAC_lim_l   = 0;                % DAC enforced lower saturation limit (V)
amp_sat_u   = 10;               % Power amplifier upper saturation limit (V)
amp_sat_l   = 0;                % Power amplifier lower saturation limit (V)

PitchAxisData = readtable('PitchAxisData.txt');
ElevAxisData  = readtable('ElevAxisData.txt');
% Constraints
p_lim_u = max(PitchAxisData.Var1)*pi/180; % Upper pitch axis limit (rad)
p_lim_l = min(PitchAxisData.Var1)*pi/180; % Lower pitch axis limit (rad)
e_lim_u = max(ElevAxisData.Var1)*pi/180;  % Upper elevation axis limit (rad)
e_lim_l = min(ElevAxisData.Var1)*pi/180;  % Lower elevation axis limit (rad)

%% Initialise models into workspace
evalc('RigidBodyModel_V');
evalc('CombinedModel_V');
evalc('FansModel');

Ts = 0.015;
% Ts = 0.025;

sysdt_rb = c2d(sys_rb, Ts, 'zoh');
sysdt_comb = c2d(sys_comb, Ts, 'zoh');

% Nonlinear model needs Va,b at U_e for equilibrium
xUe = [zeros(6, 1); U_e_real; U_e_real];
U_e_vec = [U_e_real; U_e_real];

xf0 = [F_e_real; zeros(fanModelOrder-1, 1)];

%% Simulation Initial Conditions and Limits

x0 = [E0; P0; T0; zeros(5, 1)];

%% Setup LGQ Controller Model
IntegralActionModel;

%% Reference gen
tune = 'robust';
% FIR_reference;
% Optimal_reference;

config_opt_robust;

ref_v = 1; % Reference generator variant (1 is optimal, 2 is FIR)

% if ref_v == 1
%     LQR_gains_OPT;
% else
%     LQR_gains_FIR;
% end

var_config_vcdo; % Ref gen variants

%% Kalman filter
estimate_sensor_cov;
estimate_process_noise;

%% Setup MPC MEX
% setupMPC;

%% Setup Quanser Model
% setup_lab_heli_3d;

disp('--------------- Startup Done ---------------')