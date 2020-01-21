%Final Key-Creation Rate(Rf) versus peak transmitted power(P) in dBm.
clear;
clc;

%Simulation Parameters
global Rb        %Bit rate
global P_LO_dBm; %Power of Local Oscillator(dBm)
global ScaleCo;

Rb=10*10^9;
P_LO_dBm=0;
ScaleCo=1.5;

scale=50;

r_Eve_Array=linspace(5,25,scale);
P_T_dBm_Array=(linspace(0,25,scale))';

%Calculate Key-Creation Rate(Rf)
v1=ones(length(r_Eve_Array),1);
v2=ones(length(P_T_dBm_Array),1);
X_r_Eve_Array=v1*r_Eve_Array;
Y_P_T_dBm_rray=P_T_dBm_Array*v2';

Rf_Mbps3D=calculateFinalKeyCreationRate_QPSK3D(X_r_Eve_Array,Y_P_T_dBm_rray);

%Plot function Final Key Creation Rate versus Eve-Bob distance and Transmitted Power
figure(1)
%surfc(X_r_Eve_Array,Y_P_T_dBm_rray,Rf_Mbps3D);
contourf(X_r_Eve_Array,Y_P_T_dBm_rray,Rf_Mbps3D);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Eve-Bob distance, l_{EB} (m)');
ylabel('Transmitted power R_{T} (dBm)');
zlabel('Ergodic secret-key rate, S (bits/s/Hz)');
title('Final key creation rate (R_{f})','FontWeight','Normal');
% axis([0,100,0,3,-0.4,0.4]);
colorbar
colormap('jet');

figure(2)
surfc(X_r_Eve_Array,Y_P_T_dBm_rray,Rf_Mbps3D);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Eve-Bob distance, l_{EB} (m)');
ylabel('Transmitted power R_{T} (dBm)');
zlabel('Ergodic secret-key rate, S (bits/s/Hz)');
% title('Final key creation rate (R_{f}) versus Eve-Bob distance (r) and transmitted power (P_{T})');
axis([min(r_Eve_Array),max(r_Eve_Array),min(P_T_dBm_Array),max(P_T_dBm_Array),0,900]);
colorbar
colormap('jet');
