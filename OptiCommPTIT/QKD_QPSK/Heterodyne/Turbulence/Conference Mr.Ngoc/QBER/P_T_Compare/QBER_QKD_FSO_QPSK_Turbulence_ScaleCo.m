%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with QPSK scheme and
%Heterodyne Detection Reciver with atmospheric turbulence
clear;
clc;

%Simulator Parameters
global Rb;       %Bit rate  
global P_LO_dBm; %Power of Local Oscillator(dBm)
global alpha1;   %Attenuatation coefficient(dB/km)
global lamda_wavelength;

Rb=10*10^9;
P_LO_dBm=0;
alpha1=0.43;
lamda_wavelength=1550*10^-9;

C2n_Weak=5*10^-15; %Refractive index structure coefficient
ScaleCo_Weak=0.2;

P_T_dBm=10:1:50;      
 
%Calculate QBER via Gamma-Gamma Channels with weak and strong turbulence
QBER_Gamma_Weak=zeros(1,length(P_T_dBm));
P_sift_Gamma_Weak=zeros(1,length(P_T_dBm));
QBER_SIM=zeros(1,length(P_T_dBm));
P_sift_SIM=zeros(1,length(P_T_dBm));
QBER_Direct=zeros(1,length(P_T_dBm));
P_sift_Direct=zeros(1,length(P_T_dBm));

for i=1:length(P_T_dBm)
    [QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Weak,P_T_dBm(i),C2n_Weak);
    [QBER_SIM(i),P_sift_SIM(i)]=calculateQBER_BPSK_Gamma(ScaleCo_Weak,P_T_dBm(i),C2n_Weak);
    [QBER_Direct(i),P_sift_Direct(i)]=calculateQBER_QPSK_DD(ScaleCo_Weak,P_T_dBm(i),C2n_Weak);
end

%Plot funciton of Gamma-Gamma channels with weak and strong turbulence
figure(1)
semilogy(P_T_dBm,QBER_Gamma_Weak,'-*','color',[1, 0, 0],'LineWidth',1.25);
grid on
hold on
semilogy(P_T_dBm,P_sift_Gamma_Weak,'-s','color',[1, 0, 0],'LineWidth',1.25);
semilogy(P_T_dBm,QBER_SIM,'-+','color',[0, 0, 1],'LineWidth',1.25);
semilogy(P_T_dBm,P_sift_SIM,'-o','color',[0, 0, 1],'LineWidth',1.25);
semilogy(P_T_dBm,QBER_Direct,'-x','color',[0, 0.5, 0],'LineWidth',1.25);
semilogy(P_T_dBm,P_sift_Direct,'-d','color',[0, 0.5, 0],'LineWidth',1.25);
xlabel('Peak transmitted power, P_{T} (dBm)');
ylabel('Probability');
hold off
legend('QBER - QPSK/Heterodyne','P_{sift} - QPSK/Heterodyne','QBER - SIM/BPSK','P_{sift} - SIM/BPSK','QBER - Direct Detection','P_{sift} - Direct Detection','Location','southwest');
axis([10,50,1.e-4,1.e-0]);