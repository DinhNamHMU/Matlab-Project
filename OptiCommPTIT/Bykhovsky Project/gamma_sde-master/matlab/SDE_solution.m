clearvars

%rng('default')
N = 5e5; % sequence length
dt = 1e-4;
t = 0:dt:dt*N;
alpha = 1;
theta = 0.5;
tau_c = 20e-3;

x = zeros(1,N+1);
xi = randn(1,N);
x(1) = alpha*theta; % start with the mean value

for k = 1:N
    x(k+1) = 1/(tau_c+dt)* ...
        (x(k)*tau_c ...
        + alpha*theta*dt ...
        + theta*dt/2*(xi(k)^2-1) ...
        + sqrt(2*x(k)*theta*tau_c*dt)*xi(k) ...
        );
end

