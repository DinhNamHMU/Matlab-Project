function Result=jointProbabiliteLogPhaseNoiseDamping(bit_Alice,bit_Bob,DampingCo,ScaleCo)
    %Log-normal channels with PLL-Phase Noise
    %Simulation Parameters
    
    %Hermite polynomial weights and roots
    %omegai-weight factor of Hermite polynomial
    %xi-zeros factor of Hermite polynomial
    w=[2.22939364554e-13,4.39934099226e-10,1.08606937077e-7,7.8025564785e-6,0.000228338636017,0.00324377334224, 0.0248105208875,0.10901720602,0.286675505363,0.462243669601,...
    0.462243669601,0.286675505363,0.10901720602,0.0248105208875,0.00324377334224,0.000228338636017,7.8025564785e-6,1.08606937077e-7,4.39934099226e-10,2.22939364554e-13];
    x=[-5.38748089001,-4.60368244955,-3.94476404012,-3.34785456738,-2.78880605843,-2.25497400209,-1.73853771212,-1.2340762154,-0.737473728545,-0.245340708301,...
    0.245340708301,0.737473728545,1.2340762154,1.73853771212,2.25497400209,2.78880605843,3.34785456738,3.94476404012,4.60368244955,5.38748089001];
    
    P_dBm=0;                  %Peak transmitted power
    P=(10^(P_dBm/10))*10^-3;
    ModDepth=0.4;             %Modulaton Depth
    q=1.6*10^-19;             %Electron charge
    g=15;                     %Multiply coefficient
    kA=0.7;                   %Ionization
    FA=kA*g+(2-1/g)*(1-kA);   %Excess noise factor
    Pb_dBm=-40;               %Average received background radiation power
    Pb=(10^(Pb_dBm/10))*10^-3;
    Rb=10^9;                  % Bit rate
    deltaf=Rb/2;              %Bandwidth
    kB=1.38*10^-23;           %Boltzmann's constant
    T=300;                    %Receiver temperature in Kelvin degree
    Fn=2;                     %Amplifier noise figure
    RL=1000;                  %load impedance
    D=0.02;                   %Diameter
    teta=10^-3;               %Angle of divergence
    betal1=0.43;              %Attenuatation coefficient(dB/km)
    betal=betal1/4.343;       %(km^-1)
    L=1000;                   %Transmission distance
    lamda=1550*10^-9;         %Wavelength
    C2n=10^-15;               %Refractive index structure coefficient 
    nguy=0.62;                %Quantum efficiency
    h=6.626*10^-34;           %Planck's constant 
    c=3*10^8;                 %Speed of Light
    R=(nguy*q)/(h*c/lamda);   %Detector responsivity (A/W)
    Sum=0;
    
    %Paramater of PLL-Phase Noise
    Pn=R*P/q;
    GA=1;                     %Gain of the IF amplifier
    G_VCO=1;                  %VCO gain (rad/(VS))
    A_VCO=1;                  %VCO amplitude
    GM=1;                     %Multiplier gain(V^-1)
    P_LO_dBm=0;               %Local oscillator power
    P_LO=(10.^(P_LO_dBm/10))*10^-3;
    r1=1000;
    r2=1000;
    C1=0.5*10^-6;
    deltaV=2.26*10^-3*Rb;
    
    for i=1:length(x)
        %Phase Noise=White Frequency Noise+Flicker Frequency Noise
        G=GA*G_VCO*A_VCO*GM*R*RL*sqrt(P*P_LO);
        To1=r1*C1;
        To2=r2*C1;
        fn=(1/2*pi)*sqrt(G/To1);                                             %Natural frequency
        %DampingCo=pi*fn*To2;                                                 %Damping coefficient
        sigma2_phaseNoise=0.5*sqrt(pi*deltaV*(1+4*DampingCo^2)/(8*DampingCo^2*Pn));
       
        sigmaX2=0.307*(2*pi/lamda)^(7/6)*L^(11/6)*C2n;                         %Standard variance of log-amplitude fluctuatuion
        uX=-sigmaX2;                                                           %The mean
        A=pi*(D/2)^2;                                                          %Area of the receiver aperture
        hl=A/(pi*(teta/2*L)^2)*exp(-betal*L/1000);  
        i0=-1/4*R*g*P*ModDepth*hl*exp(2*sqrt(2)*sqrt(sigmaX2)*x(i)+2*uX);
        i1=-i0;
        Ei0=-1/4*R*g*P*ModDepth*hl;
        Ei1=-Ei0;
        sigmaN_i=sqrt(2*q*FA*g^2*R*(1/4*P*ModDepth*hl*exp(2*sqrt(2)*sqrt(sigmaX2)*x(i)+2*uX)+Pb)*deltaf+(4*kB*T*Fn*deltaf)/RL+sigma2_phaseNoise);
        d0=Ei0-ScaleCo*sqrt(sigmaN_i^2);
        d1=Ei1+ScaleCo*sqrt(sigmaN_i^2);

        if bit_Alice==0 && bit_Bob==0
            Sum(i)=1/(2*sqrt(pi))*w(i)*qfunc((i0-d0)/sigmaN_i);
        elseif bit_Alice==1 && bit_Bob==0
            Sum(i)=1/(2*sqrt(pi))*w(i)*qfunc((i1-d0)/sigmaN_i);
        elseif bit_Alice==0 && bit_Bob==1
            Sum(i)=1/(2*sqrt(pi))*w(i)*qfunc((d1-i0)/sigmaN_i);
        else 
            Sum(i)=1/(2*sqrt(pi))*w(i)*qfunc((d1-i1)/sigmaN_i);
        end
    end
    Result=sum(Sum);
end