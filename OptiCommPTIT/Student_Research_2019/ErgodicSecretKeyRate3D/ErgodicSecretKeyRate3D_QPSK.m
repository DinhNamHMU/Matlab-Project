%Calculate Ergodic Secret Key Rate of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with QPSK scheme
clear;
clc;

%Simulation Parameters
global Rb;       %Bit rate(bit/s)
global P_LO_dBm; %Power of Local Oscillator(dBm)
global P_T_dBm;%Transmitted power(W)

Rb=10*10^9;
P_LO_dBm=-3;
P_T_dBm=-3;

scale=50;

L_AE_Array=linspace(0,10000,scale);
ScaleCoArray=(linspace(0,1.7,scale))';

%Calculate Ergodic Secret Key Rate
v1=ones(length(L_AE_Array),1);
v2=ones(length(ScaleCoArray),1);
X_L_AE_Array=v1*L_AE_Array;
Y_ScaleCoArray=ScaleCoArray*v2';

S=calculateErgodicSecretKeyRate3D_QPSK(X_L_AE_Array,Y_ScaleCoArray);

%Plot function Ergodic Secret Key Rate versus Eve-Alice distance and Scale coefficient
figure(1)
surfc(X_L_AE_Array,Y_ScaleCoArray,S);
xlabel('Eve-Bob distance, r (m)');
ylabel('D-T scale coefficient, \rho');
zlabel('Ergodic secret-key rate, S (bits/s/Hz)');
% title('Ergodic secret-key rate (S) versus D-T scale coefficient (\rho) and Eve-Bob distance (r)');
% axis([0,50000,0,1.7,-0.8,0.4]);
colorbar