function Result=jointProbabilite_QPSK(bit_Alice,bit_Bob,ScaleCo) 
    %Simulation Parameters
    global P_LO_dBm;               %Power of Local Oscillator (dBm)
    global Rb;                     %Bit rate (bps)
    global H_S;                    %Satellite altitude (m)
    global H_G;                    %Ground station height (m)
    global H_a;                    %Amospheric altitude (m)
    global P_T_dBm;                %Transmitted power (dBm)
    
    
    P_LO=10^(P_LO_dBm/10)*10^-3;
    
    kB=1.38*10^-23;                %Boltzman's constant (W/K/Hz)
    q=1.6*10^-19;                  %Electron charge (C)
    RL=50;                         %Load resistor (Ohm)
    T=298;                         %Receiver temperature (K)
    R=0.8;                         %PD responsivity
    x=0.8;                         %Excess noise factor (InGaAs APD)
    M=10;                          %Avalanche multiplication factor
    Id=3*10^-9;                    %Dark current(A)
    teta=10^-3;                    %Angle of divergence (rad)
    alpha1=0.43;                   %Atmospheric attenuation coefficient (dB/km)
    alpha=alpha1/4.343;            %(km^-1)
    zenithAng_Do=50;               %Zenith angle (degree)
    zenithAng=pi*zenithAng_Do/180; %(rad)
    r=0.25;                        %Receiver radius (m)
    G_Tx_dB=20;                    %Tx telescope gain (dB)
    G_Tx=10^(G_Tx_dB/10);
    G_Rx_dB=20;                    %Rx telescope gain (dB)
    G_Rx=10^(G_Rx_dB/10);
    deltaf=Rb/2;                   %Bandwidth of Noise (Hz)
    P_T=10^(P_T_dBm/10)*10^-3;     
    
    %Calculate QBER
    A=pi*r^2;
    L=(H_S-H_G)/cos(zenithAng);
    La=(H_a-H_G)/cos(zenithAng);
    h=A/(pi*(L*teta)^2)*exp(-alpha*La/1000);
    P_R=P_T*h;
    sigmaN2=2*q*M^(2+x)*(P_LO*R+P_R*G_Tx*G_Rx*R+Id)*deltaf+4*kB*T/RL*deltaf;
   
    
    I0=M*R*sqrt(P_R*P_LO*G_Tx*G_Rx);
    I1=-M*R*sqrt(P_R*P_LO*G_Tx*G_Rx);
    d0=ScaleCo*I0;
    d1=ScaleCo*I1;
    
    if bit_Alice==0 && bit_Bob==0
        Result=1/2*qfunc((d0-I0)/sqrt(sigmaN2));
    elseif bit_Alice==1 && bit_Bob==0
        Result=1/2*qfunc((d0-I1)/sqrt(sigmaN2));
    elseif bit_Alice==0 && bit_Bob==1
        Result=1/2*qfunc((I0-d1)/sqrt(sigmaN2));
    else
        Result=1/2*qfunc((I1-d1)/sqrt(sigmaN2));
    end    
end