function BER = calculateBER(Ps_dBm,g)
    %Simulation Parameters
    GA=2;                          %Gain of the IF amplifier
    G_VCO=2;                       %VCO gain (rad/(VS))
    A_VCO=2;                       %VCO amplitude
    GM=2;                        %Multiplier gain(V^-1)
    R=0.75;                           %Detector responsivity (A/W)
    r=1000;                        %load impedance
    P_LO_dBm=-0.5;                 %Local oscillator power
    P_LO=(10.^(P_LO_dBm/10))*10^-3;
    deltaf=0.6*10^9;               %Laser lineWidth
    Pb_dBm=-40;                    %Average received background radiation power
    Pb=(10.^(Pb_dBm/10))*10^-3;
    T=25+273;                      %Receiver temperature in Kelvin degree
    q=1.6*10^-19;                  %Electron charge
    kB=1.38*10^-23;                %Boltzmann's constant 
    Fn=2;                          %Amplifier noise figure    
    r1=1000;
    r2=1000;
    C1=1*10^-6;
    
    kA=0.7;                        %Ionization
    FA=kA*g+(2-1/g)*(1-kA);        %Excess noise factor
    Ps_w=(10.^(Ps_dBm/10))*10^-3;
    Pn=R*Ps_w/q;                   %Normalized signal power
    
    for i=1:length(Ps_dBm)
        %Shot Noise + Phase Noise=White Frequency Noise+Flicker Frequency Noise
        G=GA*G_VCO*A_VCO*GM*R*r*sqrt(Ps_w*P_LO);
        To1=r1*C1;
        To2=r2*C1;
        fn=(1/2*pi)*sqrt(G/To1);   %Natural frequency
        n=pi*fn*To2;               %Damping coefficient
        sigma2_shot_phase=sqrt(2*pi*deltaf*(1+1./(4*n.^2))./Pn);
        %Background Noise 
        sigma2_background=2*q*g^2*R*FA*Pb*deltaf;
        %Thermal Noise
        sigma2_thermal=4*kB*T*Fn*deltaf/r;
        %The total phase error variance
        sigma2_total=sigma2_shot_phase+sigma2_background+sigma2_thermal;
        % Energy
        I2=2*R^2*Ps_w*P_LO*GA^2*GM^2*A_VCO^2;
%         I2=2*R^2*Ps_w*P_LO*GA^2;
        %BER Evaluation
        BER=1/2*erfc(sqrt(I2./sigma2_total));
    end
end