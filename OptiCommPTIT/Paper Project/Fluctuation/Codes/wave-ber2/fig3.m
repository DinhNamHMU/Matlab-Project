% final overall system BER calculation is simulation image rendering
%global Pt;
global Pt;
global Ts;
%Pt=1;
BER1=zeros(1,41);
BER2=zeros(1,41);
BER3=zeros(1,41);
m=[10^-8,1*10^-9,(1/10)*10^-9];
i=1;
Ts=m(3);
for Pt=0:0.1:4
    
    BER1(i)=(quadl('report_1',0,10^(-8)));  %DPSK
  
    i=i+1;
end

P1=0:0.1:4;
semilogy(P1,BER1,'-^');%DPSK
%legend('3','2','1');
xlabel('P/W')
ylabel('BER')