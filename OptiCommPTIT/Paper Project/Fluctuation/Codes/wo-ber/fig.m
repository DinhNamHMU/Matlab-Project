I1=zeros(1,46);
I2=zeros(1,46);
I3=zeros(1,46);

BER1=zeros(1,46);
BER2=zeros(1,46);
BER3=zeros(1,46);

global dr01;
global Ts;
global Pt;
Pt=0.8;
%global Ts;
m=[(1/1)*10^-8,0.5*10^-8,(1/2.5)*10^-9];
Ts=m(1);
i=1;
for dr01=0.1:0.02:1;
x=0;
y=0;
for n=-10:10
    a=2*n*pi-0.5*pi;
    b=2*n*pi+0.5*pi;
x=x+dblquad('ber1',0.00000000001,10^-8,a,b);
end
for n=-10:10
    a=2*n*pi-1.5*pi;
    b=2*n*pi-0.5*pi;
y=y+dblquad('ber2',0.00000000001,10^-8,a,b) ;
end
I1(i)=x+y;
i=i+1;
end
i=1;
for dr01=0.1:0.02:1;
  BER1(i)=quadl('bef2',0.0000000001,1*10^(-8)); 
    i=i+1;
end
%%%%%%2
Ts=m(2);
i=1;
for dr01=0.1:0.02:1; 
x=0;
y=0;
for n=-10:10
    a=2*n*pi-0.5*pi;
    b=2*n*pi+0.5*pi;
x=x+dblquad('ber1',0.00000000001,10^-8,a,b);
end
for n=-10:10
    a=2*n*pi-1.5*pi;
    b=2*n*pi-0.5*pi;
y=y+dblquad('ber2',0.00000000001,10^-8,a,b) ;
end
I2(i)=x+y;
i=i+1;
end
i=1;
for dr01=0.1:0.02:1;
  BER2(i)=quadl('bef2',0.0000000001,1*10^(-8)); 
    i=i+1;
end
%%%%%%%3
Ts=m(3);
i=1;
for dr01=0.1:0.02:1;
x=0;
y=0;
for n=-10:10
    a=2*n*pi-0.5*pi;
    b=2*n*pi+0.5*pi;
x=x+dblquad('ber1',0.00000000001,10^-8,a,b);
end
for n=-10:10
    a=2*n*pi-1.5*pi;
    b=2*n*pi-0.5*pi;
y=y+dblquad('ber2',0.00000000001,10^-8,a,b) ;
end
I3(i)=x+y;
i=i+1;
end
i=1;
for dr01=0.1:0.02:1;
  BER3(i)=quadl('bef2',0.0000000001,1*10^(-8)); 
    i=i+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%Output
P1=0.1:0.02:1;
%semilogy(P1,I1,'-*');

QX=semilogy(P1,I1,'-sr',P1,I2,'-pm',P1,I3,'-*k',P1,BER1,'-^r',P1,BER2,'-om',P1,BER3,'->k');
xlabel('Wo');
ylabel('BER');
set(QX,'LineWidth',2.0);  %Thicken the curve in the figure, 1.0 indicates the thickness of the line
%set(gca,'box','off','Ytick',[])
legend('Consider phase fluctuations100M','Consider phase fluctuation 200M','Consider phase fluctuation 2.5G','Do not consider phase fluctuations 100M','Do not consider phase fluctuation 200M','Do not consider phase fluctuation 2.5G');
legend('boxoff');
box off
%P1=0.1:0.1:4;
%plot(P1,I);


