%Calculate Eve's Error Probability of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with BPSK scheme
clear;
clc;

%Simulation Parameters 
global Rb; %Bit rate(bit/s)
global scale;

Rb=10^9;
scale=40;

ModDepthArray1=linspace(0,1,scale);
gArray=(linspace(0,40,scale))';

LArray=(linspace(1,2,scale));
ModDepthArray2=linspace(0,1,scale)';

%Calculate Eve's Error Probability versus Intensity modulaiton and APD gain
v1=ones(length(ModDepthArray1),1);
v2=ones(length(gArray),1);
X_ModDepthArray=v1*ModDepthArray1;
Y_gArray=gArray*v2';

f_e_Log=jointProbabiliteLogEve3D(0,1,X_ModDepthArray,Y_gArray)+jointProbabiliteLogEve3D(1,0,X_ModDepthArray,Y_gArray);

%Calculate Eve's Error Probability versus Intensity modulaiton and Eve's distance from Alice
v1=ones(length(LArray),1);
v2=ones(length(ModDepthArray2),1);
X_LArray=v1*LArray;
Y_ModDepthArray=ModDepthArray2*v2';

f_e_Gamma=jointProbabiliteGammaEve3D(0,1,X_LArray,Y_ModDepthArray)+jointProbabiliteGammaEve3D(1,0,X_LArray,Y_ModDepthArray);

%Plot function Eve's Error Probability versus Intensity modulaiton and APD gain
figure(1)
surfc(X_ModDepthArray,Y_gArray,f_e_Log);
xlabel('Intensity modulation depth');
ylabel('Eves average APD gain');
zlabel('Eves error probability');
title('Eves error probability versus intensity modulation depth and APD gain');
axis([0,1,0,40,0.2,0.5]);
colorbar;

%Plot function Eve's Error Probability versus Intensity modulaiton and Eve's distance from Alice
figure(2)
surfc(X_LArray,Y_ModDepthArray,f_e_Gamma);
set(gca,'XDir','reverse');
xlabel('Eve-Alice distance');
ylabel('Intensity modulation depth');
zlabel('Eves error probability');
title('Eves error probability versus intensity modulation depth and Eves distance from Alice');
axis([1,2,0,1,0,0.6]);
colorbar;