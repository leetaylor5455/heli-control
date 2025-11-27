%% Cost
Cost_rb = [10; 0; 10 
           5; 0; 10]'; % Cost for rigid body states

if nx > 6
    Cost_V = [0 0]; % Cost for the voltages
else
    Cost_V = [];
    
end

Cost_I = [10 20]; % Integral costs

Q_bar = diag([Cost_rb Cost_V Cost_I]);
R_bar = diag(0.1*ones(1, 2));

K_lqr = lqr(sysdt_bar, Q_bar, R_bar);

%% Feedforward Gain

C_r = eye(10);
K_r = -eye(2) / (C_r * inv(A_bar - B_bar*K_lqr) * B_bar);