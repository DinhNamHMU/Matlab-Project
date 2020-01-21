%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
global C2n_Weak;
global C2n_Strong;

C2n_Weak=7*10^-15;     %Refractive index structure coefficient
C2n_Strong=10^-13;

MArray=[1,2,3,4,5,6,7,8,9,10,11]; %Maximum number of transmissions
B=10;                  %BS buffer size
ScaleCo=0:0.2:4;

%Calculate Key loss rate via Gamma-Gamma Channels
%Weak turbulences
QBER_Gamma_Weak=zeros(1,length(ScaleCo));
P_sift_Gamma_Weak=zeros(1,length(ScaleCo));

keyLossRate_Gamma_Weak1=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Weak2=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Weak3=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Weak4=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Weak5=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Weak6=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Weak7=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Weak8=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Weak9=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i)]=calculateQBER(ScaleCo(i),C2n_Weak);
    
    [keyLossRate_Gamma_Weak1(i)]=calculateKeyLossRate(MArray(1),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    [keyLossRate_Gamma_Weak2(i)]=calculateKeyLossRate(MArray(2),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    [keyLossRate_Gamma_Weak3(i)]=calculateKeyLossRate(MArray(3),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));  
    [keyLossRate_Gamma_Weak4(i)]=calculateKeyLossRate(MArray(4),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    [keyLossRate_Gamma_Weak5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    [keyLossRate_Gamma_Weak6(i)]=calculateKeyLossRate(MArray(6),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    [keyLossRate_Gamma_Weak7(i)]=calculateKeyLossRate(MArray(7),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    [keyLossRate_Gamma_Weak8(i)]=calculateKeyLossRate(MArray(8),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
    [keyLossRate_Gamma_Weak9(i)]=calculateKeyLossRate(MArray(9),B,QBER_Gamma_Weak(i),P_sift_Gamma_Weak(i));
end

%Strong turbulence
QBER_Gamma_Strong=zeros(1,length(ScaleCo));
P_sift_Gamma_Strong=zeros(1,length(ScaleCo));

keyLossRate_Gamma_Strong1=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong2=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong3=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong4=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong5=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong6=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong7=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong8=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong9=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong10=zeros(1,length(ScaleCo));
keyLossRate_Gamma_Strong11=zeros(1,length(ScaleCo));

for i=1:length(ScaleCo) 
    [QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i)]=calculateQBER(ScaleCo(i),C2n_Strong);
    
    [keyLossRate_Gamma_Strong1(i)]=calculateKeyLossRate(MArray(1),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong2(i)]=calculateKeyLossRate(MArray(2),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong3(i)]=calculateKeyLossRate(MArray(3),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));  
    [keyLossRate_Gamma_Strong4(i)]=calculateKeyLossRate(MArray(4),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong5(i)]=calculateKeyLossRate(MArray(5),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong6(i)]=calculateKeyLossRate(MArray(6),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong7(i)]=calculateKeyLossRate(MArray(7),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong8(i)]=calculateKeyLossRate(MArray(8),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong9(i)]=calculateKeyLossRate(MArray(9),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong10(i)]=calculateKeyLossRate(MArray(10),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
    [keyLossRate_Gamma_Strong11(i)]=calculateKeyLossRate(MArray(11),B,QBER_Gamma_Strong(i),P_sift_Gamma_Strong(i));
end

%Plot function of the key loss rate via Gamma-Gamma Channels
%Weak turbulence
figure(1)
semilogy(ScaleCo,keyLossRate_Gamma_Weak1,'b-',ScaleCo,keyLossRate_Gamma_Weak2,'r--',ScaleCo,keyLossRate_Gamma_Weak3,'kd-',ScaleCo,keyLossRate_Gamma_Weak4,'g+-',ScaleCo,keyLossRate_Gamma_Weak5,'m-*',ScaleCo,keyLossRate_Gamma_Weak6,'c-o',ScaleCo,keyLossRate_Gamma_Weak7,'k-s',ScaleCo,keyLossRate_Gamma_Weak8,'b-x',ScaleCo,keyLossRate_Gamma_Weak9,'y-','LineWidth',1.5);
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4','QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','QKD-KR, M = 8');
title('(a) Weak turbulence C^2_{n}=7x10^{-15} (m^{-2/3})');
axis([0,4,1.e-6,1.e-0]);

%Strong turbulence
figure(2)
semilogy(ScaleCo,keyLossRate_Gamma_Strong1,'b-',ScaleCo,keyLossRate_Gamma_Strong2,'r--',ScaleCo,keyLossRate_Gamma_Strong3,'kd-',ScaleCo,keyLossRate_Gamma_Strong4,'g+-',ScaleCo,keyLossRate_Gamma_Strong5,'m-*',ScaleCo,keyLossRate_Gamma_Strong6,'c-o',ScaleCo,keyLossRate_Gamma_Strong7,'k-s',ScaleCo,keyLossRate_Gamma_Strong8,'b-x',ScaleCo,keyLossRate_Gamma_Strong9,'y-',ScaleCo,keyLossRate_Gamma_Strong10,'r-',ScaleCo,keyLossRate_Gamma_Strong11,'g-','LineWidth',1.5);
grid on
xlabel('D-T scale coefficient, \xi');
ylabel('Key loss rate, KLR');
legend('Conventional QKD','QKD-KR, M = 1', 'QKD-KR, M = 2', 'QKD-KR, M = 3', 'QKD-KR, M = 4','QKD-KR, M = 5','QKD-KR, M = 6','QKD-KR, M = 7','QKD-KR, M = 8','QKD-KR, M = 9','QKD-KR, M = 10');
title('(b) Strong turbulence C^2_{n}=10^{-13} (m^{-2/3})');
axis([0,4,1.e-6,1.e-0]);