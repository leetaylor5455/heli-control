function [x_ref_interp] = getInterpolatedTrajectory(solution, nx_ref, Ts)
%GETINTERPOLATEDTRAJECTORY Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    solution
    nx_ref
    Ts
end

arguments (Output)
    x_ref_interp
end

    % iterate through states and populate trajectory
    tt = solution.T;
    
    x_ref = zeros(nx_ref, length(tt));
    
    for i = 1:nx_ref
        x_ref(i, :) = speval(solution,'X',i,tt);
    end
    
    % dt_opt = median(gradient(tt));
    
    tt_interp = tt(1):Ts:tt(end);
    
    x_ref_interp = zeros(8, length(tt_interp));
    
    % Linearly interpolate each state
    for i = 1:nx_ref
        x_ref_interp(i, :) = interp1(tt, x_ref(i, :), tt_interp, 'linear');
    end

    for i = nx_ref+1:8
        x_ref_interp(i, :) = zeros(1, length(tt_interp));
    end

end