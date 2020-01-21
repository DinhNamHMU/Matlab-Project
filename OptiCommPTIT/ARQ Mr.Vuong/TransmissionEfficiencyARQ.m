%Transmission efficiency of ARQ protocols versus Probability of a bit error
%and Number of bits in the information frame
clear;
clc
%Prameters
nfOpt=8192;                                   %Number of bits in the information frame with optimal value (bit)
Ws=4;                                         %Number of frame in slide window (frame)
n0=64;                                        %Number of overhead bits in a frame (bit)
na=64;                                        %Number of bits in the acknowledgment frame (bit)
R=1.5*10^6;                                   %Bit rate (bps)
sum_tProp_tProc=5*10^-3;                      %Sum of tProp and tProc(s)
pOpt=10^-4;                                   %Probability of a bit error with optimal value

p=[0:5.e-05:1.e-03];                          %Probability of a bit error
nf=[32:60:2048];                              %Number of bits in the information frame (bit)

%Calculate Transmission efficiency versus Probability of a bit error
for i=1:length(p)
    Pf=1-(1-p).^nfOpt;
    t0=2*sum_tProp_tProc+nfOpt/R+na/R;        %Basic delay
    eta0=((nfOpt-n0)/t0)/R;
    eta_SAW=(1-Pf)*eta0;
    eta_GBN=(1-Pf)*(1-n0/nfOpt)./(1+(Ws-1)*Pf);
    eta_SR=(1-Pf)*(1-n0/nfOpt);
end

%Calculate Transmission efficiency versus Number of bits in the information frame
for i=1:length(nf) 
    Pf=1-(1-pOpt).^nf;
    t0=2*sum_tProp_tProc+nf/R+na/R;           %Basic delay
    eta0=((nf-n0)./t0)/R;
    eta_SAW1=(1-Pf).*eta0;
    eta_GBN1=(1-Pf).*(1-n0./nf)./(1+(Ws-1)*Pf);
    eta_SR1=(1-Pf).*(1-n0./nf);
end

%Plot function of Transmission efficiency versus Probability of a bit error
figure
grid on
plot(p,eta_SAW,'b--',p,eta_GBN,'r-',p,eta_SR,'g-');
axis([0,1.e-03,0,1]);
set(gca, 'XDir','reverse');
xlabel('p','FontSize',15);
ylabel('\eta','FontSize',15);
set(get(gca,'ylabel'),'rotation',0);
legend('Stop and Wait','Go Back N','Selective Repeat');
title('Transmission efficiency of ARQ protocol','FontSize',13);

%Plot function of Transmission efficiency versus Number of bits in the information frame
figure
grid on
plot(nf,eta_SAW1,'b--',nf,eta_GBN1,'r-',nf,eta_SR1,'g-');
axis([32,2048,0,1]);
xlabel('nf','FontSize',15);
ylabel('\eta','FontSize',15);
set(get(gca,'ylabel'),'rotation',0);
legend('Stop and Wait','Go Back N','Selective Repeat');
title('Transmission efficiency of ARQ protocol','FontSize',13);
