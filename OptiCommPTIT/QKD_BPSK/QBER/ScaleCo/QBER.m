%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with BPSK scheme
clear;
clc;

%Simulation Parameters
global C2n_Weak;   %Refractive index structure coefficient
global C2n_Strong;
global Rb;         %Bit rate   
global betal1;     %Attenuatation coefficient(dB/km)

C2n_Weak=7*10^-15; 
C2n_Strong=10^-13;
Rb=10^9;
betal1=0.43;

ScaleCo=0:0.2:5;

%Calculate QBER via Log-Normal Channels and Gamma-Gamma Channels
QBER_Log=zeros(1,length(ScaleCo));
P_sift_Log=zeros(1,length(ScaleCo));
QBER_Gamma=zeros(1,length(ScaleCo));
P_sift_Gamma=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo)
    [QBER_Log(i),P_sift_Log(i),QBER_Gamma(i),P_sift_Gamma(i)]=calculateQBER(ScaleCo(i));
end

%Calculate QBER via Gamma-Gamma Channels with weak and strong turbulence
QBER_Gamma_Weak=zeros(1,length(ScaleCo));
P_sift_Gamma_Weak=zeros(1,length(ScaleCo));
QBER_Gamma_Strong=zeros(1,length(ScaleCo));
P_sift_Gamma_Strong=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo)
    [QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i)]=calculateQBERC2n(ScaleCo(i),C2n_Weak);
end

for i=1:length(ScaleCo)
    [QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i)]=calculateQBERC2n(ScaleCo(i),C2n_Strong);
end

%Plot function of Log-Normal channels
figure(1)
subplot(1,2,1)
semilogy(ScaleCo,QBER_Log,'r-',ScaleCo,P_sift_Log,'b--','LineWidth',1);
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Probability');
title('Log-Normal Channels');
legend('QBER','Psift');
axis([0,4,1.e-4,1.e-0]);

%Plot function of Gamma-Gamma channels
subplot(1,2,2)
semilogy(ScaleCo,QBER_Gamma,'r-',ScaleCo,P_sift_Gamma,'b--','LineWidth',1);
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Probability');
title('Gamma-Gamma Channels');
legend('QBER','Psift');
axis([0,5,1.e-4,1.e-0]);

%Plot funciton of Gamma-Gamma channels with weak and strong turbulence
figure(2)
subplot(1,2,1)
semilogy(ScaleCo,QBER_Gamma_Weak,'r-',ScaleCo,P_sift_Gamma_Weak,'b--','LineWidth',1);
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Probability');
title('Weak turbulence C^2_{n}=7x10^{-15} (m^{-2/3})');
legend('QBER','Psift');
axis([0,5,1.e-4,1.e-0]);

subplot(1,2,2)
semilogy(ScaleCo,QBER_Gamma_Strong,'r-',ScaleCo,P_sift_Gamma_Strong,'b--','LineWidth',1);
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Probability');
title('Strong turbulence C^2_{n}=10^{-13} (m^{-2/3})');
legend('QBER','Psift');
axis([0,5,1.e-4,1.e-0]);
