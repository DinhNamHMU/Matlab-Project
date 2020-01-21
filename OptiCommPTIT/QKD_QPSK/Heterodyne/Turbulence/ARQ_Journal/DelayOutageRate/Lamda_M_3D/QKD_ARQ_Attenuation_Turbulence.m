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
global l_k;              %Length of bit string (bits)
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
Omega_z_G=50;
zenithAng_Do=50;               

C2n_Strong=7*10^-12;      %Refractive index structure coefficient
P_T_dBm=36;
Attenuation=0.43;                 
MArray=[1,2,3,4,5,6,7,8];%Maximum number of transmissions
B=16;                    %BS buffer size
ScaleCo_Strong=1.4;
scale=7;

M_retransmission=linspace(1,7,scale);
M_transmission=size(1,length(M_retransmission));
for i=1:length(M_retransmission)
    M_transmission(i)=M_retransmission(i)+1;
end
LamdaArray=(linspace(0,200,scale))';

%Calculate Key loss rate
%Strong turbulence
v1_retransmission=ones(length(M_retransmission),1);
v1_transmission=ones(length(M_transmission),1);
v2=ones(length(LamdaArray),1);
X_retransmission=v1_retransmission*M_retransmission;
X_transmission=v1_transmission*M_transmission;
Y_LamdaArray=LamdaArray*v2';

delayOutageRate_Strong=zeros(length(M_transmission),length(M_transmission));
QBER_Strong=zeros(length(M_transmission),length(M_transmission));
P_sift_Strong=zeros(length(M_transmission),length(M_transmission));

for i=1:length(M_transmission) 
    for j=1:length(M_transmission) 
        [QBER_Strong(i,j),P_sift_Strong(i,j)]=calculateQBER_QPSK_Gamma(Attenuation,ScaleCo_Strong,P_T_dBm,C2n_Strong);
        delayOutageRate_Strong(i,j)=calculateKeyLossRate(X_transmission(i,j),B,QBER_Strong(i,j),P_sift_Strong(i,j),Y_LamdaArray(i,j));
    end
end

% %Plot function of the key loss rate
% %Strong turbulence
% figure(1)
% surfc(X_retransmission,Y_LamdaArray,delayOutageRate_Strong);
% xlabel('Number of retransmission, M');
% ylabel('Throughput, H (bit strings/seconds)');
% zlabel('Delay outage rate');
% colorbar;
% colormap('jet');

figure(2)
contourf(X_retransmission,Y_LamdaArray,delayOutageRate_Strong);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Number of retransmission, M');
ylabel('Throughput, H (bit strings/seconds)');
zlabel('Delay outage rate');
title('Delay outage rate','FontWeight','Normal');
colorbar
colormap('jet');