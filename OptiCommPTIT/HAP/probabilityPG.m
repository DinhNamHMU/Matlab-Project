function [P_PG,N_0_P,P_r_P]=probabilityPG() 
    %Simulation Parameter
    global P_t_S;
    global P_t_P;
    global G_A;
    
    %FSO channel
    w=21;                      %Wind speed
    %Variance of background noise
    sigma_bP_2=4.435*10^(-28); %Satellite-to-HAP
    sigma_bSG_2=7.7*10^(-27);  %Satellite-to-ground
    sigma_bG_2=1.445*10^(-25); %HAP-to-ground
    sigma=0.4;                 %Attenuation (km^-1)
    B_0=125*10^9;              %Optical bandwidth
    
    %LEO Satellite
    lamda=1550*10^-9;          %Wavelength
    H_S=610*10^3;              %LEO satellite altitude
    ZenithAngleDegree=50;      %Zenith angle
    ZenithAngle=ZenithAngleDegree*pi/180;
    G_TX_S_dB=106;             %TX telescope gain
    G_TX_S=10^(G_TX_S_dB/10);
    B=10*10^9;                 %Bit rate
    
    %High Altitude Platform
    H_P=20*10^3;               %HAP altitude
    G_TX_P_dB=5;               %TX telescope gain
    G_TX_P=10^(G_TX_P_dB/10);
    G_RX_P_dB=100;             %RX telescope gain
    G_RX_P=10^(G_RX_P_dB/10); 
    
    %Ground station
    h0=1;                      %Receiver height
    G_RX_G_dB=10;              %RX telescope gain
    G_RX_G=10^(G_RX_G_dB/10); 
    M=10;                      %Avalanche multiplication factor
    R=0.8;                     %Responsivity
    x=0.8;                     %Excess noise factor
    R_L=50;                    %Load resistance
    T=298;                     %Temperature
    
    q=1.6*10^(-19);            %Electron charge
    k_B=1.38*10^(-23);         %Boltzmann's constant
    deltaf=B; 
    
    %Path loss
    L_p=H_P/cos(ZenithAngle);
    h_l_P=exp(-sigma*L_p/1000);
    
    %Free-space loss
    L_S=(H_S-H_P)/cos(ZenithAngle);
    FSL=(4*pi*L_S/lamda)^2;
    
    %Refrective index structure coefficient
    k=2*pi/lamda;
    integral=quad(@calculateSigma_R_2,h0,H_P);
    
    sigma_R_2=2.25*k^(7/6)*(sec(ZenithAngle))^(11/6)*integral;
    
    %Atmosphric turbulence
    alpha=(exp(0.49*sigma_R_2/(1+1.11*(sqrt(sigma_R_2))^(12./5))^(7/6))-1)^-1;
    beta=(exp(0.51*sigma_R_2/(1+0.69*(sqrt(sigma_R_2))^(12/5))^(5/6))-1)^-1;
    
    %Receiver background light power
    N_0_P=2*sigma_bP_2*G_RX_P;
    N_0_G=2*sigma_bG_2*G_RX_G;
    P_b_P=N_0_P*B_0;
    P_b_G=N_0_G*B_0;
    
    %Recieve Power
    P_r_P=P_t_S*G_TX_S*G_RX_P/FSL;
    P_r_G=P_t_P*G_TX_P*G_RX_G;
    
    %Calculation
    %Selection 1
    A_v=(M*R*P_r_G*h_l_P)^2;
    B_v=6*q*M^(2+x)*R*P_r_G*h_l_P*deltaf;
    C_v=8*q*R*P_b_G*deltaf+16*k_B*T*deltaf/R_L;
    P_PG=0;
    
    for n=0:10 
        for m=0:10
            if ((n+round(beta)-1)<m)
                continue;
            else
                P_PG=P_PG+1/12*(B_v/(2*A_v)*Phi_v(alpha,beta,n,m,A_v,B_v,C_v)*Special_v(1/2,-(n+beta-1-m)/2,(n+beta+1+m)/2,A_v,B_v,C_v)...
                      +B_v/(2*A_v)*Phi_v(beta,alpha,n,m,A_v,B_v,C_v)*Special_v(1/2,-(n+alpha-1-m)/2,(n+alpha+1+m)/2,A_v,B_v,C_v)...
                      +B_v^2/(4*A_v*sqrt(A_v*C_v))*Phi_v(alpha,beta,n,m,A_v,B_v,C_v)*Special_v(1/2,-(n+beta-2-m)/2,(n+beta+2+m)/2,A_v,B_v,C_v)...
                      +B_v^2/(4*A_v*sqrt(A_v*C_v))*Phi_v(beta,alpha,n,m,A_v,B_v,C_v)*Special_v(1/2,-(n+alpha-2-m)/2,(n+alpha+2+m)/2,A_v,B_v,C_v)...
                      +C_v/sqrt(4*A_v*C_v)*Phi_v(alpha,beta,n,m,A_v,B_v,C_v)*Special_v(1/2,-(n+beta-2-m)/2,(n+beta+m)/2,A_v,B_v,C_v)...
                      +C_v/sqrt(4*A_v*C_v)*Phi_v(beta,alpha,n,m,A_v,B_v,C_v)*Special_v(1/2,-(n+alpha-2-m)/2,(n+alpha+m)/2,A_v,B_v,C_v))...
                 +1/4*(B_v/(2*A_v)*Phi_v(alpha,beta,n,m,A_v,B_v,C_v)*Special_v(2/3,-(n+beta-1-m)/2,(n+beta+1+m)/2,A_v,B_v,C_v)...
                      +B_v/(2*A_v)*Phi_v(beta,alpha,n,m,A_v,B_v,C_v)*Special_v(2/3,-(n+alpha-1-m)/2,(n+alpha+1+m)/2,A_v,B_v,C_v)...
                      +B_v^2/(4*A_v*sqrt(A_v*C_v))*Phi_v(alpha,beta,n,m,A_v,B_v,C_v)*Special_v(2/3,-(n+beta-2-m)/2,(n+beta+m)/2,A_v,B_v,C_v)...
                      +B_v^2/(4*A_v*sqrt(A_v*C_v))*Phi_v(beta,alpha,n,m,A_v,B_v,C_v)*Special_v(2/3,-(n+alpha-2-m)/2,(n+alpha+2+m)/2,A_v,B_v,C_v)...
                      +C_v/sqrt(4*A_v*C_v)*Phi_v(alpha,beta,n,m,A_v,B_v,C_v)*Special_v(2/3,-(n+beta-2-m)/2,(n+beta+m)/2,A_v,B_v,C_v)...
                      +C_v/sqrt(4*A_v*C_v)*Phi_v(beta,alpha,n,m,A_v,B_v,C_v)*Special_v(2/3,-(n+alpha-2-m)/2,(n+alpha+m)/2,A_v,B_v,C_v));   
            end
        end
    end
end