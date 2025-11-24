%% Load model
sys = sys_comb;

A = sys.A;
B = sys.B;
C = sys.C;
D = sys.D;

%% Add integral states for elevation and travel

% Elevation is state 1 and travel is state 2
% D_bar/dx_i = x_i

[nx, nu] = size(B);

nz = 2; % Two integral states
x_bar_E = [1 zeros(1, nx + nz - 1)];
x_bar_T = [0 0 1 zeros(1, nx + nz - 3)];

A_bar = [A, zeros(nx, nz); x_bar_E; x_bar_T];
B_bar = [B; zeros(nz, nu)];
C_bar = [C zeros(3, nz)
         zeros(1, nx) 1 0
         zeros(1, nx) 0 1
];

D_bar = [D; zeros(nz, nu)];

sysdt_bar = c2d(ss(A_bar, B_bar, C_bar, D_bar), Ts, 'zoh');


x0_bar = [E0; P0; T0; zeros(nx+nz-3, 1)];

% rank(obsv(sysdt_bar)) == size(A_bar, 1)