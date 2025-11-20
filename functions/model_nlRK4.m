function x_next = model_nlRK4(f, x, u, dt)
    
    % Compute RK4 terms
    k1 = f(x, u);
    k2 = f(x + 0.5*dt*k1, u);
    k3 = f(x + 0.5*dt*k2, u);
    k4 = f(x + dt*k3, u);
    
    x_next = x + (dt/6)*(k1 + 2*k2 + 2*k3 + k4);
end