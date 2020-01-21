%HAP-Aided Relaying Satellite FSO/QKD Systems for Secure Vehicular
%Networks-Minh Q. Vu
clear;
clc;

%Simulation Parameters
global B;        %Bit rate(bit/s)
global scale;
global P_dBm;    %Peak transmitted power
global Omega_z_P;  
global Omega_z_G;
global ModDepth;
global sigma;
global G_A_dB;   %Gain of amplifier=10-20-30-35 dB

B=10^9;
scale=50;
P_dBm=30; 
Omega_z_P=1475;
Omega_z_G=50;
ModDepth=0.4;
G_A_dB=35;
sigma=0.4;

r_Array11=linspace(0,1480,scale);
r_Array12=linspace(0,100,scale);
ScaleCoArray=(linspace(0,4,scale))';

%Calculate Ergodic Secret Key Rate
v11=ones(length(r_Array11),1);
v12=ones(length(r_Array12),1);
v2=ones(length(ScaleCoArray),1);
X_r_Array11=v11*r_Array11;
X_r_Array12=v12*r_Array12;
Y_ScaleCoArray=ScaleCoArray*v2';

S_Gamma=calculateErgodicSecretKeyRate3D_HAP(X_r_Array11,Y_ScaleCoArray);
S_Gamma2=calculateErgodicSecretKeyRate3D_HAP2(X_r_Array12,Y_ScaleCoArray);

%Plot function Ergodic Secret Key Rate versus Eve-HAP distance and Scale coefficient
%Scenario 1 
figure(1)
contourf(X_r_Array11,Y_ScaleCoArray,S_Gamma);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Eve-HAP distance, r (m)');
ylabel('D-T scale coefficient, \varsigma');
zlabel('Ergodic secret-key rate, S (bits/s/HZ)');
title('Ergodic secret-key rate versus D-T scale coefficient (\varsigma) and Eve-HAP distance, r (m)');
colorbar;
colormap('jet');

%Scenario 2
figure(2)
contourf(X_r_Array12,Y_ScaleCoArray,S_Gamma2);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Eve-Bob distance, r (m)');
ylabel('D-T scale coefficient, \varsigma');
zlabel('Ergodic secret-key rate, S (bits/s/HZ)');
title('Ergodic secret-key rate versus D-T scale coefficient (\varsigma) and Eve-Bob distance, r (m)');
colorbar;
colormap('jet');