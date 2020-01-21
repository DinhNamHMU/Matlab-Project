%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
C2n_Strong=10^-13;

MArray=[1,2,3,4,5]; %Maximum number of transmissions
B=10;               %BS buffer size
ScaleCo=1.9;

Attenuation=0:0.009:3;

%Calculate Key loss rate via Gamma-Gamma Channels
%Strong turbulence
QBER_Gamma_Strong=zeros(1,length(Attenuation));
P_sift_Gamma_Strong=zeros(1,length(Attenuation));

keyLossRate_Gamma_Strong1=zeros(1,length(Attenuation));
keyLossRate_Gamma_Strong2=zeros(1,length(Attenuation));
keyLossRate_Gamma_Strong3=zeros(1,length(Attenuation));
keyLossRate_Gamma_Strong4=zeros(1,length(Attenuation));
keyLossRate_Gamma_Strong5=zeros(1,length(Attenuation));

for i=1:length(Attenuation) 
    [QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i)]=calculateQBER(ScaleCo,C2n_Strong,Attenuation(i));
    
    [keyLossRate_Gamma_Strong1(i)]=calculateKeyLossRate(MArray(1),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong2(i)]=calculateKeyLossRate(MArray(2),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong3(i)]=calculateKeyLossRate(MArray(3),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));  
    [keyLossRate_Gamma_Strong4(i)]=calculateKeyLossRate(MArray(4),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
end

%Plot function of the key loss rate via Gamma-Gamma Channels
%Strong turbulence
figure(2)
semilogy(Attenuation,keyLossRate_Gamma_Strong1,'b-',Attenuation,keyLossRate_Gamma_Strong2,'r--',Attenuation,keyLossRate_Gamma_Strong3,'kd-',Attenuation,keyLossRate_Gamma_Strong4,'g+-',Attenuation,keyLossRate_Gamma_Strong5,'m-*','LineWidth',1.5);
grid on
xlabel('Attenuation');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
axis([0,3,1.e-6,1.e-0]);