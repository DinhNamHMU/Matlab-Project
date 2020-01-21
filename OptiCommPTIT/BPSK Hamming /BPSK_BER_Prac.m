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

k=1;
n=1;
Tb=0.1; %1 ms
Eb=1; %Just for test
SR=1; % Sample Rate (1 samples per Tb)
fc=1/Tb;
t=0:(1/SR)*Tb:Tb*n-(1/SR)*Tb;
%-(1/SR)*Tb adjusts the dimensions of t
fi1=sqrt(2/Tb).*cos(2*pi*fc*t);
EbtoN0=12;
tic
for j=1:49
% z=100*floor(1/(0.5*erfc(sqrt(10^(0.1*EbtoN0)))));
% if z>10000000
%    z=10000000;
% end
z=1000;
Errcnt=0;    
    for i=1:z
        x = randi([0 1],1,k);
        S=modulator(x,fi1,t,Eb,n);
        noisyS=channel(S,EbtoN0,Eb/Tb);
        rS=demodulator(noisyS,fi1,t,Tb,SR,n);
        if x~=rS
            Errcnt=Errcnt+1;
        end
        %if mode(i,100000)==0
        %    disp(i)
        %end
    end
disp(j);
Ebplot(50-j)=EbtoN0;
Pprac(50-j)=Errcnt/i;
Ptheor(50-j)=0.5*erfc(sqrt(10^(0.1*EbtoN0)));
EbtoN0=EbtoN0-0.25;
end
toc
semilogy(Ebplot,Ptheor);
hold on
semilogy(Ebplot,Pprac); 
legend('Ptheor','Pprac');
grid on