%Final Key-Creation Rate(Rf) versus peak transmitted power(P) in dBm.
clear;
clc;

%Simulation Parameters
global Rb     %Bit rate
global C2n_1; %Refractive index structure coefficient
global C2n_2; 

Rb=10^9;  
C2n_1=5*10^-14;
C2n_2=10^-13;

P_dBm=-12:0.1:2;

%Calculate Key-Creation Rate(Rf)
Rf_Log_Mbps=zeros(1,length(P_dBm));
Rf_Gamma1_Mbps=zeros(1,length(P_dBm));
Rf_Gamma2_Mbps=zeros(1,length(P_dBm));

for i=1:length(P_dBm)
    [Rf_Log_Mbps(i),Rf_Gamma1_Mbps(i),Rf_Gamma2_Mbps(i)]=calculateFinalKeyCreationRate(P_dBm(i));
end

%Plot function
figure(1)
plot(P_dBm,Rf_Log_Mbps,'r--',P_dBm,Rf_Gamma1_Mbps,'b-',P_dBm,Rf_Gamma2_Mbps,'g--');
grid on
xlabel('Peak transmitted power');
ylabel('Final key-creation rate');
title('Final key-creation rate versus peak transmitted power');
legend('C^2_{n}=10^{-15}','C^2_{n}=5x10^{-14}','C^2_{n}=10^{-13}');
axis([-12,2,0,7]);