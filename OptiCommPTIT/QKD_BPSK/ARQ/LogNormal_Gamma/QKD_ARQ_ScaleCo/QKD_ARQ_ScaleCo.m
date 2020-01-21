%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
MArray=[1,2,3,4,5]; %Maximum number of transmissions
B=10;               %BS buffer size
ScaleCo=0:0.1:4;

%Calculate QBER and Key loss rate via Log-Normal Channels and Gamma-Gamma Channels
QBER_Log=zeros(1,length(ScaleCo));
QBER_Gamma=zeros(1,length(ScaleCo));
P_sift_Log=zeros(1,length(ScaleCo));
P_sift_Gamma=zeros(1,length(ScaleCo));

keyLossRate_Log1=zeros(1,length(ScaleCo));
keyLossRate_Gamma1=zeros(1,length(ScaleCo));
keyLossRate_Log2=zeros(1,length(ScaleCo));
keyLossRate_Gamma2=zeros(1,length(ScaleCo));
keyLossRate_Log3=zeros(1,length(ScaleCo));
keyLossRate_Gamma3=zeros(1,length(ScaleCo));
keyLossRate_Log4=zeros(1,length(ScaleCo));
keyLossRate_Gamma4=zeros(1,length(ScaleCo));
keyLossRate_Log5=zeros(1,length(ScaleCo));
keyLossRate_Gamma5=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER_Log(i),P_sift_Log(i),QBER_Gamma(i),P_sift_Gamma(i)]=calculateQBER(ScaleCo(i));
    
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
semilogy(ScaleCo,keyLossRate_Log1,'b-',ScaleCo,keyLossRate_Log2,'r--',ScaleCo,keyLossRate_Log3,'k:',ScaleCo,keyLossRate_Log4,'g+-',ScaleCo,keyLossRate_Log5,'m-.');
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Key loss rate');
legend(['M=',num2str(MArray(1)),' analysis'],['M=',num2str(MArray(2)),' analysis'],['M=',num2str(MArray(3)),' analysis'],['M=',num2str(MArray(4)),' analysis'],['M=',num2str(MArray(5)),' analysis']);
title('Key loss rate via Log-Normal channels');
axis([0,4,1.e-4,1.e-0]);

%Plot function of the key loss rate via Gamma-Gamma Channels
subplot(1,2,2);
semilogy(ScaleCo,keyLossRate_Gamma1,'b-',ScaleCo,keyLossRate_Gamma2,'r--',ScaleCo,keyLossRate_Gamma3,'k:',ScaleCo,keyLossRate_Gamma4,'g+-',ScaleCo,keyLossRate_Log5,'m-.');
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Key loss rate');
legend(['M=',num2str(MArray(1)),' analysis'],['M=',num2str(MArray(2)),' analysis'],['M=',num2str(MArray(3)),' analysis'],['M=',num2str(MArray(4)),' analysis'],['M=',num2str(MArray(5)),' analysis']);
title('Key loss rate via Gamma-Gamma channels');
axis([0,4,1.e-4,1.e-0]);
