%% Cost
Cost_rb = [1; 0; 250 
          1; 10; 10]'; % Cost for rigid body states

if nx > 6
    Cost_V = [0 0]; % Cost for the voltages
else
    Cost_V = [];
    
end

Cost_I = [50 50]; % Integral costs

Q_bar = diag([Cost_rb Cost_V Cost_I]);
R_bar = diag(0.1*ones(1, 2));

K_lqr = lqr(sysdt_bar, Q_bar, R_bar);