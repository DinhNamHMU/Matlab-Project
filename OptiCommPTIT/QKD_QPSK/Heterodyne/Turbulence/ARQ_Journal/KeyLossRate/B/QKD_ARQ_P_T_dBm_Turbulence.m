%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
global Rb;               %Bit rate (bps)
global P_LO_dBm;         %Power of Local Oscillator (dBm)
global lamda_wavelength; %Wavelength (m)
global v_wind;           %Wind speed (m/s)
global lamda;            %Flow throughput (key per second)
global H_S;              %Satellite altitude (m)
global H_G;              %Ground station height (m)
global H_a;              %Amospheric altitude (m)
global l_k;              %Length of bit string (in bits)
global alpha1;           %Attenuatation coefficient (dB/km)
global Omega_z_G;
global zenithAng_Do      %Zenith angle (degree)

Rb=10*10^9;
P_LO_dBm=0;
lamda_wavelength=1550*10^-9;
v_wind=21;
lamda=60;
H_S=600*10^3;
H_G=5;   
H_a=20*10^3;
l_k=5*10^7; 
alpha1=0.43;
Omega_z_G=50;
zenithAng_Do=50; 

C2n_Weak=5*10^-15;       %Refractive index structure coefficient
C2n_Strong=7*10^-12; 

MArray=[1,2,3,4,5,6,7,8];%Maximum number of transmissions

ScaleCo_Weak=0.7;
ScaleCo_Strong=1.4;

P_T_dBm=42;
B=1:1:16; 

%Calculate Key loss rate
%Weak turbulence
QBER_Weak=zeros(1,length(B));
P_sift_Weak=zeros(1,length(B));

keyLossRate1_Weak=zeros(1,length(B));
keyLossRate2_Weak=zeros(1,length(B));
keyLossRate3_Weak=zeros(1,length(B));
keyLossRate4_Weak=zeros(1,length(B));
keyLossRate5_Weak=zeros(1,length(B));
keyLossRate6_Weak=zeros(1,length(B));
keyLossRate7_Weak=zeros(1,length(B));
keyLossRate8_Weak=zeros(1,length(B));

for i=1:length(B) 
    [QBER_Weak(i),P_sift_Weak(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Weak,P_T_dBm,C2n_Weak);
    
    keyLossRate1_Weak(i)=calculateKeyLossRate(MArray(1),B(i),QBER_Weak(i),P_sift_Weak(i));
    keyLossRate2_Weak(i)=calculateKeyLossRate(MArray(2),B(i),QBER_Weak(i),P_sift_Weak(i));
    keyLossRate3_Weak(i)=calculateKeyLossRate(MArray(3),B(i),QBER_Weak(i),P_sift_Weak(i));  
    keyLossRate4_Weak(i)=calculateKeyLossRate(MArray(4),B(i),QBER_Weak(i),P_sift_Weak(i));
    keyLossRate5_Weak(i)=calculateKeyLossRate(MArray(5),B(i),QBER_Weak(i),P_sift_Weak(i));
    keyLossRate6_Weak(i)=calculateKeyLossRate(MArray(6),B(i),QBER_Weak(i),P_sift_Weak(i));
    keyLossRate7_Weak(i)=calculateKeyLossRate(MArray(7),B(i),QBER_Weak(i),P_sift_Weak(i));
    keyLossRate8_Weak(i)=calculateKeyLossRate(MArray(8),B(i),QBER_Weak(i),P_sift_Weak(i));
end

%Strong turbulence
QBER_Strong=zeros(1,length(B));
P_sift_Strong=zeros(1,length(B));

keyLossRate1_Strong=zeros(1,length(B));
keyLossRate2_Strong=zeros(1,length(B));
keyLossRate3_Strong=zeros(1,length(B));
keyLossRate4_Strong=zeros(1,length(B));
keyLossRate5_Strong=zeros(1,length(B));
keyLossRate6_Strong=zeros(1,length(B));
keyLossRate7_Strong=zeros(1,length(B));
keyLossRate8_Strong=zeros(1,length(B));

for i=1:length(B) 
    [QBER_Strong(i),P_sift_Strong(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Strong,P_T_dBm,C2n_Strong);
    
    keyLossRate1_Strong(i)=calculateKeyLossRate(MArray(1),B(i),QBER_Strong(i),P_sift_Strong(i));
    keyLossRate2_Strong(i)=calculateKeyLossRate(MArray(2),B(i),QBER_Strong(i),P_sift_Strong(i));
    keyLossRate3_Strong(i)=calculateKeyLossRate(MArray(3),B(i),QBER_Strong(i),P_sift_Strong(i));  
    keyLossRate4_Strong(i)=calculateKeyLossRate(MArray(4),B(i),QBER_Strong(i),P_sift_Strong(i));
    keyLossRate5_Strong(i)=calculateKeyLossRate(MArray(5),B(i),QBER_Strong(i),P_sift_Strong(i));
    keyLossRate6_Strong(i)=calculateKeyLossRate(MArray(6),B(i),QBER_Strong(i),P_sift_Strong(i));
    keyLossRate7_Strong(i)=calculateKeyLossRate(MArray(7),B(i),QBER_Strong(i),P_sift_Strong(i));
    keyLossRate8_Strong(i)=calculateKeyLossRate(MArray(8),B(i),QBER_Strong(i),P_sift_Strong(i));
end

%Plot function of the key loss rate
%Weak turbulence
figure(1)
semilogy(B,keyLossRate1_Weak,'b-',B,keyLossRate2_Weak,'r--',B,keyLossRate3_Weak,'kd-',B,keyLossRate4_Weak,'g+-',...
         B,keyLossRate5_Weak,'m-*',B,keyLossRate6_Weak,'c-o',B,keyLossRate7_Weak,'k-s',B,keyLossRate8_Weak,'b-x','LineWidth',1.5);
grid on
xlabel('Buffer size, B (bit strings)');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southwest');
axis([1,16,1.e-10,1.e-0]);

%Strong turbulence
figure(2)
semilogy(B,keyLossRate1_Strong,'b-',B,keyLossRate2_Strong,'r--',B,keyLossRate3_Strong,'kd-',B,keyLossRate4_Strong,'g+-',...
         B,keyLossRate5_Strong,'m-*',B,keyLossRate6_Strong,'c-o',B,keyLossRate7_Strong,'k-s',B,keyLossRate8_Strong,'b-x','LineWidth',1.5);
grid on
xlabel('Buffer size, B (bit strings)');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southwest');
axis([1,16,1.e-4,1.e-0]);