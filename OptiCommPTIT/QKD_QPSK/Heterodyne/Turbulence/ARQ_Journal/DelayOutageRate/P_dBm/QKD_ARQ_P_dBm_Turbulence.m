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
lamda=80;
D=80*10^-3;                 
H_S=600*10^3;
H_G=80;   
H_a=20*10^3;
l_k=5*10^7; 
alpha1=0.43;
Omega_z_G=50;
zenithAng_Do=50;               

C2n_Weak=5*10^-15;       %Refractive index structure coefficient
C2n_Strong=7*10^-12;

P_T_dBm=38:1:46;                     
MArray=[1,2,3,4,5,6,7,8];%Maximum number of transmissions
B=10;                    %BS buffer size

ScaleCo_Weak=0.7;
ScaleCo_Strong=1.4;

%Calculate Delay outage rate
%Weak turbulence
QBER_Weak=zeros(1,length(P_T_dBm));
P_sift_Weak=zeros(1,length(P_T_dBm));

delayOutageRate2_Weak=zeros(1,length(P_T_dBm));
delayOutageRate3_Weak=zeros(1,length(P_T_dBm));
delayOutageRate4_Weak=zeros(1,length(P_T_dBm));
delayOutageRate5_Weak=zeros(1,length(P_T_dBm));
delayOutageRate6_Weak=zeros(1,length(P_T_dBm));
delayOutageRate7_Weak=zeros(1,length(P_T_dBm));
delayOutageRate8_Weak=zeros(1,length(P_T_dBm));

for i=1:length(P_T_dBm) 
    [QBER_Weak(i),P_sift_Weak(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Weak,P_T_dBm(i),C2n_Weak);
    
    [delayOutageRate2_Weak(i)]=calculateKeyLossRate(MArray(2),B,QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate3_Weak(i)]=calculateKeyLossRate(MArray(3),B,QBER_Weak(i),P_sift_Weak(i));  
    [delayOutageRate4_Weak(i)]=calculateKeyLossRate(MArray(4),B,QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate5_Weak(i)]=calculateKeyLossRate(MArray(5),B,QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate6_Weak(i)]=calculateKeyLossRate(MArray(6),B,QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate7_Weak(i)]=calculateKeyLossRate(MArray(7),B,QBER_Weak(i),P_sift_Weak(i));
    [delayOutageRate8_Weak(i)]=calculateKeyLossRate(MArray(8),B,QBER_Weak(i),P_sift_Weak(i));
end

% %Strong turbulence
% QBER_Strong=zeros(1,length(P_T_dBm));
% P_sift_Strong=zeros(1,length(P_T_dBm));
% 
% delayOutageRate2_Strong=zeros(1,length(P_T_dBm));
% delayOutageRate3_Strong=zeros(1,length(P_T_dBm));
% delayOutageRate4_Strong=zeros(1,length(P_T_dBm));
% delayOutageRate5_Strong=zeros(1,length(P_T_dBm));
% delayOutageRate6_Strong=zeros(1,length(P_T_dBm));
% delayOutageRate7_Strong=zeros(1,length(P_T_dBm));
% delayOutageRate8_Strong=zeros(1,length(P_T_dBm));
% 
% for i=1:length(P_T_dBm) 
%     [QBER_Strong(i),P_sift_Strong(i)]=calculateQBER_QPSK_Gamma(ScaleCo_Strong,P_T_dBm(i),C2n_Strong);
%     
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(2),B,QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(3),B,QBER_Strong(i),P_sift_Strong(i));  
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(4),B,QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(5),B,QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(6),B,QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(7),B,QBER_Strong(i),P_sift_Strong(i));
%     [delayOutageRate1_Strong(i)]=calculateKeyLossRate(MArray(8),B,QBER_Strong(i),P_sift_Strong(i));
% end

%Plot function of delay outage rate
%Weak turbulence
figure(1)
semilogy(P_T_dBm,delayOutageRate2_Weak,'r--',P_T_dBm,delayOutageRate3_Weak,'kd-',P_T_dBm,delayOutageRate4_Weak,'g+-',...
         P_T_dBm,delayOutageRate5_Weak,'m-*',P_T_dBm,delayOutageRate6_Weak,'c-o',P_T_dBm,delayOutageRate7_Weak,'k-s',...
         P_T_dBm,delayOutageRate8_Weak,'b-x','LineWidth',1.5);
grid on
xlabel('Peak transmitted power P_{T} (dBm)');
ylabel('Delay outage rate');
% title('Weak turbulence C^2_{n}=10^{-15} (m^{-2/3})');
legend('QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
       'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','northeast');
% axis([38,46,1.e-2,1.e-0]);

% %Strong turbulence
% figure(2)
% semilogy(P_T_dBm,delayOutageRate2_Strong,'r--',P_T_dBm,delayOutageRate3_Strong,'kd-',P_T_dBm,delayOutageRate4_Strong,'g+-',...
%          P_T_dBm,delayOutageRate5_Strong,'m-*',P_T_dBm,delayOutageRate6_Strong,'c-o',P_T_dBm,delayOutageRate7_Strong,'k-s',...
%          P_T_dBm,delayOutageRate8_Strong,'b-x','LineWidth',1.5);
% grid on
% xlabel('Peak transmitted power P_{T} (dBm)');
% ylabel('Delay outage rate');
% % title('Strong turbulence C^2_{n}=10^{-13} (m^{-2/3})');
% legend('QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4',...
%        'QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','Location','northeast');
% % axis([0,4,1.e-6,1.e-0]);