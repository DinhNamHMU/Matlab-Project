%Calculate Ergodic Secret Key Rate of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with BPSK scheme
clear;
clc;

%Simulation Parameters
global Rb; %Bit rate(bit/s)
global scale;

Rb=10^9;
scale=40;

L_AE_Array=linspace(1,3,scale);
ScaleCoArray=(linspace(0,5,scale))';

%Calculate Ergodic Secret Key Rate
v1=ones(length(L_AE_Array),1);
v2=ones(length(ScaleCoArray),1);
X_L_AE_Array=v1*L_AE_Array;
Y_ScaleCoArray=ScaleCoArray*v2';

[S_Log,S_Gamma]=calculateErgodicSecretKeyRate3D(X_L_AE_Array,Y_ScaleCoArray);

%Plot function Ergodic Secret Key Rate versus Eve-Alice distance and Scale coefficient
%Log-Normal channel
figure(1)
surfc(X_L_AE_Array,Y_ScaleCoArray,S_Log);
xlabel('Eve-Alice distance');
ylabel('D-T scale coefficient');
zlabel('Ergodic secret-key rate');
title('Ergodic secret-key rate versus D-T scale coefficient and Eve-Alice distance (modeled by LN)');
colorbar;
colormap('jet');

% figure(2)
% contourf(X_L_AE_Array,Y_ScaleCoArray,S_Log);
% grid on
% ax=gca;
% ax.GridColor='White';
% ax.GridLineStyle=':';
% ax.GridAlpha=1;
% ax.Layer='top';
% xlabel('Eve-Alice distance');
% ylabel('D-T scale coefficient');
% zlabel('Ergodic secret-key rate');
% title('Ergodic secret-key rate versus D-T scale coefficient and Eve-Alice distance (modeled by LN)');
% colorbar
% colormap('jet');

%Gamma-Gamma channel 
figure(3)
surfc(X_L_AE_Array,Y_ScaleCoArray,S_Gamma);
xlabel('Eve-Alice distance');
ylabel('D-T scale coefficient');
zlabel('Ergodic secret-key rate');
title('Ergodic secret-key rate versus D-T scale coefficient and Eve-Alice distance (modeled by GG)');
colorbar;
colormap('jet');

% figure(4)
% contourf(X_L_AE_Array,Y_ScaleCoArray,S_Gamma);
% grid on
% ax=gca;
% ax.GridColor='White';
% ax.GridLineStyle=':';
% ax.GridAlpha=1;
% ax.Layer='top';
% xlabel('Eve-Alice distance');
% ylabel('D-T scale coefficient');
% zlabel('Ergodic secret-key rate');
% title('Ergodic secret-key rate versus D-T scale coefficient and Eve-Alice distance (modeled by GG)');
% colorbar
% colormap('jet');