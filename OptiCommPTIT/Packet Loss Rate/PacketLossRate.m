%Calculate the packet loss rate of TFRC over wireless link with truncated link-level ARQ
%Performance Analysis of TFRC over Wireless Link with Truncated Link-Level
%ARQ-Hong Shen
clear;
clc;

%Parameters Simulation
MArray=[1,2,3,4,5]; %Maximum number of transmissions
B=10;               %BS buffer size
v=0.1:1:31;

%Calculate Packet loss rate, Link utilization, Average length of burst errors, Delay outage rate.
packetLossRate1=zeros(1,length(v));
packetLossRate2=zeros(1,length(v));
packetLossRate3=zeros(1,length(v));
packetLossRate4=zeros(1,length(v));
packetLossRate5=zeros(1,length(v));

U1=zeros(1,length(v));
U2=zeros(1,length(v));
U3=zeros(1,length(v));
U4=zeros(1,length(v));
U5=zeros(1,length(v));

lb1=zeros(1,length(v));
lb2=zeros(1,length(v));
lb3=zeros(1,length(v));
lb4=zeros(1,length(v));
lb5=zeros(1,length(v));

delayOutageRate2=zeros(1,length(v));
delayOutageRate3=zeros(1,length(v));
delayOutageRate4=zeros(1,length(v));
delayOutageRate5=zeros(1,length(v));

for i=1:length(v)
    [packetLossRate1(i),U1(i),lb1(i)]=calculatePacketLossRate(v(i),MArray(1),B);
    [packetLossRate2(i),U2(i),lb2(i),delayOutageRate2(i)]=calculatePacketLossRate(v(i),MArray(2),B);
    [packetLossRate3(i),U3(i),lb3(i),delayOutageRate3(i)]=calculatePacketLossRate(v(i),MArray(3),B);
    [packetLossRate4(i),U4(i),lb4(i),delayOutageRate4(i)]=calculatePacketLossRate(v(i),MArray(4),B);
    [packetLossRate5(i),U5(i),lb5(i),delayOutageRate5(i)]=calculatePacketLossRate(v(i),MArray(5),B);
end

%Plot function of the packet loss rate
figure(1)
semilogy(v,packetLossRate1,'b-',v,packetLossRate2,'r--',v,packetLossRate3,'k:',v,packetLossRate4,'g-+',v,packetLossRate5,'m-*');
grid on
xlabel('Velocity of the mobile host (m/s)');
ylabel('Packet loss rate');
legend(['M=',num2str(MArray(1)),' analysis'],['M=',num2str(MArray(2)),' analysis'],['M=',num2str(MArray(3)),' analysis'],...
       ['M=',num2str(MArray(4)),' analysis'],['M=',num2str(MArray(5)),' analysis']);
title('Packet loss rate, t = 20ms');
axis([1,30,1.e-3,1.e-0]);

%Plot function of the average length of burst errors
figure(2)
grid on
plot(v,lb1,'b-',v,lb2,'r--',v,lb3,'k:',v,lb4,'g-+',v,lb5,'m-*');
xlabel('Velocitv of the mobile host (m/s)');
ylabel('Average length of burst errors (packets)');
legend(['M=',num2str(MArray(1)),' analysis'],['M=',num2str(MArray(2)),' analysis'],['M=',num2str(MArray(3)),' analysis'],...
       ['M=',num2str(MArray(4)),' analysis'],['M=',num2str(MArray(5)),' analysis']);
title('Average length of burst errors (packets), t = 20ms');
axis([1.5,30,0,10]);

%Plot function of the link utilization
figure(3)
grid on
plot(v,U1,'b-',v,U2,'r--',v,U3,'k:',v,U4,'g-+',v,U5,'m-*');
xlabel('Velocitv of the mobile host (m/s)');
ylabel('Link utilization');
legend(['M=',num2str(MArray(1)),' analysis'],['M=',num2str(MArray(2)),' analysis'],['M=',num2str(MArray(3)),' analysis'],...
       ['M=',num2str(MArray(4)),' analysis'],['M=',num2str(MArray(5)),' analysis']);
title('Link utilization, t = 20ms');
axis([1,30,0,1]);

%Plot function of the delay outage rate
figure(4)
grid on
semilogy(v,delayOutageRate2,'r--',v,delayOutageRate3,'k:',v,delayOutageRate4,'g-+',v,delayOutageRate5,'m-*');
xlabel('Velocitv of the mobile host (m/s)');
ylabel('Delay outage rate');
legend(['M=',num2str(MArray(2)),' analysis'],['M=',num2str(MArray(3)),' analysis'],...
       ['M=',num2str(MArray(4)),' analysis'],['M=',num2str(MArray(5)),' analysis']);
title('Delay outage rate, t = 20ms');
axis([1,30,1.e-6,1.e-0]);