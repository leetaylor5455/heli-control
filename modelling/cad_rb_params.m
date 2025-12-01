m1_cad = (116.16e-3) / 2; % Half the mass of the pitch assembly
m2_cad = 97.17e-3; % Counterweight mass

l2_cad = sqrt( 5.37e5*(1e-3*1e-6) / (2*m1_cad) )

% Measured masses
F = [2*m1_cad 0 m2_cad
    0 2*m1_cad 0
    2*m1_cad 2*m1_cad m2_cad];

% Measured inertias
b = [2.36e6 * (1e-3 * 1e-6) % Je
    5.37e5 * (1e-3 * 1e-6) % Jp
    2.692e6 * (1e-3 * 1e-6) % Jt
    ];

% Solve for lengths
l_cad = sqrt(pinv(F)*b);


% Jp_cad = 3.353e5 * (1e-3 * 1e-6); % J of the psi assembly
% mp_cad = 76.76e-3; % Mass of the pitch assembly
% m2_cad = mp_cad / 2; % Lumped mass of one fan
% 
% l2_cad = sqrt(Jp_cad/mp_cad)
% 
% Je_cad = mp_cad*(118e-3)^2 + (97e-3)*(110e-3)^2

% z = inv(F) * b

% From CAD
% J_E_real = 2.36e6 * (1e-3 * 1e-6) % Convert to SI
% J_Theta_real = 2.692e6 * (1e-3 * 1e-6)
% J_Psi_real = 3.353e5 * (1e-3 * 1e-6) 