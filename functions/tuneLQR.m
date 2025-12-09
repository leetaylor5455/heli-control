function [K_lqr] = tuneLQR(test, sys)
%TUNELQR Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    test
    sys
end

arguments (Output)
    K_lqr
end
    B = sys.B;

    [nx, ~] = size(B);

    if strcmp(test, 'test')
        %% Cost Test
        % Cost_rb = [1; 0; 20 
        %            10; 0; 50]'; % Cost for rigid body states
        Cost_rb = [1; 0; 50 
                   1; 5; 250]'; % Cost for rigid body states

        if nx > 8
            Cost_V = [0 0]; % Cost for the voltages
        else
            Cost_V = [];
        
        end
        
        Cost_I = [50 50]; % Integral costs
    else
        %% Cost Sim
        Cost_rb = [10; 0; 20 
                  5; 100; 100]'; % Cost for rigid body states
        
        if nx > 8
            Cost_V = [0 0]; % Cost for the voltages
        else
            Cost_V = [];
        
        end
        
        Cost_I = [5 5]; % Integral costs
    end

    Q = diag([Cost_rb Cost_V Cost_I]);
    R = diag(0.1*ones(1, 2));
    
    K_lqr = lqr(sys, Q, R)

end