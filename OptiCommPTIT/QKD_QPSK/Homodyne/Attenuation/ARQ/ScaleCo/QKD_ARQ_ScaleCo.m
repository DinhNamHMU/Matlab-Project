%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
MArray=[1,2,3,4,5];    %Maximum number of transmissions
B=10;                  %BS buffer size
ScaleCo=0.3:0.01:1;
global P_LO_dBm;               %Power of Local Oscillator(dBm)
P_LO_dBm=0;
%Calculate Key loss rate
QBER=zeros(1,length(ScaleCo));
P_sift=zeros(1,length(ScaleCo));

keyLossRate1=zeros(1,length(ScaleCo));
keyLossRate2=zeros(1,length(ScaleCo));
keyLossRate3=zeros(1,length(ScaleCo));
keyLossRate4=zeros(1,length(ScaleCo));
keyLossRate5=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER(i),P_sift(i)]=calculateQBER_QPSK(ScaleCo(i));
    
    keyLossRate1(i)=calculateKeyLossRate(MArray(1),B,QBER(i),P_sift(i));
    keyLossRate2(i)=calculateKeyLossRate(MArray(2),B,QBER(i),P_sift(i));
    keyLossRate3(i)=calculateKeyLossRate(MArray(3),B,QBER(i),P_sift(i));  
    keyLossRate4(i)=calculateKeyLossRate(MArray(4),B,QBER(i),P_sift(i));
    keyLossRate5(i)=calculateKeyLossRate(MArray(5),B,QBER(i),P_sift(i));
end

%Plot function of the key loss rate
figure(1)
semilogy(ScaleCo,keyLossRate1,'b-',ScaleCo,keyLossRate2,'r--',ScaleCo,keyLossRate3,'k:',ScaleCo,keyLossRate4,'g+-',ScaleCo,keyLossRate5,'m-.','LineWidth',1);
grid on
xlabel('D-T scale coefficient, \rho');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
axis([0.3,1,1.e-4,1.e-0]);