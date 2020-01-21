%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with BPSK scheme
clear;
clc;

%Simulation Parameters
global Rb;         %Bit rate  

C2n_Strong=10^-13;
Rb=10^9;

ScaleCo_Strong=1.9;
Attenuation=0:0.05:3;

%Calculate QBER via Gamma-Gamma Channels with strong turbulence
QBER_Gamma_Strong=zeros(1,length(Attenuation));
P_sift_Gamma_Strong=zeros(1,length(Attenuation));

for i=1:length(Attenuation)
    [QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i)]=calculateQBERC2n(ScaleCo_Strong,C2n_Strong,Attenuation(i));
end

%Plot funciton of Gamma-Gamma channels with strong turbulence
figure(1)
semilogy(Attenuation,QBER_Gamma_Strong,'b--','LineWidth',1);
grid on
xlabel('Attenuation');
ylabel('Probability');
legend('QBER');
axis([0,3,1.e-6,1.e-0]);
