%Calculate Ergodic Secret Key Rate of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with QPSK scheme,tubulence
clear;
clc;

%Simulation Parameters
global Rb;              %Bit rate(bit/s)
global P_LO_dBm;        %Power of Local Oscillator(dBm)
global alpha1;          %Atmospheric attenuation coefficient(dB/km)
global lamda_wavelength;
global Omega_z_G;

Rb=10*10^9;
P_LO_dBm=0;
alpha1=0.43;
lamda_wavelength=1550*10^-9;
Omega_z_G=50;

C2n_Weak=5*10^-14;       %Refractive index structure coefficient
C2n_Moderate=2*10^-12;
C2n_Strong=7*10^-12;

P_T_dBm=36;              %Peak transmitted power (dBm)
scale=40;
L_BE_Array=linspace(0,100,scale);
ScaleCoArray=(linspace(0,4,scale))';

%Calculate Ergodic Secret Key Rate
v1=ones(length(L_BE_Array),1);
v2=ones(length(ScaleCoArray),1);
X_L_BE_Array=v1*L_BE_Array;
Y_ScaleCoArray=ScaleCoArray*v2';

%Weak turbulence
S_Weak=calculateErgodicSecretKeyRate3D(X_L_BE_Array,Y_ScaleCoArray,P_T_dBm,C2n_Weak);

%Strong turbulence
S_Strong=calculateErgodicSecretKeyRate3D(X_L_BE_Array,Y_ScaleCoArray,P_T_dBm,C2n_Strong);

% %Plot function Ergodic Secret Key Rate versus Eve-Alice distance and Scale coefficient
% %Weak turbulence
% figure(1)
% surfc(X_L_BE_Array,Y_ScaleCoArray,S_Weak);
% xlabel('Eve-Bob distance, r_{b} (m)');
% ylabel('D-T scale coefficient, \varsigma');
% zlabel('Ergodic secret-key rate, S (bits/s/Hz)');
% colorbar;
% colormap('jet');

figure(2)
contourf(X_L_BE_Array,Y_ScaleCoArray,S_Weak);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Eve-Bob distance, r_{b} (m)');
ylabel('D-T scale coefficient, \varsigma');
zlabel('Ergodic secret-key rate, S (bits/s/Hz)');
title('Ergodic secret-key rate, S (bits/s/Hz)','FontWeight','Normal');
colorbar
colormap('jet');

% %Strong turbulence
% figure(3)
% surfc(X_L_BE_Array,Y_ScaleCoArray,S_Strong);
% xlabel('Eve-Bob distance, r_{b} (m)');
% ylabel('D-T scale coefficient, \varsigma');
% zlabel('Ergodic secret-key rate, S (bits/s/Hz)');
% colorbar;
% colormap('jet');

figure(4)
contourf(X_L_BE_Array,Y_ScaleCoArray,S_Strong);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Eve-Bob distance, r_{b} (m)');
ylabel('D-T scale coefficient, \varsigma');
zlabel('Ergodic secret-key rate, S (bits/s/Hz)');
title('Ergodic secret-key rate, S (bits/s/Hz)','FontWeight','Normal');
colorbar
colormap('jet');