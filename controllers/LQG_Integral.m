%% Load model
sys = sys_rb;

A = sys.A;
B = sys.B;
C = sys.C;
D = sys.D;

%% Add integral states for elevation and travel

% Elevation is state 1 and travel is state 2
% d/dx_i = x_i

[nx, nu] = size(B);

nz = 2; % Two integral states
x_bar_E = [1 zeros(1, nx + nz - 1)];
x_bar_T = [0 0 1 zeros(1, nx + nz - 3)];

A_bar = [A, zeros(nx, nz); x_bar_E; x_bar_T];
B_bar = [B; zeros(nz, nu)];

% Add the integral states to the output
C_bar = [C zeros(3, nz) 
    zeros(1, nx) 1 0
    zeros(1, nx) 0 1
];

D_bar = [D; zeros(nz, nu)];

sysdt_bar = c2d(ss(A_bar, B_bar, C_bar, D_bar), Ts, 'zoh');

Cost_rb = [1 1 5 20 5 10]; % Cost for rigid body states

if nx > 6
    Cost_V = [0 0]; % Cost for the voltages
else
    Cost_V = [];
end

Cost_I = [1 1]; % Integral costs

Q = diag([Cost_rb Cost_V Cost_I]);
R = diag(0.1*ones(1, 2));

K_lqr = lqr(sysdt_bar, Q, R);

x0_bar = [E0; P0; T0; zeros(nx+nz-3, 1)];