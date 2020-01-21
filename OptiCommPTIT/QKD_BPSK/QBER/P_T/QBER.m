%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with BPSK scheme
clear;
clc;

%Simulation Parameters
global Rb;         %Bit rate   
global betal1;     %Attenuatation coefficient(dB/km)

C2n_Weak=7*10^-15; 
C2n_Strong=10^-13;
Rb=10^9;
betal1=0.43;

ScaleCo_Weak=0.2;
ScaleCo_Strong=1;
P_dBm=-10:1:10;

%Calculate QBER via Gamma-Gamma Channels with weak and strong turbulence
QBER_Gamma_Weak=zeros(1,length(P_dBm));
P_sift_Gamma_Weak=zeros(1,length(P_dBm));
QBER_Gamma_Strong=zeros(1,length(P_dBm));
P_sift_Gamma_Strong=zeros(1,length(P_dBm));

for i=1:length(P_dBm)
    [QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i)]=calculateQBERC2n(ScaleCo_Weak,P_dBm(i),C2n_Weak);
end

for i=1:length(P_dBm)
    [QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i)]=calculateQBERC2n(ScaleCo_Strong,P_dBm(i),C2n_Strong);
end

%Plot funciton of Gamma-Gamma channels with weak and strong turbulence
figure(1)
semilogy(P_dBm,QBER_Gamma_Weak,'r-',P_dBm,P_sift_Gamma_Weak,'b--','LineWidth',1);
grid on
xlabel('Peak power transmitted, P_T (dBm)');
ylabel('Probability');
legend('QBER','Psift');
axis([-10,10,1.e-4,1.e-0]);

figure(2)
semilogy(P_dBm,QBER_Gamma_Strong,'r-',P_dBm,P_sift_Gamma_Strong,'b--','LineWidth',1);
grid on
xlabel('Peak power transmitted, P_T (dBm)');
ylabel('Probability');
legend('QBER','Psift');
axis([-10,10,1.e-4,1.e-0]);

