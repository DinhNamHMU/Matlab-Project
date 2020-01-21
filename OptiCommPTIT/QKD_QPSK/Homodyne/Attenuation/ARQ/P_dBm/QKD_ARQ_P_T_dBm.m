%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
MArray=[1,2,3,4,5];    %Maximum number of transmissions
B=10;                  %BS buffer size
P_dBm=-5.5:0.01:-4;       %Peak transmitted power(dBm)
global P_LO_dBm;       %Power of Local Oscillator(dBm)
P_LO_dBm=0;

%Calculate Key loss rate
QBER=zeros(1,length(P_dBm));
P_sift=zeros(1,length(P_dBm));

keyLossRate1=zeros(1,length(P_dBm));
keyLossRate2=zeros(1,length(P_dBm));
keyLossRate3=zeros(1,length(P_dBm));
keyLossRate4=zeros(1,length(P_dBm));
keyLossRate5=zeros(1,length(P_dBm));

for i=1:length(P_dBm) 
    [QBER(i),P_sift(i)]=calculateQBER_QPSK(P_dBm(i));
    
    keyLossRate1(i)=calculateKeyLossRate(MArray(1),B,QBER(i),P_sift(i));
    keyLossRate2(i)=calculateKeyLossRate(MArray(2),B,QBER(i),P_sift(i));
    keyLossRate3(i)=calculateKeyLossRate(MArray(3),B,QBER(i),P_sift(i));  
    keyLossRate4(i)=calculateKeyLossRate(MArray(4),B,QBER(i),P_sift(i));
    keyLossRate5(i)=calculateKeyLossRate(MArray(5),B,QBER(i),P_sift(i));
end

%Plot function of the key loss rate
figure(1)
semilogy(P_dBm,keyLossRate1,'b-',P_dBm,keyLossRate2,'r--',P_dBm,keyLossRate3,'k:',P_dBm,keyLossRate4,'g+-',P_dBm,keyLossRate5,'m-.','LineWidth',1);
grid on
xlabel('Peak transmitted power, P_{T} (dBm)');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
axis([-5.5,-4,1.e-4,1.e-0]);