function Result=calculateSigma_R_2(h)
    global C2n_0;     %The value of C2n at the ground level
    Omega=21;         %Windspeed
    h0=0;             %The height of the ground node
    Result=(0.00594.*(Omega./27).^2.*((10^(-5).*h).^10).*exp(-h./1000)...
           +2.7*10^(-16).*exp(-h./1500)+C2n_0.*exp(-h./100)).*(h-h0).^(5/6);
end