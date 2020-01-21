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
global l_k;              %Length of bit string(in bits)
global alpha1;           %Attenuatation coefficient(dB/km)
global Omega_z_G;
global zenithAng_Do;     %Zenith angle(degree)
global D;                %Maximum delay jitter

Rb=10*10^9;
P_LO_dBm=0;
lamda_wavelength=1550*10^-9;
v_wind=21;
D=80*10^-3;                 
H_S=600*10^3;
H_G=5;   
H_a=20*10^3;
l_k=5*10^7; 
alpha1=0.43;
Omega_z_G=50;
zenithAng_Do=50;               

C2n_Weak=5*10^-15;       %Refractive index structure coefficient
C2n_Strong=7*10^-12;

ScaleCo_Weak=0.7;
ScaleCo_Strong=1.4;

P_T_dBm=36;                     
MArray=[1,2,3,4,5,6,7,8];%Maximum number of transmissions
B=10;                    %BS buffer size
lamda=0:20:200;

%Calculate Key loss rate
%Weak turbulence
QBER_Weak=zeros(1,length(lamda));
P_sift_Weak=zeros(1,length(lamda));

delayOutageRate2_Weak=zeros(1,length(lamda));
delayOutageRate3_Weak=zeros(1,length(lamda));
delayOutageRate4_Weak=zeros(1,length(lamda));
delayOutageRate5_Weak=zeros(1,length(lamda));
delayOutageRate6_Weak=zeros(1,length(lamda));
delayOutageRate7_Weak=zeros(1,length(lamda));
delayOutageRate8_Weak=zeros(1,length(lamda));

for i=1:length(lamda) 
    [QBER_Weak(i),P_sift_Weak(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Weak,P_T_dBm,C2n_Weak);
   
    [delayOutageRate2_Weak(i)]=calculateKeyLossRate(MArray(2),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [delayOutageRate3_Weak(i)]=calculateKeyLossRate(MArray(3),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));  
    [delayOutageRate4_Weak(i)]=calculateKeyLossRate(MArray(4),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [delayOutageRate5_Weak(i)]=calculateKeyLossRate(MArray(5),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [delayOutageRate6_Weak(i)]=calculateKeyLossRate(MArray(6),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [delayOutageRate7_Weak(i)]=calculateKeyLossRate(MArray(7),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
    [delayOutageRate8_Weak(i)]=calculateKeyLossRate(MArray(8),B,QBER_Weak(i),P_sift_Weak(i),lamda(i));
end

% %Strong turbulence
% QBER_Strong=zeros(1,length(lamda));
% P_sift_Strong=zeros(1,length(lamda));
% 
% delayOutageRate2_Strong=zeros(1,length(lamda));
% delayOutageRate3_Strong=zeros(1,length(lamda));
% delayOutageRate4_Strong=zeros(1,length(lamda));
% delayOutageRate5_Strong=zeros(1,length(lamda));
% delayOutageRate6_Strong=zeros(1,length(lamda));
% delayOutageRate7_Strong=zeros(1,length(lamda));
% delayOutageRate8_Strong=zeros(1,length(lamda));
% 
% for i=1:length(lamda) 
%     [QBER_Strong(i),P_sift_Strong(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Strong,P_T_dBm,C2n_Strong);
%    
%     [delayOutageRate2_Strong(i)]=calculateKeyLossRate(MArray(2),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [delayOutageRate3_Strong(i)]=calculateKeyLossRate(MArray(3),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));  
%     [delayOutageRate4_Strong(i)]=calculateKeyLossRate(MArray(4),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [delayOutageRate5_Strong(i)]=calculateKeyLossRate(MArray(5),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [delayOutageRate6_Strong(i)]=calculateKeyLossRate(MArray(6),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [delayOutageRate7_Strong(i)]=calculateKeyLossRate(MArray(7),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
%     [delayOutageRate8_Strong(i)]=calculateKeyLossRate(MArray(8),B,QBER_Strong(i),P_sift_Strong(i),lamda(i));
% end

%Plot function of Delay outage rate
%Weak turbulence
figure(1)
semilogy(lamda,delayOutageRate2_Weak,'r--',lamda,delayOutageRate3_Weak,'kd-',lamda,delayOutageRate4_Weak,'g+-',...
         lamda,delayOutageRate5_Weak,'m-*',lamda,delayOutageRate6_Weak,'c-o',lamda,delayOutageRate7_Weak,'k-s',...
         lamda,delayOutageRate8_Weak,'b-x','LineWidth',1.5);
grid on
xlabel('Throughput, H (bit strings/seconds)');
ylabel('Delay outage rate');
% title('Weak turbulence C^2_{n}=10^{-15} (m^{-2/3})');
legend('QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southwest');
% axis([0,4,1.e-6,1.e-0]);

% %Strong turbulence
% figure(2)
% semilogy(lamda,delayOutageRate2_Strong,'r--',lamda,delayOutageRate3_Strong,'kd-',lamda,delayOutageRate4_Strong,'g+-',...
%          lamda,delayOutageRate5_Strong,'m-*',lamda,delayOutageRate6_Strong,'c-o',lamda,delayOutageRate7_Strong,'k-s',...
%          lamda,delayOutageRate8_Strong,'b-x','LineWidth',1.5);
% grid on
% xlabel('Throughput, H (bit strings/seconds)');
% ylabel('Delay outage rate');
% % title('Strong turbulence C^2_{n}=10^{-13} (m^{-2/3})');
% legend('QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
%        'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southwest');
% % axis([0,4,1.e-6,1.e-0]);