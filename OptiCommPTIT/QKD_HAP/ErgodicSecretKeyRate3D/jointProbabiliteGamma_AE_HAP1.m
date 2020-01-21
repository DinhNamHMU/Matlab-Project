function jointProbabiliteGamma=jointProbabiliteGamma_AE_HAP1(bit_Alice,bit_Eve,X_r_Array)
    %Gamma-Gamma channels
    %Simulation Parameters
    
    global P_dBm;               %Peak transmitted power
    global Omega_z_P;
    global ModDepth;
    global B;
                  
    %Variance of background noise
    sigmab_P_2=4.435.*10^(-28); %Satellite-to-HAP
    B0=125.*10.^9;              %Optical bandwidth
    
    %LEO Satellite (Alice)
    lamda=1550.*10.^-9;         %Wavelength
    H_S=610.*10.^3;             %LEO satellite altitude
    ZenithAngleDegree_S=50;     %Zenith angle
    ZenithAngle_S=ZenithAngleDegree_S./180.*pi;
    G_TX_S_dB=132;              %TX Telescope Gain
    G_TX_S=10.^(G_TX_S_dB./10);
    deltaf=B;                   %Bandwidth
    
    %Relay (HAP)
    H_P=20*10^3;                %HAP altitude
    a_P=0.05;                   %The radius of the detection qperture
    
    %Bob (Vehicle or UAV)
    nguy=0.62;                  %Quantum efficiency
    kA=0.7;                     %Ionization factor
    M=10;                       %Avalanche Multiplication Factor
    FA=kA.*M+(2-1./M).*(1-kA);  %Excess noise factor
    Fn=2;                       %Amplifier noise figure
    RL=1000;                    %Load resistance
    T=300;                      %Temperature
    
    %Eve (HAP of Vehicle)
    G_RX_E_1_dB=204;            %RX Telescope Gain (Scenario 1)
    G_RX_E_1=10.^(G_RX_E_1_dB./10);
    
    P=(10.^(P_dBm./10)).*10.^-3;
    q=1.6*10^-19;               %Electron charge
    kB=1.38*10^-23;             %Boltzmann's constant
    h=6.626*10^-34;             %Planck's constant 
    c=3*10^8;                   %Speed of Light
    R=(nguy.*q)./(h.*c./lamda); %Detector responsivity
    Sum=0;
    
    %Calculate QBER
    %Free-space loss
    L_S=(H_S-H_P)./cos(ZenithAngle_S);
    FSL=(4.*pi.*L_S./lamda).^2;
    
    %The fraction of the power collected by the detector at HAP
    v_P=sqrt(pi).*a_P./(sqrt(2).*Omega_z_P);
    A_0_P=(erf(v_P)).^2;
    Omega_zeq_P_2=Omega_z_P.^2.*(sqrt(pi).*erf(v_P))./(2.*v_P.*exp(-v_P.^2));
    h_p_P_E=A_0_P.*exp(-2.*(X_r_Array.^2)./Omega_zeq_P_2);
    
    %Received background light power at HAP and GS
    N_0_P=2.*sigmab_P_2;
    P_b_E=N_0_P.*B0;
    
    %Peak received power at Bob
    P_r_E=1./FSL.*R.*M.*P.*G_TX_S.*h_p_P_E.*G_RX_E_1;
    
    sigmaN_E_2=2.*q.*R.*(M.^2).*FA.*(1./4.*P_r_E.*ModDepth+P_b_E.*G_RX_E_1).*deltaf+4.*kB.*T.*Fn.*deltaf./RL;
    
    i0=-1./4.*P_r_E.*ModDepth;
    i1=-i0;
    
    dE=0;
    
    if bit_Alice==0 && bit_Eve==0
        Sum=Sum+1./2.*qfunc((i0-dE)./sqrt(sigmaN_E_2));
    elseif bit_Alice==1 && bit_Eve==0
        Sum=Sum+1./2.*qfunc((i1-dE)./sqrt(sigmaN_E_2));      
    elseif bit_Alice==0 && bit_Eve==1
        Sum=Sum+1./2.*qfunc((dE-i0)./sqrt(sigmaN_E_2));         
    else 
        Sum=Sum+1./2.*qfunc((dE-i1)./sqrt(sigmaN_E_2));       
    end
    
  	jointProbabiliteGamma=Sum;
end