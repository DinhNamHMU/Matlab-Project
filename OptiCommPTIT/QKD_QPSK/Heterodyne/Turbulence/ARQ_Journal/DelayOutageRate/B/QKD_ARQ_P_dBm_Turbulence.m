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
global l_k;              %Length of bit string (bits)
global alpha1;           %Attenuatation coefficient (dB/km)
global Omega_z_G;
global zenithAng_Do;     %Zenith angle(degree)
global D;                %Maximum delay jitter

Rb=10*10^9;
P_LO_dBm=0;
lamda_wavelength=1550*10^-9;
v_wind=21;
lamda=60;
D=50*10^-3;                 
H_S=600*10^3;
H_G=80;   
H_a=20*10^3;
l_k=5*10^7; 
alpha1=0.43;
Omega_z_G=50;
zenithAng_Do=50;               

C2n_Weak=5*10^-15;       %Refractive index structure coefficient
C2n_Strong=7*10^-12;

P_T_dBm=41;
B=1:1:10;                     
MArray=[1,2,3,4,5,6,7,8];%Maximum number of transmissions

ScaleCo_Weak=0.7;
ScaleCo_Strong=1.4;

%Calculate Delay outage rate
%Weak turbulence
QBER_Weak=zeros(1,length(B));
P_sift_Weak=zeros(1,length(B));

delayOutageRate2_Weak=zeros(1,length(B));
delayOutageRate3_Weak=zeros(1,length(B));
delayOutageRate4_Weak=zeros(1,length(B));
delayOutageRate5_Weak=zeros(1,length(B));
delayOutageRate6_Weak=zeros(1,length(B));
delayOutageRate7_Weak=zeros(1,length(B));
delayOutageRate8_Weak=zeros(1,length(B));

for i=1:length(B) 
    [QBER_Weak(i),P_sift_Weak(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Weak,P_T_dBm,C2n_Weak);
    
    [delayOutageRate2_Weak(i)]=calculateKeyLossRate(MArray(2),B(i),QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate3_Weak(i)]=calculateKeyLossRate(MArray(3),B(i),QBER_Weak(i),P_sift_Weak(i));  
    [delayOutageRate4_Weak(i)]=calculateKeyLossRate(MArray(4),B(i),QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate5_Weak(i)]=calculateKeyLossRate(MArray(5),B(i),QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate6_Weak(i)]=calculateKeyLossRate(MArray(6),B(i),QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate7_Weak(i)]=calculateKeyLossRate(MArray(7),B(i),QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate8_Weak(i)]=calculateKeyLossRate(MArray(8),B(i),QBER_Weak(i),P_sift_Weak(i));
end

% %Strong turbulence
% QBER_Strong=zeros(1,length(B));
% P_sift_Strong=zeros(1,length(B));
% 
% delayOutageRate2_Strong=zeros(1,length(B));
% delayOutageRate3_Strong=zeros(1,length(B));
% delayOutageRate4_Strong=zeros(1,length(B));
% delayOutageRate5_Strong=zeros(1,length(B));
% delayOutageRate6_Strong=zeros(1,length(B));
% delayOutageRate7_Strong=zeros(1,length(B));
% delayOutageRate8_Strong=zeros(1,length(B));
% 
% for i=1:length(B) 
%     [QBER_Strong(i),P_sift_Strong(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Strong,P_T_dBm,C2n_Strong);
%     
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(2),B(i),QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(3),B(i),QBER_Strong(i),P_sift_Strong(i));  
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(4),B(i),QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(5),B(i),QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(6),B(i),QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(7),B(i),QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(8),B(i),QBER_Strong(i),P_sift_Strong(i));
% end

%Plot function of delay outage rate
%Weak turbulence
figure(1)
semilogy(B,delayOutageRate2_Weak,'r--',B,delayOutageRate3_Weak,'kd-',B,delayOutageRate4_Weak,'g+-',...
         B,delayOutageRate5_Weak,'m-*',B,delayOutageRate6_Weak,'c-o',B,delayOutageRate7_Weak,'k-s',...
         B,delayOutageRate8_Weak,'b-x','LineWidth',1.5);
grid on
xlabel('Buffer size, B (bit strings)');
ylabel('Delay outage rate');
% title('Weak turbulence C^2_{n}=10^{-15} (m^{-2/3})');
legend('QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southeast');
% axis([3,10,1.e-5,1.e-0]);

% %Strong turbulence
% figure(2)
% semilogy(B,delayOutageRate2_Strong,'r--',B,delayOutageRate3_Strong,'kd-',B,delayOutageRate4_Strong,'g+-',...
%          B,delayOutageRate5_Strong,'m-*',B,delayOutageRate6_Strong,'c-o',B,delayOutageRate7_Strong,'k-s',...
%          B,delayOutageRate8_Strong,'b-x','LineWidth',1.5);
% grid on
% xlabel('Buffer size, B (bit strings)');
% ylabel('Delay outage rate');
% % title('Strong turbulence C^2_{n}=10^{-13} (m^{-2/3})');
% legend('QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
%        'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','southeast');
% axis([3,10,1.e-5,1.e-0]);