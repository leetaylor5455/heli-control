function [alpha, beta] = voltage2FanCoeffs(data)
%VOLTAGE2FANCOEFFS Returns linear coefficients for fan steady state data
%   Detailed explanation goes here

    x = data(7:end, 1); y = data(7:end, 2);
    X = [ones(length(x),1) x];
    b = X\y;
    
    alpha = b(1); beta = b(2);
end

