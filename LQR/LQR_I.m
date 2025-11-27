%% Load model
sys = sys_comb;

A_bar = sys.A;
% A_bar(6, 2) = -A_bar(6, 2);
B_bar = sys.B;
C_bar = sys.C;
D_bar = sys.D;

%% Add integral states for elevation and travel

% Elevation is state 1 and travel is state 2
% D_bar/dx_i = x_i

[nx, nu] = size(B_bar);

nz = 2; % Two integral states
x_bar_E = [1 zeros(1, nx + nz - 1)];
x_bar_T = [0 0 1 zeros(1, nx + nz - 3)];

A_bar = [A_bar, zeros(nx, nz); x_bar_E; x_bar_T];
B_bar = [B_bar; zeros(nz, nu)];
C_bar = [C_bar zeros(3, nz)
         zeros(1, nx) 1 0
         zeros(1, nx) 0 1
];

D_bar = [D_bar; zeros(nz, nu)];

sysdt_bar = c2d(ss(A_bar, B_bar, C_bar, D_bar), Ts, 'zoh');


%% Cost
Cost_rb = [10; 1; 10 
           10; 1; 15]'; % Cost for rigid body states

if nx > 6
    Cost_V = [0 0]; % Cost for the voltages
else
    Cost_V = [];
    
end

Cost_I = [1 20]; % Integral costs

Q = diag([Cost_rb Cost_V Cost_I]);
R = diag(0.1*ones(1, 2));

K_lqr = lqr(sysdt_bar, Q, R);

x0_bar = [E0; P0; T0; zeros(nx+nz-3, 1)];