% final overall system BER calculation is simulation image rendering
%global Pt;
global Pt;
global Ts;
%Pt=1;
BER1=zeros(1,51);
BER2=zeros(1,51);
BER3=zeros(1,51);
m=[10^-8,1*10^-9,(1/10)*10^-9];
i=1;
Ts=m(1);
for theta=10*10^-6:10^-6:60*10^-6
    BER1(i)=(quadl('bef2',0,10^(-8)));  %DPSK
    i=i+1;
end

P1=10*10^-6:10^-6:60*10^-6;
semilogy(P1,BER1,'-^');%DPSK
%legend('3','2','1');
xlabel('P/W')
ylabel('BER')