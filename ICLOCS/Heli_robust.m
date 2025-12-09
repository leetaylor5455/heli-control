function [problem,guess] = Heli_robust(opts)
%DoubleIntergratorTracking - Double Integrator Tracking Problem
%
% Syntax:  [problem,guess] = DoubleIntergratorTracking
%
% Outputs:
%    problem - Structure with information on the optimal control problem
%    guess   - Guess for state, control and multipliers.
%
% Other m-files required: none
% MAT-files required: none
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk


%------------- BEGIN CODE --------------
% Plant model name, used for Adigator
InternalDynamics=@Heli_Dynamics_Internal;
SimDynamics=@Heli_Dynamics_Sim;

% Analytic derivative files (optional)
problem.analyticDeriv.gradCost=[];
problem.analyticDeriv.hessianLagrangian=[];
problem.analyticDeriv.jacConst=[];

% Settings file
problem.settings=@settings_Heli;

% problem.FcnTypes.Dynamics='Nonlinear';
% problem.FcnTypes.PathConstraint='Nonlinear';
% problem.FcnTypes.StageCost='None';
% problem.FcnTypes.TerminalCost='Linear';
% problem.FcnTypes.TerminalConst='None';

%Initial Time. t0<tf
problem.time.t0_min=0;
problem.time.t0_max=0;
guess.t0=0;

% Final time. Let tf_min=tf_max if tf is fixed.
problem.time.tf_min=0;     
problem.time.tf_max=inf; 
guess.tf=10;

% Parameters bounds. pl=< p <=pu
problem.parameters.pl=[];
problem.parameters.pu=[];
guess.parameters=[];

% Initial conditions for system.
% x10=0; x20=0;
% nx = size(sysdt_comb.A, 1);

nx = opts.nx;
Ve = opts.Ue;

x0 = [0 0 opts.T0 zeros(1, 3) Ve Ve]; % Start at equilibrium voltage
problem.states.x0=x0; % Set initial condition

% Initial conditions for system. Bounds if x0 is free s.t. x0l=< x0 <=x0u
problem.states.x0l=[x0]; 
problem.states.x0u=[x0]; 

Emin = deg2rad(-10);
Emax = deg2rad(10);
Pmin = deg2rad(-20);
Pmax = deg2rad(20);
Tmin = deg2rad(-20);
Tmax = deg2rad(200);

xmin = [Emin Pmin Tmin -inf*ones(1, nx-3)];
xmax = [Emax Pmax Tmax inf*ones(1, nx-3)];

% State bounds. xl=< x <=xu
% x1_min=-inf; x2_min=0;
% x1_max=inf; x2_max=0.25;
problem.states.xl=xmin;
problem.states.xu=xmax;

% State error bounds
problem.states.xErrorTol_local = 1e-6*ones(1, nx);
problem.states.xErrorTol_integral = 1e-6*ones(1, nx);


% State constraint error bounds
problem.states.xConstraintTol= 1e-3*ones(1, nx);

% Terminal state bounds. xfl=< xf <=xfu
% x1f=1; x2f_min=x2_min; x2f_max=x2_max;
% problem.states.xfl=[x1f x2f_min];
% problem.states.xfu=[x1f x2f_max];

xf = [0 0 opts.Tf zeros(1, 3) Ve Ve];

problem.states.xfl= xf - 1e-3;
problem.states.xfu= xf + 1e-3;

% Guess the state trajectories with [x0 xf]
% [x0.' xf.']
guess.states=[x0; xf];
% guess.states(:,2)=xf;
% Residual Error Scale
% problem.states.ResErrorScale
% problem.states.resCusWeight

% Number of control actions N 
% Set problem.inputs.N=0 if N is equal to the number of integration steps.  
% Note that the number of integration steps defined in settings.m has to be divisible 
% by the  number of control actions N whenever it is not zero.
problem.inputs.N=0;       
      
% Input bounds
ul=0; uu=10;
problem.inputs.ul= ul*ones(1, 2);
problem.inputs.uu= uu*ones(1, 2);

% Bounds on the first control action
problem.inputs.u0l= ul*ones(1, 2);
problem.inputs.u0u= uu*ones(1, 2);

% Input constraint error bounds
problem.inputs.uConstraintTol= 0.01*ones(1, 2);

% Guess the input sequences with [u0 uf]
guess.inputs(:,1)=[opts.Ue opts.Ue];
guess.inputs(:,2)=[opts.Ue opts.Ue];

% Choose the set-points if required
problem.setpoints.states=[];
problem.setpoints.inputs=[];

