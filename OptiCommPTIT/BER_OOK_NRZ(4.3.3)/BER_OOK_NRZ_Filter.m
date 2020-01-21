%BER of OOK-NRZ Using Matched Filter-Based Receiver
clear;
clc;
close all;
q=1.6e-19;
% Charge of Electron
Ib=202e-6;
% Background Noise Current+interfernce
N0=2*q*Ib;
% Noise Spectral Density, 2*q*Ib
Rb=1e6;
% bit rate.
Tb=1/Rb;
% bit duration
R=1;
% Receiver responsivity.
sig_length=1e5;
% No. of bits in the input OOK symbols.
snr_dB=0:9;
% signal-to-noise ratio in dB.
SNR=10.^(snr_dB./10);
% signal-to-noise ratio
for i=1:length(snr_dB)
    P_avg(i)=sqrt(N0*Rb*SNR(i)/(2*R^2));
    % average optical power
    i_peak(i)=2*R*P_avg(i);
    % peak photocurrent
    Ep(i)=i_peak(i)^2*Tb;
    % Peak Energy
    sgma(i)=sqrt(N0*Ep(i)/2);
    % sigma, standard deviation of noise after matched filter
    th=0.5*Ep(i);
    % threshold level
    %Tx=randint(1,sig_length);
    Tx=randi([0,1],[1,sig_length]);
    % transmitted bit
    for j=1 : sig_length;
    MF(j)=Tx(j)*Ep(i)+gngauss(sgma(i));
    %matched filter output
    end
    Rx=zeros(1,sig_length);
    Rx(find(MF>th))=1;
    %threshold detection
    [No_of_Error(i) ber(i)]=biterr(Tx,Rx);
end
