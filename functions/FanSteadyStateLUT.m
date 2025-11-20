function U = FanSteadyStateLUT(F)

    data = readmatrix('Steady State Measurements.xlsx');

    inputs = data(:, 1);
    outputs = data(:, 2);
    
    % Create a linear interpolation function
    U = interp1(outputs, inputs, F, 'linear', 'extrap');

end

