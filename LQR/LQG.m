%% Load model
sys = c2d(sys_comb, Ts, 'zoh');

% A = sys.A;
% A(6, 2) = -A(6, 2); % Flip elevation axis (janky for now)
% B = sys.B;
% C = sys.C;
% D = sys.D;

% sys_lqg = ss(A, B, C, D)

%% Model Costs
Qrb = [10; 5; 1 
           10; 50; 10]'; % Cost for rigid body states
if nx > 6
    QV = [0 0]; % Cost for the voltages
else
    QV = [];
    
end

Qx = [Qrb QV]; % State cost
Qu = diag(0.1*ones(1, 2)); % Input cost

%% Covariance

estimate_sensor_cov;
Rn = R_kalman; % Measurement noise covariance

Qn = 0*eye(nx);  % Process noise covariance


%% LQG cost matrices
[nx, nu] = size(B);
ny = size(C, 1);

QXU = blkdiag(Qx, Qu); % Plant weighting
QWV = blkdiag(Qn, Rn); % Noise weighting
QI = diag([1 0 1]);     % Integral action on E and T

% K_lqr = lqr(sysdt_bar, Q, R);
K_lqg = lqg(sys, QXU, QWV, QI)

x0_bar = [E0; P0; T0; zeros(nx+nz-3, 1)];

%% Feedforward Gain

% % Controlled outputs
% C_r = [1 zeros(1, nx+nz-1)
%        0 0 1 zeros(1, nx+nz-3)];
% 
% K_r = (C_r * inv(A_bar - B_bar * K_lqr) * B_bar) \ -eye(2);