% Bounds for path constraint function gl =< g(x,u,p,t) =< gu
problem.constraints.ng_eq=0;
problem.constraints.gTol_eq=[];

problem.constraints.gl=[];
problem.constraints.gu=[];
problem.constraints.gTol_neq=[];

% Bounds for boundary constraints bl =< b(x0,xf,u0,uf,p,t0,tf) =< bu
problem.constraints.bl=[];
problem.constraints.bu=[];
problem.constraints.bTol=[];

% store the necessary problem parameters used in the functions
problem.data.Je = opts.Je;
problem.data.Jt = opts.Jt;
problem.data.Jp = opts.Jp;
problem.data.m1 = opts.m1;
problem.data.m2 = opts.m2;
problem.data.g = opts.g;
problem.data.l1 = opts.l1;
problem.data.l2 = opts.l2;
problem.data.l3 = opts.l3;
problem.data.kdp = opts.kdp;
problem.data.ksp = opts.ksp;
problem.data.kde = opts.kde;
problem.data.kse = opts.kse;
problem.data.kdt = opts.kdt;
problem.data.a = opts.a;
problem.data.b = opts.b;


% Get function handles and return to Main.m
problem.data.InternalDynamics=InternalDynamics;
problem.data.functionfg=@fg;
problem.data.plantmodel = func2str(InternalDynamics);
problem.functions={@L,@E,@f,@g,@avrc,@b};
problem.sim.functions=SimDynamics;
problem.sim.inputX=[];
problem.sim.inputU=1:length(problem.inputs.ul);
problem.functions_unscaled={@L_unscaled,@E_unscaled,@f_unscaled,@g_unscaled,@avrc,@b_unscaled};
problem.data.functions_unscaled=problem.functions_unscaled;
problem.data.ng_eq=problem.constraints.ng_eq;
problem.constraintErrorTol=[problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.states.xConstraintTol,problem.states.xConstraintTol,problem.inputs.uConstraintTol,problem.inputs.uConstraintTol];

%------------- END OF CODE --------------

function stageCost=L_unscaled(x,xr,u,ur,p,t,vdat)

% L_unscaled - Returns the stage cost.
% The function must be vectorized and
% xi, ui are column vectors taken as x(:,i) and u(:,i) (i denotes the i-th
% variable)
% 
% Syntax:  stageCost = L(x,xr,u,ur,p,t,data)
%
% Inputs:
%    x  - state vector
%    xr - state reference
%    u  - input
%    ur - input reference
%    p  - parameter
%    t  - time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    stageCost - Scalar or vectorized stage cost
%
%  Remark: If the stagecost does not depend on variables it is necessary to multiply
%          the assigned value by t in order to have right vector dimesion when called for the optimization. 
%          Example: stageCost = 0*t;

%------------- BEGIN CODE --------------



% stageCost = 0*t;

stageCost = u(:,1).*u(:,1) + u(:,2).*u(:,2);
% stageCost = u(:,1) + u(:,2);

%------------- END OF CODE --------------


function boundaryCost=E_unscaled(x0,xf,u0,uf,p,t0,tf,data) 

% E_unscaled - Returns the boundary value cost
%
% Syntax:  boundaryCost=E_unscaled(x0,xf,u0,uf,p,t0,tf,data) 
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    boundaryCost - Scalar boundary cost
%
%------------- BEGIN CODE --------------

% boundaryCost=tf;

boundaryCost=0;

%------------- END OF CODE --------------


function bc=b_unscaled(x0,xf,u0,uf,p,t0,tf,vdat,varargin)

% b_unscaled - Returns a column vector containing the evaluation of the boundary constraints: bl =< bf(x0,xf,u0,uf,p,t0,tf) =< bu
%
% Syntax:  bc=b_unscaled(x0,xf,u0,uf,p,t0,tf,vdat,varargin)
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
%          
% Output:
%    bc - column vector containing the evaluation of the boundary function 
%
%------------- BEGIN CODE --------------
varargin=varargin{1};
bc=[];
%------------- END OF CODE --------------
% When adpative time interval add constraint on time
%------------- BEGIN CODE --------------
if length(varargin)==2
    options=varargin{1};
    t_segment=varargin{2};
    if ((strcmp(options.discretization,'hpLGR')) || (strcmp(options.discretization,'globalLGR')))  && options.adaptseg==1 
        if size(t_segment,1)>size(t_segment,2)
            bc=[bc;diff(t_segment)];
        else
            bc=[bc,diff(t_segment)];
        end
    end
end

%------------- END OF CODE --------------
