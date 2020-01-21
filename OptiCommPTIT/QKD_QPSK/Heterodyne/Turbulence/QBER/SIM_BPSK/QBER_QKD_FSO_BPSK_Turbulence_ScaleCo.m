%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with QPSK scheme and
%Heterodyne Detection Reciver with atmospheric turbulence
clear;
clc;

%Simulator Parameters
global Rb;       %Bit rate
global alpha1;   %Attenuatation coefficient(dB/km)
global lamda_wavelength;
global Omega_z_G;
global ModDepth; %Modulaton Depth

Rb=10*10^9;
alpha1=0.43;
lamda_wavelength=1550*10^-9;
Omega_z_G=50;
ModDepth=0.4;                  

C2n_Weak=5*10^-15;     %Refractive index structure coefficient
C2n_Strong=7*10^-12;

P_T_dBm=55;            %Peak transmitted power (dBm)
ScaleCo=0:0.1:4;       %Threshold scale coefficient
 
%Calculate QBER via Gamma-Gamma Channels with weak and strong turbulence
QBER_Gamma_Weak=zeros(1,length(ScaleCo));
P_sift_Gamma_Weak=zeros(1,length(ScaleCo));
QBER_Gamma_Strong=zeros(1,length(ScaleCo));
P_sift_Gamma_Strong=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo)
    [QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i)]=calculateQBER_BPSK_Gamma(ScaleCo(i),P_T_dBm,C2n_Weak);
end

for i=1:length(ScaleCo)
    [QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i)]=calculateQBER_BPSK_Gamma(ScaleCo(i),P_T_dBm,C2n_Strong);
end

%Plot funciton of Gamma-Gamma channels with weak and strong turbulence
figure(1)
subplot(1,2,1)
semilogy(ScaleCo,QBER_Gamma_Weak,'r-o',ScaleCo,P_sift_Gamma_Weak,'b-s','LineWidth',1.25);
grid on
xlabel('D-T scale coefficient, \varsigma');
ylabel('Probability');
legend('QBER','Psift');
axis([0,4,1.e-4,1.e-0]);

subplot(1,2,2)
semilogy(ScaleCo,QBER_Gamma_Strong,'r-o',ScaleCo,P_sift_Gamma_Strong,'b-s','LineWidth',1.25);
grid on
xlabel('D-T scale coefficient, \varsigma');
ylabel('Probability');
legend('QBER','Psift');
axis([0,4,1.e-4,1.e-0]);