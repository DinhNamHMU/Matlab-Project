global fai;
ber2=zeros(1,20);
ber3=zeros(1,20);
ber4=zeros(1,20);
ber5=zeros(1,20);
ber6=zeros(1,20);
ber7=zeros(1,20);
m=linspace(5*10^-6,60*10^-6,20);
fai=0;
for i=1:20  
   ber2(i)=uplinkp(m(i));  
end
fai=pi/32;
for i=1:20 
  ber3(i)=uplinkp(m(i)); 
end
fai=pi/16;
for i=1:20 
  ber4(i)=uplinkp(m(i)); 
end
fai=pi/8;
for i=1:20 
  ber5(i)=uplinkp(m(i)); 
end
fai=3*pi/16;
for i=1:20 
  ber6(i)=uplinkp(m(i)); 
end
fai=pi/4;
for i=1:20 
  ber7(i)=uplinkp(m(i)); 
end
m1=linspace(5,60,20);
semilogy(m1,ber7,m1,ber6,m1,ber5,m1,ber4,m1,ber3,m1,ber2);
legend('����=��/4','����=3��/16','����=��/8','����=��/16','����=��/32','synchronizing');