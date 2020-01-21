% Simple Matlab/Octave code for coherent demodulation of differentially encoded binary phase shift keying (DBPSK)
clear;
N=10^6;                                              %Number of bits or symbols
rand('state',100);                                   %Initializing the rand() function
randn('state',200);                                  %Initializing the randn() function
ip=rand(1,N)>0.5;                                    %Generating 0,1 with equal probability 
ipD=mod(filter(1,[1 -1],ip),2);                      %Differential encoding y[n]=y[n-1]+x[n]
s=2*ipD-1;                                           %BPSK modulation 0 -> -1; 1 -> 1
n=1/sqrt(2)*[randn(1,N)+j*randn(1,N)];               %White gaussian noise, 0dB variance

Eb_N0_dB=[-3:10];                                    %Multiple Eb/N0 values
for ii=1:length(Eb_N0_dB)
    y=s+10^(-Eb_N0_dB(ii)/20)*n;                     %Additive white gaussian noise

    ipDHat_coh=real(y) > 0;                          %Coherent demodulation
    ipHat_coh=mod(filter([1 -1],1,ipDHat_coh),2);    %Differential decoding
    nErr_dbpsk_coh(ii)=size(find([ip-ipHat_coh]),2); %Counting the number of errors
end
simBer_dbpsk_coh=nErr_dbpsk_coh/N;
theoryBer_dbpsk_coh = erfc(sqrt(10.^(Eb_N0_dB/10))).*(1 - 0.5*erfc(sqrt(10.^(Eb_N0_dB/10))));

%Plot function
close all
figure
semilogy(Eb_N0_dB,theoryBer_dbpsk_coh,'b.-');
hold on
semilogy(Eb_N0_dB,simBer_dbpsk_coh,'mx-');
axis([-2 10 10^-6 0.5])
grid on
legend('theory', 'simulation');
xlabel('Eb/No, dB')
ylabel('Bit Error Rate')
title('Bit error probability curve for coherent demodulation of DBPSK')