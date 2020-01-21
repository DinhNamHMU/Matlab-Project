% final overall system BER calculation is simulation image rendering
global Dr;
global Ts;
global Pt;
Pt=1;
%global Ts;
m=[(1/1)*10^-8,0.5*10^-8,(1/2.5)*10^-9];
Ts=m(1);

BER=zeros(1,30);
i=1;
for Dr=0.05:0.05:1.5
    BER(i)=(quadl('bef2',0,10^-8));  %BDPSK
    BER1(i)=(quadl('report_1',0,10^-7));  %OOK
    %BER2(i)=(quadl('bef3',0,10^-7)); %QDPSK
    i=i+1;
end

P1=0.05:0.05:1.5;
%figure,
semilogy(P1,BER,'--');
hold on 
semilogy(P1,BER1,'*');
xlabel('Dr/m')
ylabel('BER')