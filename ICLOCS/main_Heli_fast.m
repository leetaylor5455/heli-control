% Main script to solve the Optimal Control Problem 
%
% Battery Charging Problem
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk


%--------------------------------------------------------

% clear all;
close all;format compact;

% init models etc
% startup;

opts.nx = size(sysdt_comb.A, 1);
opts.Je = J_E_real;
opts.Jt = J_Theta_real;
opts.Jp = J_Psi_real;
opts.m1 = m1;
opts.m2 = m2;
opts.g = g_real;
opts.l1 = l1;
opts.l2 = l2;
opts.l3 = l3;
opts.kdp = kdp;
opts.ksp = ksp;
opts.kde = kde;
opts.kse = kse;
opts.kdt = kdt;
opts.a = alpha_real;
opts.b = beta_real;
opts.Ue = U_e_real;

opts.T0 = T0;
opts.Tf = Tf;

[problem,guess]=Heli_fast(opts);          % Fetch the problem definition
options= problem.settings(50);                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);
[ tv, xv, uv ] = simulateSolution( problem, solution, 'ode113');

%% Series
tt=solution.T;
Ett = (180/pi)*speval(solution,'X',1,tt);
Ptt = (180/pi)*speval(solution,'X',2,tt);
Ttt = (180/pi)*speval(solution,'X',3,tt);

Fatt = k_fan*speval(solution,'X',7,tt);
Fbtt = k_fan*speval(solution,'X',8,tt);

u1 = speval(solution,'U',1,tt);
u2 = speval(solution,'U',2,tt);

%% Plot positions
figure
subplot(3,1,1)
hold on
plot(tt,Ett,'b-' ,'LineWidth',2)
plot([solution.T(1,1); solution.tf],(180/pi)*[problem.states.xl(1), problem.states.xl(1)],'b--' )
plot([solution.T(1,1); solution.tf],(180/pi)*[problem.states.xu(1), problem.states.xu(1)],'b--' )
xlabel('Time [s]')
ylabel('Elevation (rad)')
grid on

subplot(3,1,2)
plot(tt,Ptt,'r-' ,'LineWidth',2)
xlabel('Time [s]')
ylabel('Pitch (rad)')
grid on

subplot(3,1,3)
hold on
plot(tt,Ttt,'g-' ,'LineWidth',2)
plot([solution.T(1,1); solution.tf],(180/pi)*[problem.states.xl(3), problem.states.xl(3)],'g--' )
plot([solution.T(1,1); solution.tf],(180/pi)*[problem.states.xu(3), problem.states.xu(3)],'g--' )
xlabel('Time [s]')
ylabel('Travel (rad)')
grid on

%% Plot fan forces
figure
hold on
plot(tt, Fatt, 'g', 'LineWidth', 2);
plot(tt, Fbtt, 'b', 'LineWidth', 2);
xlabel('Time [s]')
ylabel('Fan Force (N)')
legend('Fa', 'Fb')
grid on

%% Plot inputs
figure
hold on
plot(tt, u1, 'g', 'LineWidth', 2);
plot(tt, u2, 'b', 'LineWidth', 2);
plot([solution.T(1,1); solution.tf],[problem.inputs.ul(1), problem.inputs.ul(1)], 'r--')
plot([solution.T(1,1); solution.tf],[problem.inputs.uu(1), problem.inputs.uu(1)], 'r--')
xlabel('Time [s]')
ylabel('Control Input')
legend('Ua', 'Ub')
grid on
