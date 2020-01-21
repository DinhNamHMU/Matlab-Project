%Krishna Pillai
%BER BPSK
clear;
clc;
N=10^6;                                        %Number of bits or symbols
rand('state',100);                             %Initializing the rand() function
randn('state',200);                            %Initializing the randn() function

% Transmitter
ip=rand(1,N)>0.5;                              %Generating 0,1 with equal probability
s=2*ip-1;                                      %BPSK modulation 0 -> -1; 1 -> 1 
n=1/sqrt(2)*[randn(1,N)+j*randn(1,N)];         %White gaussian noise, 0dB variance 
Eb_N0_dB=[-3:10];                              %Multiple Eb/N0 values

for ii=1:length(Eb_N0_dB)
   %Noise addition
   y=s+10^(-Eb_N0_dB(ii)/20)*n;                %Additive white gaussian noise
   %Receiver - hard decision decoding
   ipHat=real(y)>0;
   %Counting the errors
   nErr(ii) = size(find([ip- ipHat]),2);
end
simBer = nErr/N;                               %Simulated ber
theoryBer = 0.5*erfc(sqrt(10.^(Eb_N0_dB/10))); %Theoretical ber

%Plot function
close all
figure
semilogy(Eb_N0_dB,theoryBer,'b.-');
hold on
semilogy(Eb_N0_dB,simBer,'mx-');
axis([-3 10 10^-5 0.5])
grid on
legend('theory', 'simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for BPSK modulation');

