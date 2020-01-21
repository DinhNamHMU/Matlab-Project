function Result=jointProbabiliteLog(bit_Alice,bit_Bob,ScaleCo)
    %Log-normal channels
    %Simulation Parameters
    
    %Hermite polynomial weights and roots 
    %Omega-weight factor of Hermite polynomial 
    w=[2.229393645534e-13,4.399340992273e-10,1.086069370769e-7,7.802556478532e-6,0.00022833863601,0.003243773342238, 0.024810520887,0.1090172060200,0.2866755053628,0.4622436696006,...
           0.4622436696006,0.2866755053628,0.1090172060200,0.024810520887,0.003243773342238,0.00022833863601,7.802556478532e-6,1.086069370769e-7,4.399340992273e-10,2.229393645534e-13];
    %x-zeros factor of Hermite polynomial
    x=[-5.3874808900112,-4.6036824495507,-3.9447640401156,-3.3478545673832,-2.7888060584281,-2.2549740020893,-1.7385377121166,-1.2340762153953,-0.7374737285454,-0.2453407083009,...
        0.2453407083009,0.7374737285454,1.2340762153953,1.7385377121166,2.2549740020893,2.7888060584281,3.3478545673832,3.9447640401156,4.6036824495507,5.3874808900112];
   
    global Rb;
    P_dBm=0;                  %Peak transmitted power(dBm)
    P=(10^(P_dBm/10))*10^-3;
    ModDepth=0.4;             %Modulaton Depth
    q=1.6*10^-19;             %Electron charge(C)
    g=15;                     %Multiply coefficient
    kA=0.7;                   %Ionization
    FA=kA*g+(2-1/g)*(1-kA);   %Excess noise factor
    Pb_dBm=-40;               %Average received background radiation power(dBm)
    Pb=(10^(Pb_dBm/10))*10^-3;
    deltaf=Rb/2;              %Bandwidth of Noise(Hz)
    kB=1.38*10^-23;           %Boltzmann's constant(W/K/Hz)
    T=300;                    %Receiver temperature in Kelvin degree(K)
    Fn=2;                     %Amplifier noise figure
    RL=1000;                  %Load impedance(Ohm)
    D=0.02;                   %Diameter(m)
    tetaAngle=10^-3;          %Angle of divergence(rad)
    betal1=0.43;              %Attenuatation coefficient(dB/km)
    betal=betal1/4.343;       %(km^-1)
    L=1000;                   %Transmission distance(m)
    lamda=1550*10^-9;         %Wavelength(m)
    C2n=10^-15;               %Refractive index structure coefficient 
    nguy=0.62;                %Quantum efficiency
    h=6.626*10^-34;           %Planck's constant 
    c=3*10^8;                 %Speed of Light
    R=(nguy*q)/(h*c/lamda);   %Detector responsivity (A/W)
    
    Sum=0;
    
    %Calculate QBER
    for i=1:length(x)  
        sigmaX2=0.307*(2*pi/lamda)^(7/6)*L^(11/6)*C2n; %Standard variance of log-amplitude fluctuatuion
        uX=-sigmaX2;                                   %The mean
        
        A=pi*(D/2)^2;                                  %Area of the receiver aperture
        hl=A/(pi*(tetaAngle/2*L)^2)*exp(-betal*L/1000);  
        
        i0=-1/4*R*g*P*ModDepth*hl*exp(2*sqrt(2)*sqrt(sigmaX2)*x(i)+2*uX);
        i1=-i0;
        
        Ei0=-1/4*R*g*P*ModDepth*hl;
        Ei1=-Ei0;
        
        sigmaN_i=sqrt(2*q*FA*(g^2)*R*(1/4*P*ModDepth*hl*exp(2*sqrt(2)*sqrt(sigmaX2)*x(i)+2*uX)+Pb)*deltaf+(4*kB*T*Fn*deltaf)/RL);
        
        d0=Ei0-ScaleCo*sqrt(sigmaN_i^2);
        d1=Ei1+ScaleCo*sqrt(sigmaN_i^2);

        if bit_Alice==0 && bit_Bob==0
            Sum=Sum+1/(2*sqrt(pi))*w(i)*qfunc((i0-d0)/sigmaN_i);
        elseif bit_Alice==1 && bit_Bob==0
            Sum=Sum+1/(2*sqrt(pi))*w(i)*qfunc((i1-d0)/sigmaN_i);
        elseif bit_Alice==0 && bit_Bob==1
            Sum=Sum+1/(2*sqrt(pi))*w(i)*qfunc((d1-i0)/sigmaN_i);
        else 
            Sum=Sum+1/(2*sqrt(pi))*w(i)*qfunc((d1-i1)/sigmaN_i);
        end
    end
    
%     for i=1:length(x)  
%         sigmaX2=0.307.*(2.*pi./lamda).^(7/6).*L.^(11/6).*C2n; %Standard variance of log-amplitude fluctuatuion
%         uX=-sigmaX2;                                   %The mean
%         A=pi.*(D./2).^2;                                  %Area of the receiver aperture
%         hl=A./(pi.*(tetaAngle./2.*L).^2).*exp(-betal.*L./1000);  
%         i0=-1/4.*R.*g.*P.*ModDepth.*hl.*exp(2.*sqrt(2).*sqrt(sigmaX2).*x+2.*uX);
%         i1=-i0;
%         Ei0=-1/4.*R.*g.*P.*ModDepth.*hl;
%         Ei1=-Ei0;
%         sigmaN_i=sqrt(2.*q.*FA.*(g.^2).*R.*(1/4.*P.*ModDepth.*hl.*exp(2.*sqrt(2).*sqrt(sigmaX2).*x+2.*uX)+Pb).*deltaf+(4.*kB.*T.*Fn.*deltaf)./RL);
%         d0=Ei0-ScaleCo.*sqrt(sigmaN_i.^2);
%         d1=Ei1+ScaleCo.*sqrt(sigmaN_i.^2);
% 
%         if bit_Alice==0 && bit_Bob==0
%             Sum=1./(2.*sqrt(pi)).*w.*qfunc((i0-d0)./sigmaN_i);
%         elseif bit_Alice==1 && bit_Bob==0
%             Sum=1./(2.*sqrt(pi)).*w.*qfunc((i1-d0)./sigmaN_i);
%         elseif bit_Alice==0 && bit_Bob==1
%             Sum=1./(2.*sqrt(pi)).*w.*qfunc((d1-i0)./sigmaN_i);
%         else 
%             Sum=1./(2.*sqrt(pi)).*w.*qfunc((d1-i1)./sigmaN_i);
%         end
%     end

    Result=Sum;
end