%Calculate Eve's Error Probability of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with BPSK scheme
clear;
clc;

%Simulation Parameters
global C2n_1;   %Refractive index structure coefficient 
global C2n_2;
C2n_1=5*10^-14;
C2n_2=10^-13;
g=15;           %Average APD gain 

ModDepth=0:0.01:1;

%Calculate Eve's Error Probability
e_Log=zeros(1,length(ModDepth));
e_Gamma1=zeros(1,length(ModDepth));
e_Gamma2=zeros(1,length(ModDepth));

for i=1:length(ModDepth)
    [e_Log(i),e_Gamma1(i),e_Gamma2(i)]=calculateEveErrorProbability(ModDepth(i),g);
end

%Plot function of Log-Normal Channels and Gamma-Gamma Channels
figure(1)
plot(ModDepth,e_Log,'b-',ModDepth,e_Gamma1,'g--',ModDepth,e_Gamma2,'r--');
grid on
xlabel('Intensity modulation depth');
ylabel('Eves error probability');
title('Eves error probability (e) versus intensity modulation depth');
legend('C^2_{n}=10^{-15}','C^2_{n}=5x10^{-14}','C^2_{n}=10^{-13}');
axis([0,1,0.03,0.5]);