function dx = Heli_Dynamics_Sim(x,u,p,t,vdat)
%Double Integrator Dynamics for Simulation
%
% Syntax:  
%          [dx] = Dynamics(x,u,p,t,vdat)
% 
% Inputs:
%    x  - state vector
%    u  - input
%    p  - parameter
%    t  - time
%    vdat - structured variable containing the values of additional data used inside
%          the function%      
% Output:
%    dx - time derivative of x
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk
%
%------------- BEGIN CODE --------------

% States
E=x(:,1); P=x(:,2); T=x(:,3); % Positions
Edot=x(:,4); Pdot=x(:,5); Tdot=x(:,6); % Rates
Va=x(:,7); Vb=x(:,8); % Voltages
Ua=u(:,1); Ub=u(:,2); % Inputs

% Params
Je = vdat.Je; Jt = vdat.Jt; Jp = vdat.Jp;
m1 = vdat.m1; m2 = vdat.m2; g = vdat.g;
l1 = vdat.l1; l2 = vdat.l2; l3 = vdat.l3;
kdp = vdat.kdp; ksp = vdat.ksp;
kde = vdat.kde; kse = vdat.kse;
kdt = vdat.kdt;
a = vdat.a; b = vdat.b; ka = 1;

dx(:,1) = Edot;
dx(:,2) = Pdot;
dx(:,3) = Tdot;

dx(:,4) = -((Jt*sin(2*E).*Tdot.^2)/2 - l1.*cos(P).*(2*b + Va*a*ka + Vb*a*ka) + g*cos(E)*(2*l1*m1 - l3*m2) + kde*Edot + kse*E)/Je;
dx(:,5) = -(kdp*Pdot  + ksp*P  - Va*a*ka*l2 + Vb*a*ka*l2)/Jp;
dx(:,6) = (l1*sin(P).*(b + Va*a*ka) + l1*sin(P).*(b + Vb*a*ka) + 2*Jt*sin(E).*Tdot.*Edot - kdt*Tdot)./(Jt*cos(E));
dx(:,7) = Ua - Va;
dx(:,8) = Ub - Vb;

%------------- END OF CODE --------------