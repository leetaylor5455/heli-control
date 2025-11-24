% Ad = sysdt_comb.A;
% Bd = sysdt_comb.B;
% Cd = sysdt_comb.C;
% [nx, nu] = size(Bd);

IntegralActionModel;

Ad = sysdt_bar.A;
Bd = sysdt_bar.B;
Cd = sysdt_bar.C;
[nx, nu] = size(Bd);


umin = 0*ones(nu, 1) - U_e_real;
umax = 10*ones(nu, 1) - U_e_real;

xmin = -1e9*ones(nx, 1);
xmax = 1e9*ones(nx, 1);

% xmin = [e_lim_l; p_lim_l; -1e9*ones(nx-2, 1)];
% xmax = [e_lim_u; p_lim_u; 1e9*ones(nx-2, 1)];
% xmin = -Inf*ones(nx, 1);
% xmax = Inf*ones(nx, 1);

% Objective function
% Q = diag([10 0 10 0.5 2 2 0 0]);
Q = Q_bar;

% R = 0.1*eye(nu);
R = R_bar;
[QN,~,~] = idare(Ad, Bd, Q, R);

% Initial and ref states
% Initial condition
% x0 = zeros(nx, 1);
xr = [0; 0; 0; zeros(nx-3, 1)];

N = round(2 / Ts); % Time horizon
% N = 3;

% Linear objective
P = blkdiag(kron(speye(N), Q), QN, kron(speye(N), R));
q = [repmat(-Q*xr, N, 1); -QN*xr; zeros(N*nu, 1)];

% Linear dynamics equality constraints
Ax = kron(speye(N+1), -speye(nx)) + kron(sparse(diag(ones(N, 1), -1)), Ad);
Bu = kron([sparse(1, N); speye(N)], Bd);
Aeq = [Ax, Bu];
leq = [-x0_bar; zeros(N*nx, 1)];
ueq = leq; % Equating leq and ueq to use inequality form as equality

% Absolute input and state constraints
Aineq = speye((N+1)*nx + N*nu);
lineq = [repmat(xmin, N+1, 1); repmat(umin, N, 1)];
uineq = [repmat(xmax, N+1, 1); repmat(umax, N, 1)];

% OSQP constraints
A = [Aeq; Aineq];
l = [leq; lineq];
u = [ueq; uineq];

prob = osqp;
settings.verbose = 1;
settings.eps_abs = 1e-3;
settings.eps_rel = 1e-3;
settings.max_iter = 20000;
settings.warm_start = 1;
% Setup workspace
prob.setup(P, q, A, l, u, settings);

root_dir = matlab.project.rootProject().RootFolder;
mpc_dir = sprintf('%s\\MPC', root_dir);
cd(mpc_dir)

codegen_dir = sprintf('%s\\osqp_codegen', mpc_dir);

% Delete existing folder
if exist(codegen_dir, 'dir')
    rmdir(codegen_dir, 's');  % 's' = remove recursively
end

if exist('emosqp.mexw64', 'file')
    delete('emosqp.mexw64');  % remove old MEX
end

setenv('PATH',[getenv('PATH') ';C:\msys64\mingw64\bin']);
prob.codegen(codegen_dir)

cd(root_dir)