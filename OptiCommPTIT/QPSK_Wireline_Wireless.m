% QPSK simulation over Rayleigh Fading wireless channel and its comparison with QPSK transmission over Wireline channel
clear;
clc;
SNRdB=1:1:12;                                  %SNR in dB
SNR=10.^(SNRdB/10);                            %SNR in linear Scale
bl=10^6;                                       %Number of bits transmitted
ber=zeros(1,length(SNRdB));                    %Simulated BER
x1=(2*floor(2*rand(1,bl)))-1; 
x2=(2*floor(2*rand(1,bl)))-1;
x=x1+1i*x2;                                    %Transmitted Symbols

%QPSK Transmission over AWGN Wireline Channel
parfor k=1:length(SNR)
    y=(sqrt(SNR(k))*x1)+randn(1,bl)+1i*((sqrt(SNR(k))*x2)+randn(1,bl));
    ber(k)=length(find((real(y).*x1)<0))+length(find((imag(y).*x2)<0));
end
ber=ber/bl;
%Plot function
figure
semilogy(SNRdB,ber,'k-<', 'linewidth' ,2.0);   %Simulated BER 
hold on
grid on
p=qfunc(sqrt(SNR));
semilogy(SNRdB,2*p-p.^2,'m-','linewidth',2.0); %Theoritical BER
legend('Simulated','Theoritical');
xlabel('SNR (dB)');
ylabel('BER');
title('BER of QPSK Transmission over AWGN Wireline Channel');

%QPSK over Rayleigh Fading Wireless Channel
parfor k=1:length(SNR)
    y=raylrnd(1/sqrt(2),1,bl).*(sqrt(SNR(k))*x1)+randn(1,bl)+1i*(raylrnd(1/sqrt(2),1,bl).*(sqrt(SNR(k))*x2)+randn(1,bl));
    ber(k)=length(find((real(y).*x1)<0))+length(find((imag(y).*x2)<0));
end
ber=ber/bl;
%Plot function
figure
semilogy(SNRdB,ber,'k-<', 'linewidth' ,2.0);    %Simulated BER 
hold on
grid on 
p=0.5*(1-(sqrt(SNR./(2+SNR))));
semilogy(SNRdB,2*p-p.^2,'r-','linewidth',2.0);  %Theoritical BER
legend('Simulated','Theoritical');
xlabel('SNR (dB)');
ylabel('BER');
title('QPSK over Wireline & Rayleigh Fading Wireless channel');xlabel('SNR(dB)');ylabel('BER');

