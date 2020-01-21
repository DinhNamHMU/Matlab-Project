%BER of BPSK Heterodyne System with Phase Noise
clear
clc
%Simulation Parameters
gValue=[10,100,10000]; %Multiply coefficient
Ps_dBm=[-5:0.5:18];

BER1=calculateBER(Ps_dBm,gValue(1));
BER2=calculateBER(Ps_dBm,gValue(2));
BER3=calculateBER(Ps_dBm,gValue(3));

%Plot function
close all
semilogy(Ps_dBm,BER1,'b.-',Ps_dBm,BER2,'-om',Ps_dBm,BER3,'-*k');
grid on
hold on
xlabel('Ps (dBm)');
ylabel('BER (LOG)');
title('BER of BPSK Heterodyne System with Phase Noise');
legend('BER with M=10','BER with M=100','BER with M=10000');


