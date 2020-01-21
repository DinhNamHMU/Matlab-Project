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
global l_k;              %Length of bit string(in bits)
global H_a;              %Amospheric altitude (m)

P_LO_dBm=0;
Rb=10*10^9;
lamda_wavelength=1550*10^-9;
v_wind=21;
lamda=185;
H_S=600*10^3;
H_G=5;   
H_a=20*10^3;
l_k=0.9*10^7;                   

MArray=[1,2,3,4,5]; %Maximum number of transmissions
B=10;               %BS buffer size
P_T_dBm=24:0.09:30;

%Calculate Key loss rate
QBER=zeros(1,length(P_T_dBm));
P_sift=zeros(1,length(P_T_dBm));

keyLossRate1=zeros(1,length(P_T_dBm));
keyLossRate2=zeros(1,length(P_T_dBm));
keyLossRate3=zeros(1,length(P_T_dBm));
keyLossRate4=zeros(1,length(P_T_dBm));
keyLossRate5=zeros(1,length(P_T_dBm));

for i=1:length(P_T_dBm) 
    [QBER(i),P_sift(i)]=calculateQBER_QPSK(P_T_dBm(i));
    
    keyLossRate1(i)=calculateKeyLossRate(MArray(1),B,QBER(i),P_sift(i));
    keyLossRate2(i)=calculateKeyLossRate(MArray(2),B,QBER(i),P_sift(i));
    keyLossRate3(i)=calculateKeyLossRate(MArray(3),B,QBER(i),P_sift(i));  
    keyLossRate4(i)=calculateKeyLossRate(MArray(4),B,QBER(i),P_sift(i));
    keyLossRate5(i)=calculateKeyLossRate(MArray(5),B,QBER(i),P_sift(i));
end

%Plot function of the key loss rate
figure(1)
semilogy(P_T_dBm,keyLossRate1,'b-',P_T_dBm,keyLossRate2,'r--',P_T_dBm,keyLossRate3,'k:',P_T_dBm,keyLossRate4,'g+-',P_T_dBm,keyLossRate5,'m-*','LineWidth',1.5);
grid on
xlabel('Peak transmitted power, P_{T}');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
axis([24,30,1.e-6,1.e-0]);