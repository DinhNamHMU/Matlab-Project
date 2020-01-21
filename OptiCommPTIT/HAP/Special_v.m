function [Result]=Special_v(p,v,q,A_v,B_v,C_v)
    z=B_v^2/(4*A_v*C_v);
    Result=(pi^2)/(p^q*gamma(v)*sin(pi*(q-v)))*((p/z)^v*((laguerreL(-v,v-q,p/z))/(sin(pi*v)*gamma(1-q)))...
    -(p/z)^q*((laguerreL(-q,q-v,p/z))/(sin(pi*q)*gamma(1-v))));
end