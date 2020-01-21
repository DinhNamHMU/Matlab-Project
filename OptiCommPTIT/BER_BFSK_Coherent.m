%Krishna
%Simple Matlab example of Binary Frequency Shift Keying using coherent demodulation
clear;
N=10^5;                                                   %Number of bits or symbols
T=8;                                                      %Symbol duration
t=[0:1/T:0.99];                                           %Sampling instants
tR=kron(ones(1,N),t);                                     %Repeating the sampling instants 
Eb_N0_dB = [0:11];                                        %Multiple Eb/N0 values
for ii=1:length(Eb_N0_dB)
   %Generating the bits
   ip=rand(1,N)>0.5;                                      %Generating 0,1 with equal probability
   freqM=ip+1;                                            %Converting the bits into frequency,bit0 -> frequency of 1,bit1 -> frequency of 2
   freqR=kron(freqM,ones(1,T));                           %Repeating
   x=(sqrt(2)/sqrt(T))*cos(2*pi*freqR.*tR);               %Generating the FSK modulated signal 
   %Noise
   n=1/sqrt(2)*[randn(1,N*T)+j*randn(1,N*T)];             %White gaussian noise, 0dB variance 
   %Coherent receiver
   y=x+10^(-Eb_N0_dB(ii)/20)*n;                           %Additive white gaussian noise
   op1=conv(y, sqrt(2/T)*cos(2*pi*1*t));                  %Correlating with frequency 1
   op2=conv(y, sqrt(2/T)*cos(2*pi*2*t));                  %Correlating with frequency 2 
   %Demodulation
   ipHat = [real(op1(T+1:T:end)) < real(op2(T+1:T:end))]; %Explain
   nErr(ii) = size(find([ip - ipHat]),2);                 %Counting the number of errors 
end
simBer = nErr/N;
theoryBer = 0.5*erfc(sqrt((10.^(Eb_N0_dB/10))/2));        %Theoretical BER 

%Plot function
close all
figure
semilogy(Eb_N0_dB,theoryBer,'b-');
hold on
semilogy(Eb_N0_dB,simBer,'mx-');
axis([0 11 10^-4 0.5])
grid on
legend('theory:fsk-coh', 'sim:fsk-coh');
xlabel('Eb/No, dB')
ylabel('Bit Error Rate')
title('Bit error probability curve')
