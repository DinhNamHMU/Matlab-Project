function [Result]=Phi_v(alpha,beta,n,m,A_v,B_v,C_v)
    betaRound=round(beta);
    Result=a_n(alpha,beta,n)*1/((2*A_v)^(n+beta+1))*nchoosek(n+betaRound-1,m)*B_v^m*(4*A_v*C_v)^((n+beta-1-m)/2);
end