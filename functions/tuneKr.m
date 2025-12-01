function K_r = tuneKr(sys, K_lqr)
%TUNEKR Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    sys
    K_lqr
end

arguments (Output)
    K_r
end
    
    A = sys.A;
    B = sys.B;

    [nx, nu] = size(B);

    %% Feedforward Gain
        
    C_r = eye(nx);
    K_r = -eye(nu) / (C_r * inv(A - B*K_lqr) * B)

end