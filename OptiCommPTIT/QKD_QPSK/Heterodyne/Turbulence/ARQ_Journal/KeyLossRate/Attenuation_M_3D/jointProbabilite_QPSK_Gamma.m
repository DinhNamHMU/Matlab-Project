function jointProbabiliteGamma=jointProbabilite_QPSK_Gamma(bit_Alice,bit_Bob,Attenuation,P_T_dBm,C2n) 
    %Gamma-Gamma channels
    %Simulation Parameters
    
    %Laguerre polynomial weights and abscissas
    %tl-abscissas factor of Laguerre polynomial
    t=[0.137793470540,0.729454549503,1.808342901740,3.401433697855,5.552496140064,...
       8.330152746764,11.843785837900,16.279257831378,21.996585811981,29.920697012274];
    %vl-weight factor of Laguerre polynomial
    v=[0.308441115765,0.401119929155,0.218068287612,0.0620874560987,0.00950151697518,...
       0.000753008388588,0.0000282592334960,0.000000424931398496,0.00000000183956482398,0.000000000000991182721961];    
    
    global P_LO_dBm;               %Power of Local Oscillator(dBm)
    global Rb;                     %Bit rate(bps)
    global H_S;                    %Satellite altitude (m)
    global H_G;                    %Ground station height (m)
    global H_a;                    %Amospheric altitude (m)
    global ScaleCo;
    global lamda_wavelength;
    global Omega_z_G;
    global C2n_0;
    global zenithAng_Do

    kB=1.38.*10.^-23;              %Boltzman's constant(W/K/Hz)
    q=1.6.*10.^-19;                %Electron charge(C)
    RL=50;                         %Load resistor(Ohm)
    T=298;                         %Receiver temperature(K)
    R=0.8;                         %PD responsivity
    x=0.8;                         %Excess noise factor(InGaAs APD)
    M=10;                          %Avalanche multiplication factor
    Id=3.*10.^-9;                  %Dark current(A)
    zenithAng=pi.*zenithAng_Do./180; %(rad)
    G_Tx_dB=130;                   %Tx telescope gain(dB)
    G_Tx=10.^(G_Tx_dB./10);
    G_Rx_dB=100;                   %Rx telescope gain(dB)
    G_Rx=10.^(G_Rx_dB./10);
    deltaf=Rb./2;                   %Bandwidth of Noise(Hz)
    P_LO=10.^(P_LO_dBm./10).*10.^-3;
    P_T=10.^(P_T_dBm./10).*10.^-3;  %Transmitted power(W)
    a_G=0.31;                       %The radius of the dection aperture
    
    %Calculate QBER
    %Free-space loss
    L_S=(H_S-H_a)./cos(zenithAng);
    FSL=(4.*pi.*L_S./lamda_wavelength).^2;
    
     %Path loss
    Attenuation_ClearAir=0.43;
    H_Attenuation=50;
    alphal1=Attenuation/4.343; 
    alphal2=Attenuation_ClearAir/4.343;
    La1=(H_Attenuation-H_G)/cos(zenithAng);
    La2=(H_a-H_G)/cos(zenithAng)-La1;
    hl1=exp(-alphal1*La1/1000);
    hl2=exp(-alphal2*La2/1000);
    hl=hl1*hl2;
    
    %The fraction of the power collected by the detector at GS
    r=0;
    v_G=sqrt(pi).*a_G./(sqrt(2).*Omega_z_G);
    A_0_G=(erf(v_G)).^2;
    Omega_zeq_G_2=Omega_z_G.^2.*(sqrt(pi).*erf(v_G))./(2.*v_G.*exp(-v_G.^2));
    h_p_G=A_0_G.*exp(-2.*(r.^2)./Omega_zeq_G_2);
    
    EI0=M.*R.*sqrt(G_Tx.*1./FSL.*P_T.*hl.*h_p_G.*G_Rx.*P_LO);
    EI1=-EI0;
    
    %Refrective index structure coefficient
    k=2.*pi./lamda_wavelength;
    C2n_0=C2n;
    integral=quad(@calculateSigma_R_2,H_G,H_a);
    sigmaR2=2.25.*k.^(7/6).*(sec(zenithAng)).^(11./6).*integral;
    
    %Gamma-Gamma
    alpha=(exp(0.49.*sigmaR2./(1+1.11.*(sqrt(sigmaR2)).^(12./5)).^(7./6))-1).^-1;
    beta=(exp(0.51.*sigmaR2./(1+0.69.*(sqrt(sigmaR2)).^(12./5)).^(5./6))-1).^-1;
    
    teta=zeros(1,length(t));
    b=zeros(1,length(t));
    special=zeros(1,length(t));
    temp=zeros(1,length(t));
    a=zeros(1,length(t));
    Sum=0;
    
    for i=1:length(t)
        teta(i)=(((alpha.*beta).^alpha).*v(i).*t(i).^(-alpha+beta-1))./(gamma(alpha).*gamma(beta));
        b(i)=alpha;
        special(i)=alpha.*beta./t(i);
    end
    for j=1:length(t)
            temp(j)=teta(j).*gamma(b(j)).*special(j).^(-b(j));
    end
    temp1=sum(temp);
    
    for i=1:length(t)
        a(i)=teta(i)./temp1;     
        for l=1:length(t)
            I0=M.*R.*sqrt(G_Tx.*1./FSL.*P_T.*hl.*h_p_G.*t(l)./special(i).*G_Rx.*P_LO);
            I1=-I0;
            
            sigmaN_i_l=sqrt(2.*q.*M.^(2+x).*(R.*P_LO+R.*G_Tx.*1./FSL.*P_T.*hl.*h_p_G.*t(l)./special(i).*G_Rx+Id).*deltaf+4.*kB.*T./RL.*deltaf);
            
            d0=EI0+ScaleCo.*sqrt(sigmaN_i_l.^2);
            d1=EI1-ScaleCo.*sqrt(sigmaN_i_l.^2);
            
            if bit_Alice==0 && bit_Bob==0
                Sum=Sum+1./2.*a(i).*special(i).^(-b(i)).*v(l).*t(l).^(b(i)-1).*qfunc((d0-I0)./sigmaN_i_l);   
            elseif bit_Alice==1 && bit_Bob==0
                Sum=Sum+1./2.*a(i).*special(i).^(-b(i)).*v(l).*t(l).^(b(i)-1).*qfunc((d0-I1)./sigmaN_i_l);    
            elseif bit_Alice==0 && bit_Bob==1
                Sum=Sum+1./2.*a(i).*special(i).^(-b(i)).*v(l).*t(l).^(b(i)-1).*qfunc((I0-d1)./sigmaN_i_l);      
            else 
                Sum=Sum+1./2.*a(i).*special(i).^(-b(i)).*v(l).*t(l).^(b(i)-1).*qfunc((I1-d1)./sigmaN_i_l);
            end
        end
    end
    
  	jointProbabiliteGamma=Sum;
end