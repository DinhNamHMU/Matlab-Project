function [Result]=jointProbabilite_QPSK_Rf_AE3D(bit_Alice,bit_Eve,X_r_Eve_Array,Y_P_T_dBm_rray) 
     %Simulation Parameters
    global Rb;
    global P_LO_dBm;               %Power of Local Oscillator(dBm)
    kB=1.38*10^-23;                %Boltzman's constant(W/K/Hz)
    q=1.6*10^-19;                  %Electron charge(C)
    RL=50;                         %Load resistor(Ohm)
    T=298;                         %Receiver temperature(K)
    R=0.8;                         %PD responsivity
    x=0.8;                         %Excess noise factor(InGaAs APD)
    M=10;                          %Avalanche multiplication factor
    Id=3*10^-9;                    %Dark current(A)
    teta=10^-3;                    %Angle of divergence(rad)
    alpha1=0.43;                   %Atmospheric attenuation coefficient(dB/km)
    alpha=alpha1/4.343;            %(km^-1)
    H_S=600*10^3;                  %Satellite altitude(m)
    H_G=5;                         %Ground station height(m)
    H_a=20*10^3;                   %Amospheric altitude(m)
    zenithAng_Do=50;               %Zenith angle(degree)
    zenithAng=pi*zenithAng_Do/180; %(rad)
    L_AE=0.5;
    L1=(H_S-H_G)./cos(zenithAng);
    zenithAngEve=atan((sqrt(L1.^2-(H_S-H_G).^2)-L_AE)./(H_S-H_G));
    r=0.31;                        %Receiver radius(m)
    G_Tx_dB=20;                    %Tx telescope gain(dB)
    G_Tx=10^(G_Tx_dB/10);
    G_Rx_dB=20;                    %Rx telescope gain(dB)
    G_Rx=10^(G_Rx_dB/10);
    deltaf=Rb/2;                   %Bandwidth of Noise(Hz)
    P_LO=10^(P_LO_dBm/10)*10^-3;
    P_T=10.^(Y_P_T_dBm_rray./10).*10.^-3; 
    a=0.31;                        %The radius of the detection aperture
    Omega_z=18;
    
    %Calculate QBER
    %Beam spreading loss-The fraction of the power collected by the detector at ground station
    v=sqrt(pi).*a./(sqrt(2).*Omega_z);
    A_0=(erf(v)).^2;
    Omega_zeq_2=Omega_z.^2.*(sqrt(pi).*erf(v))./(2.*v.*exp(-v.^2));
    h_p=A_0.*exp(-2.*(X_r_Eve_Array.^2)./Omega_zeq_2);
    
    sigmaN2=2.*q.*M.^(2+x).*(P_LO.*R.*G_Tx.*G_Rx+Id).*deltaf+4.*kB.*T./RL.*deltaf;
    
    %Channel loss coefficient
    L=(H_S-H_G)./cos(zenithAngEve);
    La=(H_a-H_G)./cos(zenithAngEve);
    A=pi.*r.^2;
    h=G_Tx.*A./(pi.*(L.*teta).^2).*exp(-alpha.*La./1000).*G_Rx;
    P_R=P_T.*h.*h_p;
    
    I0=2*M.*R.*sqrt(P_R.*P_LO.*G_Tx.*G_Rx);
    I1=-2*M.*R.*sqrt(P_R.*P_LO.*G_Tx.*G_Rx);
    
    dE=0;
    
    if bit_Alice==0 && bit_Eve==0
        Result=1./2.*qfunc((dE-I0)./sqrt(sigmaN2));
    elseif bit_Alice==1 && bit_Eve==0
        Result=1./2.*qfunc((dE-I1)./sqrt(sigmaN2));
    elseif bit_Alice==0 && bit_Eve==1
        Result=1./2.*qfunc((I0-dE)./sqrt(sigmaN2));
    else
        Result=1./2.*qfunc((I1-dE)./sqrt(sigmaN2));
    end    
end
