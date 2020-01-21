%Final Key-Creation Rate(Rf) versus peak transmitted power(P) in dBm.
clear;
clc;

%Simulation Parameters
global Rb        %Bit rate
global P_LO_dBm; %Power of Local Oscillator(dBm)
global ScaleCo;

Rb=10*10^9;
P_LO_dBm=-3;
ScaleCo=1.25;
P_T_dBm=-30:0.01:-11;

%Calculate Key-Creation Rate(Rf)
Rf_Mbps=zeros(1,length(P_T_dBm));

for i=1:length(P_T_dBm)
    Rf_Mbps(i)=calculateFinalKeyCreationRate_QPSK(P_T_dBm(i));
end

%Plot function
figure(1)
plot(P_T_dBm,Rf_Mbps,'b--','LineWidth',1);
grid on
xlabel('Transmitted power, P_{T}(dBm)');
ylabel('Final key-creation rate, R_{f} (Mbps)');
% title('Final key-creation rate versus peak transmitted power');
axis([-30,-11,0,175]);