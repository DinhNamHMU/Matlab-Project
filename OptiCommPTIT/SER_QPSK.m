%Krishna
%Symbol error rate for QPSK(4-QAM) modulation
clear;
clc;
N=10^5;                                       %Number of symbols
Es_N0_dB=[-3:20];                             %Multiple Eb/N0 values
ipHat=zeros(1,N);
for ii=1:length(Es_N0_dB)
    ip=(2*(rand(1,N)>0.5)-1)+j*(2*(rand(1,N)>0.5)-1);
    s=(1/sqrt(2))*ip;                         %Normalization of energy to 1
    n=1/sqrt(2)*[randn(1,N)+j*randn(1,N)];    %White guassian noise, 0dB variance
    y=s+10^(-Es_N0_dB(ii)/20)*n;              %Additive white gaussian noise
    %Demodulation
    y_re=real(y);                             %Real
    y_im=imag(y);                             %Imaginary
    ipHat(find(y_re<0 & y_im<0))=(-1)+(-1)*j;
    ipHat(find(y_re>=0 & y_im>0))=1+1*j;
    ipHat(find(y_re<0 & y_im>=0))=(-1)+1*j;
    ipHat(find(y_re>=0 & y_im<0))=1-1*j;
    nErr(ii)=size(find([ip-ipHat]),2);        %Couting the number of errors
end
simSer_QPSK=nErr/N;
theorySer_QPSK=erfc(sqrt(0.5*(10.^(Es_N0_dB/10))))-(1/4)*(erfc(sqrt(0.5*(10.^(Es_N0_dB/10))))).^2;

%PLot function
close all;
figure;
semilogy(Es_N0_dB,theorySer_QPSK,'b.-');
hold on;
semilogy(Es_N0_dB,simSer_QPSK,'mx-');
axis([-3 15 10^-5 1])
grid on;
legend('theory-QPSK', 'simulation-QPSK');
xlabel('Es/No, dB')
ylabel('Symbol Error Rate')
title('Symbol error probability curve for QPSK(4-QAM)')


