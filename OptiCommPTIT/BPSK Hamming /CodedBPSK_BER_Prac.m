%By Khashayar Namdar
%University of Western Ontario
%Computer and Electrical Engineering Department
%For Digital Modulation and Coding Course
%Professor Raveendra K. Rao
%Summer 2018
%(7,4) Hamming Code + BPSK

clear;
clc;
close all; 

k=4;
n=7;
Tb=0.1; %1 ms
Eb=1; %Just for test
SR=1;% Sample Rate (1 samples per Tb)
fc=1/Tb;
p=[1 1 0 ; 0 1 1; 1 1 1; 1 0 1];
t=0:(1/SR)*Tb:Tb*n-(1/SR)*Tb;
%-(1/SR)*Tb adjusts the dimensions of t
fi1=sqrt(2/Tb).*cos(2*pi*fc*t);
EbtoN0=10;
tic
for j=1:41
%z=100*floor(1/(0.5*erfc(sqrt(10^(0.1*EbtoN0)))));
%if z>10000000
%    z=10000000;
%end
Errcnt=0;    
    for i=1:1000 %z
        x = randi([0 1],1,k);
        codewords=encoder(x,n,k,p);
        S=modulator(codewords,fi1,t,Eb,n);
        noisyS=channel(S,EbtoN0,Eb/Tb);
        rS=demodulator(noisyS,fi1,t,Tb,SR,n);
        rmessage=decoder(rS,n,k,p);
        %if x(1)~=rmessage(1)|x(2)~=rmessage(2)|x(3)~=rmessage(3)|x(4)~=rmessage(4)
        %    Errcnt=Errcnt+1;
        %end
        if x(1)~=rmessage(1)
            Errcnt=Errcnt+1;
        end
        if x(2)~=rmessage(2)
            Errcnt=Errcnt+1;
        end
        if x(3)~=rmessage(3)
            Errcnt=Errcnt+1;
        end
        if x(4)~=rmessage(4)
            Errcnt=Errcnt+1;
        end
        %if mod(i,100000)==0
        %    disp(i)
        %end
    end
disp(j);
Ebplot(42-j)=EbtoN0;
Pprac(42-j)=Errcnt/(i*k);
Ptheor(42-j)=0.5*erfc(sqrt((7/4)*10^(0.1*EbtoN0)));
Ptheor2(42-j)=0.5*erfc(sqrt(10^(0.1*EbtoN0)));
EbtoN0=EbtoN0-0.25;
end
toc
semilogy(Ebplot,Ptheor);
hold on
semilogy(Ebplot,Ptheor2);
hold on
semilogy(Ebplot,Pprac);
legend('Ptheor','Ptheor2','Pprac');
grid on