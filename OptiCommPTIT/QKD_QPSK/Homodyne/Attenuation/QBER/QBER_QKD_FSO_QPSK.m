%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with QPSK scheme and
%Heterodyne Detection Reciver
clear;
clc;
%Simulator Parameters
ScaleCoArr=[0:0.1:4];  %Threshold scale coefficient
ScaleCo=1.5;
P_T_dBm=0;             %Transmitted power(dBm)-> Value=0||5
P_T_dBmArr=[-10:1:10];
global P_LO_dBm;       %Power of Local Oscillator(dBm)
P_LO_dBm=0;

QBER1=zeros(1,length(ScaleCoArr));
P_sift1=zeros(1,length(ScaleCoArr));
QBER2=zeros(1,length(P_T_dBmArr));
P_sift2=zeros(1,length(P_T_dBmArr));
QBER3=zeros(1,length(P_T_dBmArr));
P_sift3=zeros(1,length(P_T_dBmArr));

%Calculate QBER
for i=1:length(ScaleCoArr)
    [QBER1(i),P_sift1(i)]=calculateQBER_QPSK(ScaleCoArr(i),P_T_dBm);
end
for i=1:length(P_T_dBmArr) 
    [QBER2(i),P_sift2(i)]=calculateQBER_QPSK(ScaleCo,P_T_dBmArr(i));
end
for i=1:length(P_T_dBmArr)
    [QBER3(i),P_sift3(i)]=calculateQBER_QPSK_DD(ScaleCo,P_T_dBmArr(i));
end

%Plot function of QBER versus Threshold scale coefficient
figure(1)
semilogy(ScaleCoArr,QBER1,'b-o',ScaleCoArr,P_sift1,'r-*');
grid on
xlabel('Threshold scale coefficient, p');
ylabel('Probability');
title(['QBER and P_{sift} versus the threshold scale coefficient (p) with P_{LO}=',num2str(P_LO_dBm),' (dBm)']);
legend('QBER','P_{sift}');
axis([0,4,1.e-4,1.e-0]);

%Plot function of BER versus Transmitted power
figure
semilogy(P_T_dBmArr,QBER2,'b-o',P_T_dBmArr,P_sift2,'b-*');
hold on
grid on
semilogy(P_T_dBmArr,QBER3,'r-o',P_T_dBmArr,P_sift3,'r-*');
xlabel('Transmitted power, P_{T} (dBm)');
ylabel('Probability');
title(['QBER and P_{sift} versus the transmitted power with p=',num2str(ScaleCo)]);
legend('QBER Heterodyne','P_{sift} Heterodyne','QBER Direct Detection','P_{sift} Direct Detection','Location','southwest');
axis([-10,10,1.e-4,1.e-0]);