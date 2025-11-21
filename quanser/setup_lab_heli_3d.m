%% SETUP_LAB_HELI_3D
%
% This script sets the model parameters and designs a PID position
% controller using LQR for the Quanser 3-DOF Helicopter plant.
%
% clear all;
%
%% User defined 3DOF helicopter system configuration
% Amplifier Gain used for yaw and pitch axes: set VoltPAQ to 3.
% K_AMP = k_a_real * alpha_real;
% % Amplifier Maximum Output Voltage (V)
% VMAX_AMP = DAC_lim_u;
% % Digital-to-Analog Maximum Voltage (V): set to 10 for Q4/Q8 cards
% VMAX_DAC = DAC_lim_u;
% % Initial elvation angle (rad)
% elev_0 = E0;

%% User defined 3DOF helicopter system configuration
% Amplifier Gain used for yaw and pitch axes: set VoltPAQ to 3.
K_AMP = 3;
% Amplifier Maximum Output Voltage (V)
VMAX_AMP = 24;
% Digital-to-Analog Maximum Voltage (V): set to 10 for Q4/Q8 cards
VMAX_DAC = 10;
% Initial elvation angle (rad)
elev_0 = -27.5*pi/180;

%% User defined Filter design
% Specifications of a second-order low-pass filter
wcf = 2 * pi * 20; % filter cutting frequency
zetaf = 0.9;        % filter damping ratio
% Anti-windup: integrator saturation (V)
SAT_INT_ERR_ELEV = 7.5;
SAT_INT_ERR_TRAVEL = 7.5;

%% User defined command settings
% Note: These limits are imposed on both the program and joystick commands.
% Elevation position command limit (deg)
CMD_ELEV_POS_LIMIT_LOWER = elev_0*180/pi;
CMD_ELEV_POS_LIMIT_UPPER = -CMD_ELEV_POS_LIMIT_LOWER;
% Maximum Rate of Desired Position (rad/s)
CMD_RATE_LIMIT = 45.0 * pi / 180;

%% System Modelling
% These parameters are used for model representation and controller design.
% [ Kf, m_h, m_w, m_f, m_b, Lh, La, Lw, g, K_EC_T, K_EC_P, K_EC_E ] = setup_heli_3d_configuration();

% Propeller force-thrust constant found experimentally (N/V)
Kf = k_a_real * alpha_real;
% Mass of the helicopter body (kg)
m_h = 2*m1;
% Mass of counter-weight (kg)
m_w = m2;
% Mass of front propeller assembly = motor + shield + propeller + body (kg)
m_f = m1;
% Mass of back propeller assembly = motor + shield + propeller + body (kg)
m_b = m1;
% Distance between pitch pivot and each motor (m)
Lh = l2;
% Distance between elevation pivot to helicopter body (m)
La = l1;
% Distance between elevation pivot to counter-weight (m)
Lw = l3;
% Gravitational Constant (m/s^2)
% g = g_real;    
% Travel, Pitch, and Elevation Encoder Resolution (rad/count)
K_EC_T = Encoder_res;
K_EC_P = Encoder_res;
K_EC_E = Encoder_res;
% Motor Armature Resistance (Ohm)
Rm = 0.83;
% Motor Current-Torque Constant (N.m/A)
Kt = 0.0182;
% Motor Rotor Moment of Inertia (kg.m^2)
Jm = 1.91e-6;

% For the following state vector: X = [ elevation; pitch; travel, elev_dot, pitch_dot, travel_dot]
% Initialization the state-Space representation of the open-loop System
A=zeros(6,6);
A( 1, 4 ) = 1;
A( 2, 5 ) = 1;
A( 3, 6 ) = 1;
A( 6, 2 ) = (2*m_f*La-m_w*Lw)*g_real/(2*m_f*La^2+2*m_f*Lh^2+m_w*Lw^2);

B=zeros(6,2);
B( 4, 1 ) = La*Kf/(m_w*Lw^2+2*m_f*La^2);
B( 4, 2 ) = La*Kf/(m_w*Lw^2+2*m_f*La^2);
B( 5, 1 ) = 1/2*Kf/m_f/Lh;
B( 5, 2 ) = -1/2*Kf/m_f/Lh;

C=zeros(3,6);
C( 1, 1 ) = 1;
C( 2, 2 ) = 1;
C( 3, 3 ) = 1;

D=zeros(3,2);
% Augment state: Xi = [ elevation; pitch; travel, elev_dot, pitch_dot, travel_dot, elev_int, travel_int]
Ai = A;
Ai(7,1) = 1; % elevation integrator 
Ai(8,3) = 1; % travel integrator 
Ai(8,8) = 0;
Bi = B;
Bi(8,2) = 0;

%% LQR-PID Controller design
%Weights:
Q = diag([100 1 10 0 0 2 10 0.1]);
R = 0.05*diag([1 1]);
% Automatically calculate the LQR controller gain
K = lqr( Ai, Bi, Q, R );    
% Display the calculated gains
disp( ' ' )
disp( 'Calculated LQR controller gain elements: ' )
K 


%% Non-linear model parameters (for closed-loop simulation only):
%Modified on 21/11/2016

%System parameters
% % Propeller force-thrust constant found experimentally (N/V)
% Kf = 0.1188;
% % Mass of the helicopter body (kg)
% m_h = 1.308;
% % Mass of counter-weight (kg)
% m_w = 1.924;
% % Mass of front propeller assembly = motor + shield + propeller + body (kg)
% m_f = m_h / 2;
% % Mass of back propeller assembly = motor + shield + propeller + body (kg)
% m_b = m_h / 2;
% % Distance between pitch pivot and each motor (m)
% Lh = 7.0 * 0.0254;
% % Distance between elevation pivot to helicopter body (m)
% La = 26.0 * 0.0254;
% % Distance between elevation pivot to counter-weight (m)
% Lw = 18.5 * 0.0254;
% % Gravitational Constant (m/s^2)
% g = 9.81;    
par = [Kf;m_h;m_w;m_f;m_b;Lh;La;Lw;g_real]; 

%Initial condition
X0=[E0;P0;T0;0;0;0];
%% Feed-forward input:

Vop=0.5*g_real*(Lw*m_w-2*La*m_f)/(La*Kf);