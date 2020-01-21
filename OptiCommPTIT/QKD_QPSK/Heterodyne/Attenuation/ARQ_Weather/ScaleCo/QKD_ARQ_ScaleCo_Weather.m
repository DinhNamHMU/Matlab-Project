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
global H_a;              %Amospheric altitude(m)
global l_k;              %Length of bit string(in bits)
global P_T_dBm;          %Transmitted power (dBm)

P_LO_dBm=0;
Rb=10*10^9;
lamda_wavelength=1550*10^-9;
v_wind=21;
lamda=185;
H_S=600*10^3;
H_G=5;   
H_a=20*10^3;
l_k=0.9*10^7;  
P_T_dBm=0;                     

MArray=[1,2,3,4,5]; %Maximum number of transmissions
B=10;               %BS buffer size
ScaleCo=0:0.09:10;

%Atmospheric attenuation coefficient(dB/km)
alphaAir=0.43;      %Clear air
alphaFog=42.2;      %Moderate fog
alphaRain=5.8;      %Moderate rain (12.5 mm/h)

%Calculate Key loss rate
%Clear air
QBER1=zeros(1,length(ScaleCo));
P_sift1=zeros(1,length(ScaleCo));

keyLossRate11=zeros(1,length(ScaleCo));
keyLossRate21=zeros(1,length(ScaleCo));
keyLossRate31=zeros(1,length(ScaleCo));
keyLossRate41=zeros(1,length(ScaleCo));
keyLossRate51=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER1(i),P_sift1(i)]=calculateQBER_QPSK(ScaleCo(i),alphaAir);
    
    keyLossRate11(i)=calculateKeyLossRate(MArray(1),B,QBER1(i),P_sift1(i));
    keyLossRate21(i)=calculateKeyLossRate(MArray(2),B,QBER1(i),P_sift1(i));
    keyLossRate31(i)=calculateKeyLossRate(MArray(3),B,QBER1(i),P_sift1(i));  
    keyLossRate41(i)=calculateKeyLossRate(MArray(4),B,QBER1(i),P_sift1(i));
    keyLossRate51(i)=calculateKeyLossRate(MArray(5),B,QBER1(i),P_sift1(i));
end

%Moderate dog
QBER2=zeros(1,length(ScaleCo));
P_sift2=zeros(1,length(ScaleCo));

keyLossRate12=zeros(1,length(ScaleCo));
keyLossRate22=zeros(1,length(ScaleCo));
keyLossRate32=zeros(1,length(ScaleCo));
keyLossRate42=zeros(1,length(ScaleCo));
keyLossRate52=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER2(i),P_sift2(i)]=calculateQBER_QPSK(ScaleCo(i),alphaFog);
    
    keyLossRate12(i)=calculateKeyLossRate(MArray(1),B,QBER2(i),P_sift2(i));
    keyLossRate22(i)=calculateKeyLossRate(MArray(2),B,QBER2(i),P_sift2(i));
    keyLossRate32(i)=calculateKeyLossRate(MArray(3),B,QBER2(i),P_sift2(i));  
    keyLossRate42(i)=calculateKeyLossRate(MArray(4),B,QBER2(i),P_sift2(i));
    keyLossRate52(i)=calculateKeyLossRate(MArray(5),B,QBER2(i),P_sift2(i));
end

%Moderate rain (12.5 mm/h)
QBER3=zeros(1,length(ScaleCo));
P_sift3=zeros(1,length(ScaleCo));

keyLossRate13=zeros(1,length(ScaleCo));
keyLossRate23=zeros(1,length(ScaleCo));
keyLossRate33=zeros(1,length(ScaleCo));
keyLossRate43=zeros(1,length(ScaleCo));
keyLossRate53=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER3(i),P_sift3(i)]=calculateQBER_QPSK(ScaleCo(i),alphaRain);
    
    keyLossRate13(i)=calculateKeyLossRate(MArray(1),B,QBER3(i),P_sift3(i));
    keyLossRate23(i)=calculateKeyLossRate(MArray(2),B,QBER3(i),P_sift3(i));
    keyLossRate33(i)=calculateKeyLossRate(MArray(3),B,QBER3(i),P_sift3(i));  
    keyLossRate43(i)=calculateKeyLossRate(MArray(4),B,QBER3(i),P_sift3(i));
    keyLossRate53(i)=calculateKeyLossRate(MArray(5),B,QBER3(i),P_sift3(i));
end

%Plot function of the key loss rate
%Clear air
figure(1)
semilogy(ScaleCo,keyLossRate11,'b-',ScaleCo,keyLossRate21,'r--',ScaleCo,keyLossRate31,'k:',ScaleCo,keyLossRate41,'g+-',ScaleCo,keyLossRate51,'m-.','LineWidth',1);
grid on
xlabel('D-T scale coefficient, \rho');
ylabel('Key loss rate, KLR');
title('Under a clear weather conditoin.');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
axis([0,4,1.e-4,1.e-0]);

%Moderate dog
figure(2)
semilogy(ScaleCo,keyLossRate12,'b-',ScaleCo,keyLossRate22,'r--',ScaleCo,keyLossRate32,'k:',ScaleCo,keyLossRate42,'g+-',ScaleCo,keyLossRate52,'m-.','LineWidth',1);
grid on
xlabel('D-T scale coefficient, \rho');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
title('Under a moderate fog condition.');
axis([0,4,1.e-4,1.e-0]);

%Moderate rain (12.5 mm/h)
figure(3)
semilogy(ScaleCo,keyLossRate13,'b-',ScaleCo,keyLossRate23,'r--',ScaleCo,keyLossRate33,'k:',ScaleCo,keyLossRate43,'g+-',ScaleCo,keyLossRate53,'m-.','LineWidth',1);
grid on
xlabel('D-T scale coefficient, \rho');
ylabel('Key loss rate, KLR');
title('Under a moderate rain conditino (12.5 mm/h).');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4');
axis([0,4,1.e-4,1.e-0]);