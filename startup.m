% clear;

addpath data functions modelling simulink quanser NI

%% Symbolic variables
syms t E(t) Psi(t) Theta(t) F_a(t) F_b(t)
syms E_dot(t) Psi_dot(t) Theta_dot(t)
syms E_ddot(t) Psi_ddot(t) Theta_ddot(t)
syms g c l_1 l_2 l_3 m_1 m_2 k_s k_d J_E J_Psi J_Theta
syms alpha beta k_a U_a U_b U_e

% For substitution into function handles (not f(t))
syms E_ Psi_ Theta_
syms E_dot_ Psi_dot_ Theta_dot_
syms F_a_ F_b_ F_dot_a_ F_dot_b_
syms V_a_ V_b_

%% Set global helicopter variables (share across scripts)
m1 = 0.0505;   % mass of one fan assembly (kg)
m2 = 0.100;    % mass of counterweight (kg)
l1 = 0.110;    % distance from helicopter arm to elevation axis (m);
l2 = 0.070;    % distance from fan centres to pitch axis (m);
l3 = 0.108;    % distance from counterweight to elevation axis (m);
g_real = 9.807;
ks = 0;  % pitch axis spring coefficient
kd = 0;  % pitch axis damping coefficient
% ks = 0.0015;  % pitch axis spring coefficient
% kd = 0.0005;  % pitch axis damping coefficient

mech_vars = [l_1, l_2, l_3, m_1, m_2, g,      k_s, k_d];
mech_vals = [l1,  l2,  l3,  m1,  m2,  g_real, ks,  kd];

ADC_Vres    = 20/((2^16)-1);    % ADC voltage resolution (V/bit)
Encoder_res = 2*pi/500;         % Encoder resolution (rad/wheel count)
DAC_Vres    = 20/((2^16)-1);    % DAC voltage resolution (V/bit)
DAC_lim_u   = 10;               % DAC upper saturation limit (V)
DAC_lim_l   = 0;                % DAC enforced lower saturation limit (V)

%% Initialise models into workspace
evalc('RigidBodyModel_V');
evalc('CombinedModel_V');
evalc('FansModel');

%% Global controller parameters
Ts = 0.015;

%% Simulation Initial Conditions
E0 = deg2rad(-20);

%% Setup Quanser Model
setup_lab_heli_3d;

