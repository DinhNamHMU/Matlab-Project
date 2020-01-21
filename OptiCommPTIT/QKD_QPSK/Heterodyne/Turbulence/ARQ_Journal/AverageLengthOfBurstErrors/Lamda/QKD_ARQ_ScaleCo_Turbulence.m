%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
global Rb;               %Bit rate (bps)
global P_LO_dBm;         %Power of Local Oscillator (dBm)
global lamda_wavelength; %Wavelength (m)
global v_wind;           %Wind speed (m/s)
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
B=10;                    %BS buffer size

ScaleCo_Weak=0.7;
ScaleCo_Strong=1.4;

P_T_dBm=36; 
lamda=0.1:5:201;

%Calculate Key loss rate
%Weak turbulence
QBER_Weak=zeros(1,length(lamda));
P_sift_Weak=zeros(1,length(lamda));

keyLossRate1_Weak=zeros(1,length(lamda));
keyLossRate2_Weak=zeros(1,length(lamda));
keyLossRate3_Weak=zeros(1,length(lamda));
keyLossRate4_Weak=zeros(1,length(lamda));
keyLossRate5_Weak=zeros(1,length(lamda));
keyLossRate6_Weak=zeros(1,length(lamda));
keyLossRate7_Weak=zeros(1,length(lamda));
keyLossRate8_Weak=zeros(1,length(lamda));

l_b1_Weak=zeros(1,length(lamda));
l_b2_Weak=zeros(1,length(lamda));
l_b3_Weak=zeros(1,length(lamda));
l_b4_Weak=zeros(1,length(lamda));
l_b5_Weak=zeros(1,length(lamda));
l_b6_Weak=zeros(1,length(lamda));
l_b7_Weak=zeros(1,length(lamda));
l_b8_Weak=zeros(1,length(lamda));


