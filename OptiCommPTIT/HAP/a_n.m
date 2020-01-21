function [Result]=a_n(alpha,beta,n) 
    Result=(pi*(alpha*beta)^(n+beta))/(sin(pi*(alpha-beta))*gamma(alpha)*gamma(beta)*gamma(n-alpha+beta+1)*factorial(n));
end