%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
MArray=[1,2,3,4,5]; %Maximum number of transmissions
B=10;               %BS buffer size
P_dBm=-10:2:2;      %Peak transmitted power(dBm)

%Calculate QBER and Key loss rate via Log-Normal Channels and Gamma-Gamma Channels
QBER_Log=zeros(1,length(P_dBm));
QBER_Gamma=zeros(1,length(P_dBm));
P_sift_Log=zeros(1,length(P_dBm));
P_sift_Gamma=zeros(1,length(P_dBm));

keyLossRate_Log1=zeros(1,length(P_dBm));
keyLossRate_Gamma1=zeros(1,length(P_dBm));
keyLossRate_Log2=zeros(1,length(P_dBm));
keyLossRate_Gamma2=zeros(1,length(P_dBm));
keyLossRate_Log3=zeros(1,length(P_dBm));
keyLossRate_Gamma3=zeros(1,length(P_dBm));
keyLossRate_Log4=zeros(1,length(P_dBm));
keyLossRate_Gamma4=zeros(1,length(P_dBm));
keyLossRate_Log5=zeros(1,length(P_dBm));
keyLossRate_Gamma5=zeros(1,length(P_dBm));

for i=1:length(P_dBm) 
    [QBER_Log(i),P_sift_Log(i),QBER_Gamma(i),P_sift_Gamma(i)]=calculateQBER(P_dBm(i));
    
    [keyLossRate_Log1(i)]=calculateKeyLossRate(MArray(1),B,QBER_Log(i),P_sift_Log(i));
    [keyLossRate_Gamma1(i)]=calculateKeyLossRate(MArray(1),B,QBER_Gamma(i),P_sift_Gamma(i));
    
    [keyLossRate_Log2(i)]=calculateKeyLossRate(MArray(2),B,QBER_Log(i),P_sift_Log(i));
    [keyLossRate_Gamma2(i)]=calculateKeyLossRate(MArray(2),B,QBER_Gamma(i),P_sift_Gamma(i));
    
    [keyLossRate_Log3(i)]=calculateKeyLossRate(MArray(3),B,QBER_Log(i),P_sift_Log(i));
    [keyLossRate_Gamma3(i)]=calculateKeyLossRate(MArray(3),B,QBER_Gamma(i),P_sift_Gamma(i));
    
    [keyLossRate_Log4(i)]=calculateKeyLossRate(MArray(4),B,QBER_Log(i),P_sift_Log(i));
    [keyLossRate_Gamma4(i)]=calculateKeyLossRate(MArray(4),B,QBER_Gamma(i),P_sift_Gamma(i));
    
    [keyLossRate_Log5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Log(i),P_sift_Log(i));
    [keyLossRate_Gamma5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma(i),P_sift_Gamma(i));
end

%Plot function of the key loss rate via Log-Normal Channels
figure(1)
subplot(1,2,1);
grid on
semilogy(P_dBm,keyLossRate_Log1,'b-',P_dBm,keyLossRate_Log2,'r--',P_dBm,keyLossRate_Log3,'k:',P_dBm,keyLossRate_Log4,'g+-',P_dBm,keyLossRate_Log5,'m-.');
xlabel('Peak transmitted power, P (dBm)');
ylabel('Key loss rate');
legend(['M=',num2str(MArray(1)),' analysis'],['M=',num2str(MArray(2)),' analysis'],['M=',num2str(MArray(3)),' analysis'],['M=',num2str(MArray(4)),' analysis'],['M=',num2str(MArray(5)),' analysis']);
title('Key loss rate via Log-Normal channels');
axis([-10,2,1.e-2,1.e-0]);

%Plot function of the key loss rate via Gamma-Gamma Channels
subplot(1,2,2);
grid on
semilogy(P_dBm,keyLossRate_Gamma1,'b-',P_dBm,keyLossRate_Gamma2,'r--',P_dBm,keyLossRate_Gamma3,'k:',P_dBm,keyLossRate_Gamma4,'g+-',P_dBm,keyLossRate_Log5,'m-.');
xlabel('Peak transmitted power, P (dBm)');
ylabel('Key loss rate');
legend(['M=',num2str(MArray(1)),' analysis'],['M=',num2str(MArray(2)),' analysis'],['M=',num2str(MArray(3)),' analysis'],['M=',num2str(MArray(4)),' analysis'],['M=',num2str(MArray(5)),' analysis']);
title('Key loss rate via Gamma-Gamma channels');
axis([-10,2,1.e-2,1.e-0]);
