%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with QPSK scheme and
%Heterodyne Detection Reciver with atmospheric turbulence
clear;
clc;

%Simulator Parameters
global Rb;       %Bit rate
global lamda_wavelength;
global Omega_z_G;
global ModDepth; %Modulaton Depth

Rb=10*10^9;
lamda_wavelength=1550*10^-9;
Omega_z_G=50;
ModDepth=0.4;                  

C2n_Weak=5*10^-15;     %Refractive index structure coefficient
C2n_Strong=7*10^-12;

ScaleCo_Weak=0.7;
ScaleCo_Strong=1.5;

P_T_dBm=55;            %Peak transmitted power (dBm)
Attenuation=0:0.05:3;

%Calculate QBER via Gamma-Gamma Channels with weak and strong turbulence
QBER_Gamma_Weak=zeros(1,length(Attenuation));
P_sift_Gamma_Weak=zeros(1,length(Attenuation));
QBER_Gamma_Strong=zeros(1,length(Attenuation));
P_sift_Gamma_Strong=zeros(1,length(Attenuation));

for i=1:length(Attenuation)
    [QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i)]=calculateQBER_BPSK_Gamma(ScaleCo_Weak,P_T_dBm,C2n_Weak,Attenuation(i));
end

for i=1:length(Attenuation)
    [QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i)]=calculateQBER_BPSK_Gamma(C2n_Strong,P_T_dBm,C2n_Strong,Attenuation(i));
end

%Plot funciton of Gamma-Gamma channels with weak and strong turbulence
figure(1)
semilogy(Attenuation,QBER_Gamma_Weak,'r-o',Attenuation,P_sift_Gamma_Weak,'b-s','LineWidth',1.25);
grid on
xlabel('D-T scale coefficient, \varsigma');
ylabel('Probability');
legend('QBER','Psift');
axis([0,3,1.e-4,1.e-0]);

figure(2)
semilogy(Attenuation,QBER_Gamma_Strong,'r-o',Attenuation,P_sift_Gamma_Strong,'b-s','LineWidth',1.25);
grid on
xlabel('D-T scale coefficient, \varsigma');
ylabel('Probability');
legend('QBER','Psift');
axis([0,3,1.e-4,1.e-0]);