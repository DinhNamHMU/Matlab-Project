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
global ScaleCo;          %Attenuatation coefficient(dB/km)
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
ScaleCo=1.4;
Omega_z_G=50;
zenithAng_Do=50; 

C2n_Strong=7*10^-12; %Refractive index structure coefficient
B=10;                %BS buffer size
P_T_dBm=44;  
scale=7;

M_retransmission=linspace(1,7,scale);
M_transmission=size(1,length(M_retransmission));
for i=1:length(M_retransmission)
    M_transmission(i)=M_retransmission(i)+1;
end
AttenuationArray=(linspace(4,59,scale))';

%Calculate Key loss rate
%Strong turbulence
v1_retransmission=ones(length(M_retransmission),1);
v1_transmission=ones(length(M_transmission),1);
v2=ones(length(AttenuationArray),1);
X_retransmission=v1_retransmission*M_retransmission;
X_transmission=v1_transmission*M_transmission;
Y_AttenuationArray=AttenuationArray*v2';

keyLossRate_Strong=zeros(length(M_transmission),length(M_transmission));
QBER_Strong=zeros(length(M_transmission),length(M_transmission));
P_sift_Strong=zeros(length(M_transmission),length(M_transmission));

for i=1:length(M_transmission) 
    for j=1:length(M_transmission) 
        [QBER_Strong(i,j),P_sift_Strong(i,j)]=calculateQBER_QPSK_Gamma(Y_AttenuationArray(i,j),P_T_dBm,C2n_Strong);
        keyLossRate_Strong(i,j)=calculateKeyLossRate(X_transmission(i,j),B,QBER_Strong(i,j),P_sift_Strong(i,j));
    end
end

%Plot function of the key loss rate
%Strong turbulence
% figure(1)
% surfc(X_retransmission,Y_AttenuationArray,keyLossRate_Strong);
% xlabel('Number of retransmission, M');
% ylabel('Attenuation coefficient, \sigma (dB/km)');
% zlabel('Key loss rate, KLR');
% colorbar;
% colormap('jet');

figure(2)
contourf(X_retransmission,Y_AttenuationArray,keyLossRate_Strong);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Number of retransmission, M');
ylabel('Attenuation coefficient, \sigma (dB/km)');
zlabel('Key loss rate, KLR');
title('Key loss rate, KLR','FontWeight','Normal');
colorbar
colormap('jet');