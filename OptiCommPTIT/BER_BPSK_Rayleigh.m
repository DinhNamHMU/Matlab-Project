%Krishna Pillai
%Script for computing the BER for BPSK modulation in a Rayleigh fading channel
clear;
N=10^6;                                            %Number of bits or symbols
% Transmitter
ip=rand(1,N)>0.5;                                  %Generating 0,1 with equal probability
s=2*ip-1;                                          %BPSK modulation 0 -> -1; 1 -> 0 
Eb_N0_dB=[-3:35];                                  %Multiple Eb/N0 values

for ii=1:length(Eb_N0_dB)
   n=1/sqrt(2)*[randn(1,N)+j*randn(1,N)];          %White gaussian noise, 0dB variance 
   h=1/sqrt(2)*[randn(1,N)+j*randn(1,N)];          %Rayleigh channel
   %Channel and noise Noise addition
   y=h.*s+10^(-Eb_N0_dB(ii)/20)*n; 
   %Equalization
   yHat=y./h;
   %Receiver-Hard decision decoding
   ipHat=real(yHat)>0;
   %Counting the errors
   nErr(ii)=size(find([ip-ipHat]),2);
end
simBer = nErr/N;                                   %Simulated BER
theoryBerAWGN = 0.5*erfc(sqrt(10.^(Eb_N0_dB/10))); %Theoretical BER
EbN0Lin = 10.^(Eb_N0_dB/10);
theoryBer = 0.5.*(1-sqrt(EbN0Lin./(EbN0Lin+1)));

%Plot function
close all
figure
semilogy(Eb_N0_dB,theoryBerAWGN,'cd-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,theoryBer,'bp-','LineWidth',2);
semilogy(Eb_N0_dB,simBer,'mx-','LineWidth',2);
axis([-3 35 10^-5 0.5])
grid on
legend('AWGN-Theory','Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation in Rayleigh channel');








