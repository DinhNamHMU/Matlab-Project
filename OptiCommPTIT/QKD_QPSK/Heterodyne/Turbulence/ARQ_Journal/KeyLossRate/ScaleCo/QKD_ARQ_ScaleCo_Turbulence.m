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
global alpha1;           %Attenuatation coefficient(dB/km)
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
alpha1=0.43;
Omega_z_G=50;
zenithAng_Do=50;               

C2n_Weak=5*10^-15;             %Refractive index structure coefficient
C2n_Strong=7*10^-12;

P_T_dBm=36;                     
MArray=[1,2,3,4,5,6,7,8]; %Maximum number of transmissions
B=10;                          %BS buffer size
ScaleCo=2:0.09:6;

%Calculate Key loss rate
%Weak turbulence
QBER_Weak=zeros(1,length(ScaleCo));
P_sift_Weak=zeros(1,length(ScaleCo));

keyLossRate1_Weak=zeros(1,length(ScaleCo));
keyLossRate2_Weak=zeros(1,length(ScaleCo));
keyLossRate3_Weak=zeros(1,length(ScaleCo));
keyLossRate4_Weak=zeros(1,length(ScaleCo));
keyLossRate5_Weak=zeros(1,length(ScaleCo));
keyLossRate6_Weak=zeros(1,length(ScaleCo));
keyLossRate7_Weak=zeros(1,length(ScaleCo));
keyLossRate8_Weak=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER_Weak(i),P_sift_Weak(i)]=calculateQBER_QPSK_Gamma(ScaleCo(i),P_T_dBm,C2n_Weak);
    
    keyLossRate1_Weak(i)=calculateKeyLossRate(MArray(1),B,QBER_Weak(i),P_sift_Weak(i));
    keyLossRate2_Weak(i)=calculateKeyLossRate(MArray(2),B,QBER_Weak(i),P_sift_Weak(i));
    keyLossRate3_Weak(i)=calculateKeyLossRate(MArray(3),B,QBER_Weak(i),P_sift_Weak(i));  
    keyLossRate4_Weak(i)=calculateKeyLossRate(MArray(4),B,QBER_Weak(i),P_sift_Weak(i));
    keyLossRate5_Weak(i)=calculateKeyLossRate(MArray(5),B,QBER_Weak(i),P_sift_Weak(i));
    keyLossRate6_Weak(i)=calculateKeyLossRate(MArray(6),B,QBER_Weak(i),P_sift_Weak(i));
    keyLossRate7_Weak(i)=calculateKeyLossRate(MArray(7),B,QBER_Weak(i),P_sift_Weak(i));
    keyLossRate8_Weak(i)=calculateKeyLossRate(MArray(8),B,QBER_Weak(i),P_sift_Weak(i));
end

%Strong turbulence
QBER_Strong=zeros(1,length(ScaleCo));
P_sift_Strong=zeros(1,length(ScaleCo));

keyLossRate1_Strong=zeros(1,length(ScaleCo));
keyLossRate2_Strong=zeros(1,length(ScaleCo));
keyLossRate3_Strong=zeros(1,length(ScaleCo));
keyLossRate4_Strong=zeros(1,length(ScaleCo));
keyLossRate5_Strong=zeros(1,length(ScaleCo));
keyLossRate6_Strong=zeros(1,length(ScaleCo));
keyLossRate7_Strong=zeros(1,length(ScaleCo));
keyLossRate8_Strong=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER_Strong(i),P_sift_Strong(i)]=calculateQBER_QPSK_Gamma(ScaleCo(i),P_T_dBm,C2n_Strong);
    
    keyLossRate1_Strong(i)=calculateKeyLossRate(MArray(1),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate2_Strong(i)=calculateKeyLossRate(MArray(2),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate3_Strong(i)=calculateKeyLossRate(MArray(3),B,QBER_Strong(i),P_sift_Strong(i));  
    keyLossRate4_Strong(i)=calculateKeyLossRate(MArray(4),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate5_Strong(i)=calculateKeyLossRate(MArray(5),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate6_Strong(i)=calculateKeyLossRate(MArray(6),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate7_Strong(i)=calculateKeyLossRate(MArray(7),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate8_Strong(i)=calculateKeyLossRate(MArray(8),B,QBER_Strong(i),P_sift_Strong(i));
end

%Plot function of the key loss rate
%Weak turbulence
figure(1)
semilogy(ScaleCo,keyLossRate1_Weak,'b-',ScaleCo,keyLossRate2_Weak,'r--',ScaleCo,keyLossRate3_Weak,'kd-',ScaleCo,keyLossRate4_Weak,'g+-',...
         ScaleCo,keyLossRate5_Weak,'m-*',ScaleCo,keyLossRate6_Weak,'c-o',ScaleCo,keyLossRate7_Weak,'k-s',ScaleCo,keyLossRate8_Weak,'b-x','LineWidth',1.5);
grid on
xlabel('D-T scale coefficient, \rho');
ylabel('Key loss rate, KLR');
% title('Weak turbulence C^2_{n}=10^{-15} (m^{-2/3})');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southeast');
axis([2,6,1.e-12,1.e-0]);

%Strong turbulence
figure(2)
semilogy(ScaleCo,keyLossRate1_Strong,'b-',ScaleCo,keyLossRate2_Strong,'r--',ScaleCo,keyLossRate3_Strong,'kd-',ScaleCo,keyLossRate4_Strong,'g+-',...
         ScaleCo,keyLossRate5_Strong,'m-*',ScaleCo,keyLossRate6_Strong,'c-o',ScaleCo,keyLossRate7_Strong,'k-s',ScaleCo,keyLossRate8_Strong,'b-x','LineWidth',1.5);
grid on
xlabel('D-T scale coefficient, \rho');
ylabel('Key loss rate, KLR');
% title('Strong turbulence C^2_{n}=10^{-13} (m^{-2/3})');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southeast');
axis([2,6,1.e-12,1.e-0]);