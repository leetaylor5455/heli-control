tune = 'robust';

Optimal_reference;

K_lqr = tuneLQR(test, sysdt_bar);
K_r = tuneKr(sys_bar, K_lqr);