for i=1:length(lamda) 
    [QBER_Weak(i),P_sift_Weak(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Weak,P_T_dBm,C2n_Weak);
    
    [keyLossRate1_Weak(i),l_b1_Weak(i)]=calculateKeyLossRate(MArray(1),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [keyLossRate2_Weak(i),l_b2_Weak(i)]=calculateKeyLossRate(MArray(2),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [keyLossRate3_Weak(i),l_b3_Weak(i)]=calculateKeyLossRate(MArray(3),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));  
    [keyLossRate4_Weak(i),l_b4_Weak(i)]=calculateKeyLossRate(MArray(4),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [keyLossRate5_Weak(i),l_b5_Weak(i)]=calculateKeyLossRate(MArray(5),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [keyLossRate6_Weak(i),l_b6_Weak(i)]=calculateKeyLossRate(MArray(6),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [keyLossRate7_Weak(i),l_b7_Weak(i)]=calculateKeyLossRate(MArray(7),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [keyLossRate8_Weak(i),l_b8_Weak(i)]=calculateKeyLossRate(MArray(8),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
end

% %Strong turbulence
% QBER_Strong=zeros(1,length(lamda));
% P_sift_Strong=zeros(1,length(lamda));
% 
% keyLossRate1_Strong=zeros(1,length(lamda));
% keyLossRate2_Strong=zeros(1,length(lamda));
% keyLossRate3_Strong=zeros(1,length(lamda));
% keyLossRate4_Strong=zeros(1,length(lamda));
% keyLossRate5_Strong=zeros(1,length(lamda));
% keyLossRate6_Strong=zeros(1,length(lamda));
% keyLossRate7_Strong=zeros(1,length(lamda));
% keyLossRate8_Strong=zeros(1,length(lamda));
% 
% l_b1_Strong=zeros(1,length(lamda));
% l_b2_Strong=zeros(1,length(lamda));
% l_b3_Strong=zeros(1,length(lamda));
% l_b4_Strong=zeros(1,length(lamda));
% l_b5_Strong=zeros(1,length(lamda));
% l_b6_Strong=zeros(1,length(lamda));
% l_b7_Strong=zeros(1,length(lamda));
% l_b8_Strong=zeros(1,length(lamda));
% 
% for i=1:length(lamda) 
%     [QBER_Strong(i),P_sift_Strong(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Strong,P_T_dBm,C2n_Strong);
%     
%     [keyLossRate1_Strong(i),l_b1_Strong(i)]=calculateKeyLossRate(MArray(1),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [keyLossRate2_Strong(i),l_b2_Strong(i)]=calculateKeyLossRate(MArray(2),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [keyLossRate3_Strong(i),l_b3_Strong(i)]=calculateKeyLossRate(MArray(3),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));  
%     [keyLossRate4_Strong(i),l_b4_Strong(i)]=calculateKeyLossRate(MArray(4),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [keyLossRate5_Strong(i),l_b5_Strong(i)]=calculateKeyLossRate(MArray(5),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [keyLossRate6_Strong(i),l_b6_Strong(i)]=calculateKeyLossRate(MArray(6),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [keyLossRate7_Strong(i),l_b7_Strong(i)]=calculateKeyLossRate(MArray(7),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [keyLossRate8_Strong(i),l_b8_Strong(i)]=calculateKeyLossRate(MArray(8),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
% end

%Plot function of the key loss rate
%Weak turbulence
figure(1)
semilogy(lamda,keyLossRate1_Weak,'b-',lamda,keyLossRate2_Weak,'r--',lamda,keyLossRate3_Weak,'kd-',lamda,keyLossRate4_Weak,'g+-',...
         lamda,keyLossRate5_Weak,'m-*',lamda,keyLossRate6_Weak,'c-o',lamda,keyLossRate7_Weak,'k-s',lamda,keyLossRate8_Weak,'b-x','LineWidth',1.5);
grid on
xlabel('Lamda, (bit strings/seconds)');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southwest');
axis([0,200,1.e-6,1.e-0]);

% %Strong turbulence
% figure(2)
% semilogy(lamda,keyLossRate1_Strong,'b-',lamda,keyLossRate2_Strong,'r--',lamda,keyLossRate3_Strong,'kd-',lamda,keyLossRate4_Strong,'g+-',...
%          lamda,keyLossRate5_Strong,'m-*',lamda,keyLossRate6_Strong,'c-o',lamda,keyLossRate7_Strong,'k-s',lamda,keyLossRate8_Strong,'b-x','LineWidth',1.5);
% grid on
% xlabel('Lamda, (bit strings/seconds)');
% ylabel('Key loss rate, KLR');
% legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
%        'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southweast');
% % axis([0,200,1.e-6,1.e-0]);

%Plot function of the average length of burst errors
%Weak turbulence
figure(3)
semilogy(lamda,l_b1_Weak,'b-',lamda,l_b2_Weak,'r--',lamda,l_b3_Weak,'kd-',lamda,l_b4_Weak,'g+-',...
         lamda,l_b5_Weak,'m-*',lamda,l_b6_Weak,'c-o',lamda,l_b7_Weak,'k-s',lamda,l_b8_Weak,'b-x','LineWidth',1.5);
grid on
xlabel('Lamda, (bit strings/seconds)');
ylabel('Average length of burst errors (packages)');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','northeast');
axis([0,200,0,2.5]);

% %Strong turbulence
% figure(4)
% semilogy(lamda,l_b1_Strong,'b-',lamda,l_b2_Strong,'r--',lamda,l_b3_Strong,'kd-',lamda,l_b4_Strong,'g+-',...
%          lamda,l_b5_Strong,'m-*',lamda,l_b6_Strong,'c-o',lamda,l_b7_Strong,'k-s',lamda,l_b8_Strong,'b-x','LineWidth',1.5);
% grid on
% xlabel('Lamda, (bit strings/seconds)');
% ylabel('Average length of burst errors (packages)');
% legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
%        'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','northeast');
% axis([0,200,0,2.5]);