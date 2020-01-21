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
lamda_wavelength=1550*10^-12;
v_wind=21;
lamda=80;
D=80*10^-3;                 
H_S=600*10^3;
H_G=5;   
H_a=20*10^3;
l_k=5*10^7; 
alpha1=0.43;
Omega_z_G=50;
zenithAng_Do=50;               

C2n_Strong=7*10^-9;      %Refractive index structure coefficient
P_T_dBm=42;               
MArray=[1,2,3,4,5,6,7,8];%Maximum number of transmissions
ScaleCo_Strong=1.4;
scale=15;

BArray=linspace(2,16,scale);
AttenuationArray=(linspace(4,59,scale))';

%Calculate Key loss rate
%Strong turbulence
v1=ones(length(BArray),1);
v2=ones(length(AttenuationArray),1);
X_BArray=v1*BArray;
Y_AttenuationArray=AttenuationArray*v2';

delayOutageRate_Strong=zeros(length(BArray),length(BArray));
QBER_Strong=zeros(length(BArray),length(BArray));
P_sift_Strong=zeros(length(BArray),length(BArray));

for i=1:length(BArray) 
    for j=1:length(BArray) 
        [QBER_Strong(i,j),P_sift_Strong(i,j)]=calculateQBER_QPSK_Gamma(Y_AttenuationArray(i,j),ScaleCo_Strong,P_T_dBm,C2n_Strong);
        delayOutageRate_Strong(i,j)=calculateKeyLossRate(MArray(3),X_BArray(i,j),QBER_Strong(i,j),P_sift_Strong(i,j));
    end
end

% %Plot function of the key loss rate
% %Strong turbulence
% figure(1)
% surfc(X_BArray,Y_AttenuationArray,delayOutageRate_Strong);
% xlabel('Buffer size, B (bit strings)');
% ylabel('Attenuation coefficient, \sigma (dB/km)');
% zlabel('Delay outage rate');
% colorbar;
% colormap('jet');

figure(2)
contourf(X_BArray,Y_AttenuationArray,delayOutageRate_Strong);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Buffer size, B (bit strings)');
ylabel('Attenuation coefficient, \sigma (dB/km)');
zlabel('Delay outage rate');
title('Delay outage rate','FontWeight','Normal');
colorbar
colormap('jet');