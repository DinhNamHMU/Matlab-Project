%SANJEET KUMAR
%M.Tech(Telecommunication)
%Calculate BER of QPSK Coherent Systems

clear;
echo on
SNRdb1=0:2:10;
SNRdb2=0:0.1:10;
smldbiterrprb=zeros(1,length(SNRdb1));
smldsymbolerrprb =zeros(1,length(SNRdb1));
for i=1:length(SNRdb1)
    [pb,ps]=cmsm(SNRdb1(i));
    smldbiterrprb(i)=smldbiterrprb(i)+pb;
    smldsymbolerrprb(i)=smldsymbolerrprb(i)+ps;
    echo off;
end
echo on;
theorerrprb=zeros(1,length(SNRdb2));
for i=1:length(SNRdb2)
    SNR=exp(SNRdb2(i)*log(10)/10);
    theorerrprb(i)=theorerrprb(i)+qfunc(sqrt(2*SNR));
    echo off;
end
echo on;
semilogy(SNRdb1,smldbiterrprb,'*');
hold all
semilogy(SNRdb1,smldsymbolerrprb,'+');
hold all
semilogy(SNRdb2,theorerrprb,'--');
title('Probability of Error Performance')
xlabel('SNR in db')
ylabel('Probability of error')