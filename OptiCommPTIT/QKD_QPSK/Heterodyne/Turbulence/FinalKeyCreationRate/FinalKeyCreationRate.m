%Final Key-Creation Rate(Rf) versus peak transmitted power(P) in dBm.
clear;
clc;

%Simulation Parameters
global Rb                %Bit rate
global P_LO_dBm;         %Power of Local Oscillator(dBm)
global alpha1;           %Atmospheric attenuation coefficient(dB/km)
global lamda_wavelength;
global Omega_z_G;
global r_BE;

Rb=10*10^9;
P_LO_dBm=0;
alpha1=0.43;
lamda_wavelength=1550*10^-9;
Omega_z_G=50;
r_BE=41;

C2n_Weak=5*10^-14;     %Refractive index structure coefficient
C2n_Moderate=2*10^-12;
C2n_Strong=7*10^-12;

ScaleCo_Weak=0.7;
ScaleCo_Moderate=1.2;
ScaleCo_Strong=1.4;
P_T_dBm=9:0.1:40;

%Calculate Key-Creation Rate(Rf)
Rf_Mbps_Weak=zeros(1,length(P_T_dBm));
Rf_Mbps_Moderate=zeros(1,length(P_T_dBm));
Rf_Mbps_Strong=zeros(1,length(P_T_dBm));

for i=1:length(P_T_dBm)
    Rf_Mbps_Weak(i)=calculateFinalKeyCreationRate(P_T_dBm(i),ScaleCo_Weak,C2n_Weak);
    Rf_Mbps_Moderate(i)=calculateFinalKeyCreationRate(P_T_dBm(i),ScaleCo_Moderate,C2n_Moderate);
    Rf_Mbps_Strong(i)=calculateFinalKeyCreationRate(P_T_dBm(i),ScaleCo_Strong,C2n_Strong);
end

%Plot function
figure(1)
plot(P_T_dBm,Rf_Mbps_Weak,'--','color',[0, 0.4470, 0.7410],'LineWidth',1.5);
grid on
hold on
plot(P_T_dBm,Rf_Mbps_Moderate,'-.','color',[1, 0, 0],'LineWidth',1.5);
plot(P_T_dBm,Rf_Mbps_Strong,'-','color',[0, 0.5, 0],'LineWidth',1.5);
xlabel('Peak transmitted power, P_{T} (dBm)');
ylabel('Final key-creation rate, R_{f} (Mbps)');
legend('Weak turbulence','Moderate turbulence','Strong turbulence','Location','northwest');
axis([10,40,0,300]);