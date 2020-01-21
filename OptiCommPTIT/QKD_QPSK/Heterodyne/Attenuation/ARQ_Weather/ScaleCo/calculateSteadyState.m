function [Result]=calculateSteadyState(P2)
    [V,D] = eig(P2');             %Find eigenvalues and left eigenvectors of A
    [~,ix] = min(abs(diag(D)-1)); %Locate an eigenvalue which equals 1
    v = V(:,ix)';                 %The corresponding row of V' will be a solution
    v = v/sum(v);                 %Adjust it to have a sum of 1
    Result=v;
end 