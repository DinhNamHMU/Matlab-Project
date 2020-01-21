function jointProbabiliteGamma=jointProbabiliteGamma_AB_Direct(bit_Alice,bit_Bob,ScaleCo)
    %Gamma-Gamma channels
    %Simulation Parameters
    
    %Laguerre polynomial weights and abscissas
    %tl-abscissas factor of Laguerre polynomial
    t=[0.137793470540,0.729454549503,1.808342901740,3.401433697855,5.552496140064,...
      8.330152746764,11.843785837900,16.279257831378,21.996585811981,29.920697012274];
    %vl-weight factor of Laguerre polynomial
    v=[0.308441115765,0.401119929155,0.218068287612,0.0620874560987,0.00950151697518,...
      0.000753008388588,0.0000282592334960,0.000000424931398496,0.00000000183956482398,0.000000000000991182721961]; 
    
    global P_dBm;              %Peak transmitted power
    global Omega_z_P;  
    global Omega_z_G;
    global ModDepth;
    global B;
                   
    %FSO channel  
    %Variance of background noise
    sigmab_P_2=4.435*10^(-28); %Satellite-to-HAP
    sigmab_G_2=1.445*10^(-25); %HAP-to-ground
    sigmab_SG_2=7.7*10^(-27);  %Satellite-to-ground
    
    sigma1=0.43;               %Attenuation coefficient (dB/km)
    sigma=sigma1/4.343;               
    
    B0=125*10^9;               %Optical bandwidth
    
    %LEO Satellite (Alice)
    lamda=1550*10^-9;          %Wavelength
    H_S=610*10^3;              %LEO satellite altitude
    ZenithAngleDegree_S=50;    %Zenith angle
    ZenithAngle_S=ZenithAngleDegree_S./180.*pi;
    G_TX_S_dB=132;             %TX Telescope Gain
    G_TX_S=10.^(G_TX_S_dB./10);
    deltaf=B;                %Bandwidth
    
    %Relay (HAP)
    H_P=20*10^3;               %HAP altitude
    ZenithAngleDegree_P=50;    %Zenith angle
    ZenithAngle_P=ZenithAngleDegree_P./180.*pi;
    a_P=0.05;                  %The radius of the detection qperture
    n_sp=5;                    %ASE parameter
    G_TX_P_dB=60;              %TX Telescope Gain
    G_TX_P=10.^(G_TX_P_dB./10);
    G_RX_P_dB=100;             %RX Telescope Gain
    G_RX_P=10.^(G_RX_P_dB./10);
    
    %Bob (Vehicle or UAV)
    a_G=0.31;                  %The radius of the dection aperture
    G_RX_G_dB=121;             %RX Telescope Gain
    G_RX_G=10.^(G_RX_G_dB./10);
    nguy=0.62;                 %Quantum efficiency
    kA=0.7;                    %Ionization factor
    M=10;                      %Avalanche Multiplication Factor
    FA=kA.*M+(2-1./M).*(1-kA);    %Excess noise factor
    Fn=2;                      %Amplifier noise figure
    RL=1000;                   %Load resistance
    T=300;                     %Temperature
    
    P=(10.^(P_dBm./10)).*10.^-3;
    q=1.6*10^-19;              %Electron charge
    kB=1.38*10^-23;            %Boltzmann's constant
    h=6.626*10^-34;            %Planck's constant 
    c=3*10^8;                  %Speed of Light
    R=(nguy.*q)./(h.*c./lamda);%Detector responsivity 
    
    %Calculate QBER
    %Free-space loss
    L_S=(H_S-H_P)./cos(ZenithAngle_S);
    FSL=(4.*pi.*L_S./lamda).^2;
    
    %Path loss
    L_P=H_P./cos(ZenithAngle_P);
    hl=exp(-sigma.*L_P./1000);  
    
    %The fraction of the power collected by the detector at HAP
    r=0;
    v_P=sqrt(pi).*a_P./(sqrt(2).*Omega_z_P);
    A_0_P=(erf(v_P)).^2;
    Omega_zeq_P_2=Omega_z_P.^2.*(sqrt(pi).*erf(v_P))./(2.*v_P.*exp(-v_P.^2));
    h_p_P=A_0_P.*exp(-2.*(r.^2)./Omega_zeq_P_2);
    
    %The fraction of the power collected by the detector at ground station
    v_G=sqrt(pi).*a_G./(sqrt(2).*Omega_z_G);
    A_0_G=(erf(v_G)).^2;
    Omega_zeq_G_2=Omega_z_G.^2.*(sqrt(pi).*erf(v_G))./(2.*v_G.*exp(-v_G.^2));
    h_p_G=A_0_G.*exp(-2.*(r.^2)./Omega_zeq_G_2);
    
    %Refrective index structure coefficient
    k=2.*pi./lamda;
    h0=0; %The height of the ground node
    
    integral=quad(@calculateSigma_R_2,h0,H_P);
    
    sigma_R_2=2.25.*k.^(7/6).*(sec(ZenithAngle_P)).^(11./6).*integral;
    
    %Received background light power at HAP and GS
    N_0_P=2.*sigmab_P_2;
    N_0_G=2.*sigmab_G_2;
    N_0_SG=2.*sigmab_SG_2;
    P_b_P=N_0_P.*B0;
    P_b_G=N_0_G.*B0;
    P_b_SG=N_0_SG.*B0;
    
    %ASE noise
    P_a=2.*n_sp.*h.*c./lamda.*B0;
    
    %Peak received power at Bob
    P_r_G=1./FSL.*P.*G_TX_S.*h_p_G.*G_RX_G.*hl;
    
    Ei0=-1./4.*R.*M.*P_r_G.*ModDepth;
    Ei1=-Ei0;
    
    alpha=(exp(0.49.*sigma_R_2./(1+1.11.*(sqrt(sigma_R_2)).^(12./5)).^(7./6))-1).^-1;
    beta=(exp(0.51.*sigma_R_2./(1+0.69*(sqrt(sigma_R_2)).^(12./5)).^(5/6))-1).^-1;
    
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
            i0=-1./(4.*special(i)).*R.*M.*P_r_G.*ModDepth.*t(l);
            i1=-i0;

            sigmaN_i_l=sqrt(2.*q.*FA.*(M.^2).*R.*(1./(4.*special(i)).*R.*M.*P_r_G.*ModDepth.*t(l)+...
                       P_b_SG.*G_RX_G).*deltaf+4.*kB.*T.*Fn.*deltaf./RL);
            
            d0=Ei0-ScaleCo.*sqrt(sigmaN_i_l.^2);
            d1=Ei1+ScaleCo.*sqrt(sigmaN_i_l.^2);
            
            if bit_Alice==0 && bit_Bob==0
                Sum=Sum+1/2.*a(i).*special(i).^(-b(i)).*v(l).*t(l).^(b(i)-1).*qfunc((i0-d0)./sigmaN_i_l);
            elseif bit_Alice==1 && bit_Bob==0
                Sum=Sum+1/2.*a(i).*special(i).^(-b(i)).*v(l).*t(l).^(b(i)-1).*qfunc((i1-d0)./sigmaN_i_l); 
            elseif bit_Alice==0 && bit_Bob==1
                Sum=Sum+1/2.*a(i).*special(i).^(-b(i)).*v(l).*t(l).^(b(i)-1).*qfunc((d1-i0)./sigmaN_i_l);      
            else 
                Sum=Sum+1/2.*a(i).*special(i).^(-b(i)).*v(l).*t(l).^(b(i)-1).*qfunc((d1-i1)./sigmaN_i_l);
            end
        end 
    end
    
  	jointProbabiliteGamma=Sum;
end