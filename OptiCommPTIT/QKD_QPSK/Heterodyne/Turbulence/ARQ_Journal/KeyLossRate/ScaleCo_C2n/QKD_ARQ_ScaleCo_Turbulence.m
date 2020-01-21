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

for i=1:length(ScaleCo) 
    [QBER_Weak(i),P_sift_Weak(i)]=calculateQBER_QPSK_Gamma(ScaleCo(i),P_T_dBm,C2n_Weak);
    
    keyLossRate1_Weak(i)=calculateKeyLossRate(MArray(1),B,QBER_Weak(i),P_sift_Weak(i));
    keyLossRate2_Weak(i)=calculateKeyLossRate(MArray(2),B,QBER_Weak(i),P_sift_Weak(i));
    keyLossRate3_Weak(i)=calculateKeyLossRate(MArray(3),B,QBER_Weak(i),P_sift_Weak(i));  
    keyLossRate4_Weak(i)=calculateKeyLossRate(MArray(4),B,QBER_Weak(i),P_sift_Weak(i));
end

%Strong turbulence
QBER_Strong=zeros(1,length(ScaleCo));
P_sift_Strong=zeros(1,length(ScaleCo));

keyLossRate1_Strong=zeros(1,length(ScaleCo));
keyLossRate2_Strong=zeros(1,length(ScaleCo));
keyLossRate3_Strong=zeros(1,length(ScaleCo));
keyLossRate4_Strong=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER_Strong(i),P_sift_Strong(i)]=calculateQBER_QPSK_Gamma(ScaleCo(i),P_T_dBm,C2n_Strong);
    
    keyLossRate1_Strong(i)=calculateKeyLossRate(MArray(1),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate2_Strong(i)=calculateKeyLossRate(MArray(2),B,QBER_Strong(i),P_sift_Strong(i));
    keyLossRate3_Strong(i)=calculateKeyLossRate(MArray(3),B,QBER_Strong(i),P_sift_Strong(i));  
    keyLossRate4_Strong(i)=calculateKeyLossRate(MArray(4),B,QBER_Strong(i),P_sift_Strong(i));
end

%Plot function of the key loss rate
figure(1)
semilogy(ScaleCo,keyLossRate2_Weak,'--','color',[1, 0, 0],'LineWidth',1.5);
grid on
hold on
semilogy(ScaleCo,keyLossRate3_Weak,'-o','color',[0, 0, 1],'LineWidth',1.5);
semilogy(ScaleCo,keyLossRate4_Weak,'-s','color',[0, 0.5, 0],'LineWidth',1.5);
semilogy(ScaleCo,keyLossRate2_Strong,'--','color',[1, 0, 0],'LineWidth',1.5);
semilogy(ScaleCo,keyLossRate3_Strong,'-o','color',[0, 0, 1],'LineWidth',1.5);
semilogy(ScaleCo,keyLossRate4_Strong,'-s','color',[0, 0.5, 0],'LineWidth',1.5);
xlabel('D-T scale coefficient, \rho');
ylabel('Key loss rate, KLR');
legend('QKD-KR, M = 1','QKD-KR, M = 2','QKD-KR, M = 3','Location','southwest');
axis([2,6,1.e-12,1.e-0]);