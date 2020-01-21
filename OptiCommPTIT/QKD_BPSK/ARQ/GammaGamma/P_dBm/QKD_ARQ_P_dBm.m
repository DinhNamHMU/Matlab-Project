%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
global C2n_Weak;
global C2n_Strong;

C2n_Weak=7*10^-15;     %Refractive index structure coefficient
C2n_Strong=10^-13;

MArray=[1,2,3,4,5];    %Maximum number of transmissions
B=10;                  %BS buffer size
P_dBm=-3:0.2:3;         %Peak transmitted power(dBm)

%Calculate Key loss rate via Gamma-Gamma Channels
%Weak turbulences
QBER_Gamma_Weak=zeros(1,length(P_dBm));
P_sift_Gamma_Weak=zeros(1,length(P_dBm));

keyLossRate_Gamma_Weak1=zeros(1,length(P_dBm));
keyLossRate_Gamma_Weak2=zeros(1,length(P_dBm));
keyLossRate_Gamma_Weak3=zeros(1,length(P_dBm));
keyLossRate_Gamma_Weak4=zeros(1,length(P_dBm));
keyLossRate_Gamma_Weak5=zeros(1,length(P_dBm));

for i=1:length(P_dBm) 
    [QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i)]=calculateQBER(P_dBm(i),C2n_Weak);
    
    [keyLossRate_Gamma_Weak1(i)]=calculateKeyLossRate(MArray(1),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    
    [keyLossRate_Gamma_Weak2(i)]=calculateKeyLossRate(MArray(2),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    
    [keyLossRate_Gamma_Weak3(i)]=calculateKeyLossRate(MArray(3),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    
    [keyLossRate_Gamma_Weak4(i)]=calculateKeyLossRate(MArray(4),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
   
    [keyLossRate_Gamma_Weak5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
end

%Strong turbulences
QBER_Gamma_Strong=zeros(1,length(P_dBm));
P_sift_Gamma_Strong=zeros(1,length(P_dBm));

keyLossRate_Gamma_Strong1=zeros(1,length(P_dBm));
keyLossRate_Gamma_Strong2=zeros(1,length(P_dBm));
keyLossRate_Gamma_Strong3=zeros(1,length(P_dBm));
keyLossRate_Gamma_Strong4=zeros(1,length(P_dBm));
keyLossRate_Gamma_Strong5=zeros(1,length(P_dBm));

for i=1:length(P_dBm) 
    [QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i)]=calculateQBER(P_dBm(i),C2n_Strong);
    
    [keyLossRate_Gamma_Strong1(i)]=calculateKeyLossRate(MArray(1),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    
    [keyLossRate_Gamma_Strong2(i)]=calculateKeyLossRate(MArray(2),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    
    [keyLossRate_Gamma_Strong3(i)]=calculateKeyLossRate(MArray(3),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    
    [keyLossRate_Gamma_Strong4(i)]=calculateKeyLossRate(MArray(4),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
   
    [keyLossRate_Gamma_Strong5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
end

%Plot function of the key loss rate via Gamma-Gamma Channels
%Weak turbulence
figure(1)
subplot(1,2,1);
semilogy(P_dBm,keyLossRate_Gamma_Weak1,'b-',P_dBm,keyLossRate_Gamma_Weak2,'r--',P_dBm,keyLossRate_Gamma_Weak3,'k:',P_dBm,keyLossRate_Gamma_Weak4,'g+-',P_dBm,keyLossRate_Gamma_Weak5,'m-.','LineWidth',1);
grid on
xlabel('Peak transmitted power, P (dBm)');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
title('(a) Weak turbulence C^2_{n}=7x10^{-15} (m^{-2/3})');
axis([-3,3,1.e-4,1.e-0]);

%Strong turbulence
subplot(1,2,2);
semilogy(P_dBm,keyLossRate_Gamma_Strong1,'b-',P_dBm,keyLossRate_Gamma_Strong2,'r--',P_dBm,keyLossRate_Gamma_Strong3,'k:',P_dBm,keyLossRate_Gamma_Strong4,'g+-',P_dBm,keyLossRate_Gamma_Strong5,'m-.','LineWidth',1);
grid on
xlabel('Peak transmitted power, P (dBm)');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
title('(b) Strong turbulence C^2_{n}=10^{-13} (m^{-2/3})');
axis([-3,3,1.e-4,1.e-0]);