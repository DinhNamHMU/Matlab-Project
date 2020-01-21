%HAP-Aided Relaying Satellite FSO/QKD Systems for Secure Vehicular
%Networks-Minh Q. Vu
clear;
clc;

%Parameters Simulation
global P_dBm;            %Peak transmitted power
global Omega_z_P; 
global Omega_z_G;
global ModDepth;         %Modulation depth
global Rb                %Bit rate
global G_A_dB;           %Gain of amplifier
global v_wind;           %Wind speed (m/s)
global lamda;            %Flow throughput(key per second)
global H_S;              %Satellite altitude (m)
global l_k;              %Length of bit string(in bits)
global H_P;              %HAP altitude (m)
global lamda_wavelength; %Wavelength (m)

v_wind=21;
lamda=185;
H_S=610*10^3; 
H_P=20*10^3;               
l_k=0.9*10^6;  
P_dBm=37; 
Omega_z_P=1475;
Omega_z_G=50;
ModDepth=0.4;
Rb=10^9;
G_A_dB=50;
lamda_wavelength=1550*10^-9;

MArray=[1,2,3,4,5];    %Maximum number of transmissions
B=10;                  %BS buffer size
ScaleCo=1:0.1:4;

%Calculate Key loss rate via Gamma-Gamma Channels
QBER_Gamma=zeros(1,length(ScaleCo));
P_sift_Gamma=zeros(1,length(ScaleCo));

keyLossRate_Gamma1=zeros(1,length(ScaleCo));
keyLossRate_Gamma2=zeros(1,length(ScaleCo));
keyLossRate_Gamma3=zeros(1,length(ScaleCo));
keyLossRate_Gamma4=zeros(1,length(ScaleCo));
keyLossRate_Gamma5=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER_Gamma(i),P_sift_Gamma(i)]=calculateQBER_HAP(ScaleCo(i));
    
    [keyLossRate_Gamma1(i)]=calculateKeyLossRate(MArray(1),B,QBER_Gamma(i),P_sift_Gamma(i));
    [keyLossRate_Gamma2(i)]=calculateKeyLossRate(MArray(2),B,QBER_Gamma(i),P_sift_Gamma(i));
    [keyLossRate_Gamma3(i)]=calculateKeyLossRate(MArray(3),B,QBER_Gamma(i),P_sift_Gamma(i));  
    [keyLossRate_Gamma4(i)]=calculateKeyLossRate(MArray(4),B,QBER_Gamma(i),P_sift_Gamma(i));
    [keyLossRate_Gamma5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma(i),P_sift_Gamma(i));
end

%Plot function of the key loss rate via Gamma-Gamma Channels
figure(1)
semilogy(ScaleCo,keyLossRate_Gamma1,'b-',ScaleCo,keyLossRate_Gamma2,'r--',ScaleCo,keyLossRate_Gamma3,'k:',ScaleCo,keyLossRate_Gamma4,'g+-',ScaleCo,keyLossRate_Gamma5,'m-.','LineWidth',1.5);
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Key loss rate, KLR');
legend('Conventional QKD-HAP','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
axis([1,4,1.e-4,1.e-0]);