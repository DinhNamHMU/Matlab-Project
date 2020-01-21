%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
global Rb;               %Bit rate (bps)
global P_LO_dBm;         %Power of Local Oscillator (dBm)
global lamda_wavelength; %Wavelength (m)
global v_wind;           %Wind speed (m/s)
global lamda;            %Flow throughput(key per second)
global H_S;              %Satellite altitude (m)
global H_G;              %Ground station height (m)
global H_a;              %Amospheric altitude (m)
global l_k;              %Length of bit string(in bits)
global Omega_z_G;
global zenithAng_Do      %Zenith angle(degree)

Rb=10*10^9;
P_LO_dBm=0;
lamda_wavelength=1550*10^-9;
v_wind=21;
lamda=60;
H_S=600*10^3;
H_G=5;   
H_a=20*10^3;
l_k=5*10^7; 
Omega_z_G=50;
zenithAng_Do=50; 

C2n_Strong=7*10^-12; %Refractive index structure coefficient
ScaleCo_Strong=1.4;

P_T_dBm=46;                     
MArray=[1,2,3,4,5];  %Maximum number of transmissions
B=10;                %BS buffer size
Attenuation=0:5:80;

%Calculate Key loss rate
%Strong turbulence
QBER_Strong=zeros(1,length(Attenuation));
P_sift_Strong=zeros(1,length(Attenuation));

keyLossRate1_Strong=zeros(1,length(Attenuation));
keyLossRate2_Strong=zeros(1,length(Attenuation));
keyLossRate3_Strong=zeros(1,length(Attenuation));
keyLossRate4_Strong=zeros(1,length(Attenuation));
keyLossRate5_Strong=zeros(1,length(Attenuation));

LinkUltilization1_Strong=zeros(1,length(P_T_dBm));
LinkUltilization2_Strong=zeros(1,length(P_T_dBm));
LinkUltilization3_Strong=zeros(1,length(P_T_dBm));
LinkUltilization4_Strong=zeros(1,length(P_T_dBm));
LinkUltilization5_Strong=zeros(1,length(P_T_dBm));

for i=1:length(Attenuation) 
    [QBER_Strong(i),P_sift_Strong(i)]=calculateQBER_QPSK_Gamma(Attenuation(i),ScaleCo_Strong,P_T_dBm,C2n_Strong);
    
    %Key loss rate
    keyLossRate1_Strong(i)=calculateKeyLossRate(MArray(1),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate2_Strong(i)=calculateKeyLossRate(MArray(2),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate3_Strong(i)=calculateKeyLossRate(MArray(3),B,QBER_Strong(i),P_sift_Strong(i));  
    keyLossRate4_Strong(i)=calculateKeyLossRate(MArray(4),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate5_Strong(i)=calculateKeyLossRate(MArray(5),B,QBER_Strong(i),P_sift_Strong(i));
    
    %Link Ultilization
    LinkUltilization1_Strong(i)=lamda*(1-keyLossRate1_Strong(i))/(Rb/l_k);
    LinkUltilization2_Strong(i)=lamda*(1-keyLossRate2_Strong(i))/(Rb/l_k);
    LinkUltilization3_Strong(i)=lamda*(1-keyLossRate3_Strong(i))/(Rb/l_k);
    LinkUltilization4_Strong(i)=lamda*(1-keyLossRate4_Strong(i))/(Rb/l_k);
    LinkUltilization5_Strong(i)=lamda*(1-keyLossRate5_Strong(i))/(Rb/l_k);
end

%Plot function of the key loss rate
%Strong turbulence
figure(1)
plot(Attenuation,keyLossRate1_Strong,'b-',Attenuation,keyLossRate2_Strong,'r--',...
         Attenuation,keyLossRate3_Strong,'kd-',Attenuation,keyLossRate4_Strong,'g+-',Attenuation,keyLossRate5_Strong,'m-*','LineWidth',1.5);
grid on
xlabel('Attenuation coefficient, \sigma (dB/km)');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4','Location','southeast');
% axis([4,59,0,1]);

%Plot function of the link utilization
%Strong turbulence
figure(2)
plot(Attenuation,LinkUltilization1_Strong,'b-',Attenuation,LinkUltilization2_Strong,'r--',...
         Attenuation,LinkUltilization3_Strong,'kd-',Attenuation,LinkUltilization4_Strong,'g+-',Attenuation,LinkUltilization5_Strong,'m-*','LineWidth',1.5);
grid on
xlabel('Attenuation coefficient, \sigma (dB/km)');
ylabel('Link utilization, U');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4','Location','southeast');
% axis([4,59,0,1]);