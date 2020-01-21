%Calculate Ergodic Secret Key Rate of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with QPSK scheme
clear;
clc;

%Simulation Paramet28ers
global Rb;       %Bit rate(bit/s)
global P_LO_dBm; %Power of Local Oscillator(dBm)
global P_T_dBm;  %Transmitted power(W)

Rb=10*10^9;
P_LO_dBm=0;
P_T_dBm=30;

scale=50;

r_Eve_Array=linspace(0,100,scale);
ScaleCoArray=(linspace(0,3,scale))';

%Calculate Ergodic Secret Key Rate
v1=ones(length(r_Eve_Array),1);
v2=ones(length(ScaleCoArray),1);
X_r_Eve_Array=v1*r_Eve_Array;
Y_ScaleCoArray=ScaleCoArray*v2';

S=calculateErgodicSecretKeyRate3D_QPSK(X_r_Eve_Array,Y_ScaleCoArray);

%Plot function Ergodic Secret Key Rate versus Eve-Alice distance and Scale coefficient
figure(1)
% surfc(X_r_Eve_Array,Y_ScaleCoArray,S);
contourf(X_r_Eve_Array,Y_ScaleCoArray,S);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Eve-Bob distance, l_{EB} (m)');
ylabel('D-T scale coefficient, \rho');
zlabel('Ergodic secret-key rate, S (bits/s/Hz)');
title('Ergodic secret-key rate (S)','FontWeight','Normal');
% axis([0,100,0,3,-0.4,0.4]);
colorbar
colormap('jet');