clear; 
clc;

%Simulation Parameter
Rb=10^9;                  % Bit rate
deltaV=2.26*10^-3*Rb;
P_dBm=0;                  %Peak transmitted power
P=(10^(P_dBm/10))*10^-3;
lamda=1550*10^-9;         %Wavelength
nguy=0.62;                %Quantum efficiency
R=(nguy*lamda*10^6)/1.24; %Detector responsivity (A/W)
q=1.6*10^-19;             %Electron charge
Pn=R*P/q;
n=[0:0.1:15];
%Calculate
sigma_PN2=0.5*sqrt((pi*deltaV*(1+4*n.^2))./(8*Pn*n.^2));

%Plot function
figure
semilogy(n,sigma_PN2);
grid on;
xlabel('Damping Coefficient');
ylabel('Power of Phase Noise');
%DampingCoArray=35 -> sigma_PN2_MIN=2.707e-5
%DampingCoArray=0.1 -> sigma_PN2_MAX=0.000138