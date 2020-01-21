function [n1,n2]=gngauss(m,sgma)
    % [n1 n2]=gngauss(m,sgma)
    % [n1 n2]=gngauss(sgma)
    % [n1 n2]=gngauss
    % GNGAUSS generates two independent gaussian variables with 
    % mean m & S.D sgma
    % if one of the input argement missing it takes mean as zero
    % if neither mean nor variance is given, it generates two 
    %standard gaussian random variables

    if nargin==0
        m=0;
        sgma=1;
    elseif nargin==1
        sgma=m;  
        m=0;
    end
    u=rand;                         % uniform random variable in (0,1)
    z=sgma*(sqrt(2*log(1/(1-u))));   % rayleigh distributed random variable
    u=rand;                          % another uniform distributed variable in (0,1)
    n1=m+z*cos(2*pi*u);            
    n2=m+z*sin(2*pi*u);  
end