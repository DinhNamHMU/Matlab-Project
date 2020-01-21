%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with QPSK scheme and
%Heterodyne Detection Reciver with atmospheric turbulence
clear;
clc;

%Simulator Parameters
global Rb;       %Bit rate  
global P_LO_dBm; %Power of Local Oscillator(dBm)
global lamda_wavelength;
global Omega_z_G;

Rb=10*10^9;
P_LO_dBm=0;
lamda_wavelength=1550*10^-9;
Omega_z_G=50;

C2n_Strong=7*10^-12;

P_T_dBm=[36,45,50,55];        %Peak transmitted power (dBm)
ScaleCo=1.5;       %Threshold scale coefficient
Attenuation=0:0.05:3;
 
%Calculate QBER via Gamma-Gamma Channels with weak and strong turbulence
QBER_Gamma_Strong1=zeros(1,length(Attenuation));
QBER_Gamma_Strong2=zeros(1,length(Attenuation));
QBER_Gamma_Strong3=zeros(1,length(Attenuation));
QBER_Gamma_Strong4=zeros(1,length(Attenuation));

for i=1:length(Attenuation)
    QBER_Gamma_Strong1(i)=calculateQBER_QPSK_Gamma(ScaleCo,P_T_dBm(1),C2n_Strong,Attenuation(i));
    QBER_Gamma_Strong2(i)=calculateQBER_QPSK_Gamma(ScaleCo,P_T_dBm(2),C2n_Strong,Attenuation(i));
    QBER_Gamma_Strong3(i)=calculateQBER_QPSK_Gamma(ScaleCo,P_T_dBm(3),C2n_Strong,Attenuation(i));
    QBER_Gamma_Strong4(i)=calculateQBER_QPSK_Gamma(ScaleCo,P_T_dBm(4),C2n_Strong,Attenuation(i));
end

%Plot funciton of Gamma-Gamma channels with weak and strong turbulence
figure(1)
semilogy(Attenuation,QBER_Gamma_Strong1,'-o','color',[1,0,0],'LineWidth',1.25);
grid on
hold on
semilogy(Attenuation,QBER_Gamma_Strong2,'-s','color',[0,0.5,0],'LineWidth',1.25);
semilogy(Attenuation,QBER_Gamma_Strong3,'m-*','LineWidth',1.25);
semilogy(Attenuation,QBER_Gamma_Strong4,'-','color',[0,0,1],'LineWidth',1.25);
xlabel('Attenuation coefficient, \sigma (dB/km)');
ylabel('QBER');
legend(['P_T = ',num2str(P_T_dBm(1)),' dBm'],['P_T = ',num2str(P_T_dBm(2)),' dBm'],['P_T = ',num2str(P_T_dBm(3)),' dBm'],['P_T = ',num2str(P_T_dBm(4)),' dBm'],'Location','southeast');
axis([0,3,1.e-6,1.e-0]);