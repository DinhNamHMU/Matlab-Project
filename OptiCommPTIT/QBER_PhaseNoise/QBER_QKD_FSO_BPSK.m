%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Direct-Detection Receiver over Free-Space Optics with BPSK scheme
clear;
clc;
%Simulation Parameters 
ScaleCo=0:0.2:5;
ScaleCoArray=[1.2,2,2.35];
DampingCo=0.1:1:35;
DampingCoArray=[0.1,15,35];

%Calculate QBER via Log-Normal Channels and Gamma-Gamma Channels
QBER_Log=zeros(1,length(ScaleCo));
P_sift_Log=zeros(1,length(ScaleCo));
QBER_Gamma=zeros(1,length(ScaleCo));
P_sift_Gamma=zeros(1,length(ScaleCo));

for ii=1:length(ScaleCo)
    [QBER_Log(ii),P_sift_Log(ii),QBER_Gamma(ii),P_sift_Gamma(ii)]=calculateQBER(ScaleCo(ii));
end

%Calculate QBER via Log-Normal Channels with Phase Noise and PLL versus Scale Coefficient
for ii=1:length(ScaleCo)
    [QBER_Log_Phase1(ii),P_sift_Log_Phase1(ii)]=calculateQBER_PhaseNoise(ScaleCo(ii),DampingCoArray(1));
end
for ii=1:length(ScaleCo)
    [QBER_Log_Phase2(ii),P_sift_Log_Phase2(ii)]=calculateQBER_PhaseNoise(ScaleCo(ii),DampingCoArray(2));
end
for ii=1:length(ScaleCo)
    [QBER_Log_Phase3(ii),P_sift_Log_Phase3(ii)]=calculateQBER_PhaseNoise(ScaleCo(ii),DampingCoArray(3));
end

%Calculate QBER via Log-Normal Channels with Phase Noise and PLL versus Damping Coefficient
for ii=1:length(DampingCo) 
    [QBER_Log_Phase_Damping1(ii),P_sift_Log_Phase_Damping1(ii)]=calculateQBER_Damping(DampingCo(ii),ScaleCoArray(1));
end
for ii=1:length(DampingCo) 
    [QBER_Log_Phase_Damping2(ii),P_sift_Log_Phase_Damping2(ii)]=calculateQBER_Damping(DampingCo(ii),ScaleCoArray(2));
end
for ii=1:length(DampingCo) 
    [QBER_Log_Phase_Damping3(ii),P_sift_Log_Phase_Damping3(ii)]=calculateQBER_Damping(DampingCo(ii),ScaleCoArray(3));
end

% %Plot function of Log-Normal Channels
% figure
% semilogy(ScaleCo,QBER_Log,'b-');
% grid on
% hold on
% semilogy(ScaleCo,P_sift_Log,'r+');
% xlabel('D-T scale coefficient');
% ylabel('Probability');
% title('QBER of Quantum Key Distribution System over Log-Normal Channels');
% legend('QBER','Psift');
% axis([0,4,1.e-4,1.e-0]);

% %Plot function of Gamma-Gamma Channels
% figure 
% semilogy(ScaleCo,QBER_Gamma,'b-');
% grid on
% hold on
% semilogy(ScaleCo,P_sift_Gamma,'r+');
% xlabel('D-T scale coefficient');
% ylabel('Probability');
% title('QBER of Quantum Key Distribution System over Gamma-Gamma Channels');
% legend('QBER','Psift');
% axis([0,4.5,1.e-4,1.e-0]);

%Plot function of Log-Normal Channels with PLL-Phase Noise versus Scale Coefficient
figure 
semilogy(ScaleCo,QBER_Log_Phase1,'b-',ScaleCo,QBER_Log_Phase2,'bo',ScaleCo,QBER_Log_Phase3,'b+');
grid on
hold on
semilogy(ScaleCo,P_sift_Log_Phase1,'r-',ScaleCo,P_sift_Log_Phase2,'ro',ScaleCo,P_sift_Log_Phase3,'r+');
xlabel('D-T scale coefficient');
ylabel('Probability');
title('QBER of Quantum Key Distribution System over Log-Normal Channels with PLL-Phase Noise');
legend(['QBER with Damping Coefficient=',num2str(DampingCoArray(1))],...
       ['QBER with Damping Coefficient=',num2str(DampingCoArray(2))],...
       ['QBER with Damping Coefficient=',num2str(DampingCoArray(3))],...
       ['Psift with Damping Coefficient=',num2str(DampingCoArray(1))],...
       ['Psift with Damping Coefficient=',num2str(DampingCoArray(2))],...
       ['Psift with Damping Coefficient=',num2str(DampingCoArray(3))]);
axis([0,4,1.e-4,1.e-0]);

%Plot function of Log-Normal Channels with PLL-Phase Noise versus Damping Coefficient
figure
semilogy(DampingCo,QBER_Log_Phase_Damping1,'b-',DampingCo,QBER_Log_Phase_Damping2,'bo',DampingCo,QBER_Log_Phase_Damping3,'b+');
grid on
hold on
plot(DampingCo,P_sift_Log_Phase_Damping1,'r-',DampingCo,P_sift_Log_Phase_Damping2,'ro',DampingCo,P_sift_Log_Phase_Damping3,'r+');
xlabel('Damping coefficient');
ylabel('Probability');
title('QBER of Quantum Key Distribution Systems over Log-Normal Channels with PLL-Phase Noise versus Damping Coefficient');
legend(['QBER with Scale Coefficient=',num2str(ScaleCoArray(1))],...
       ['QBER with Scale Coefficient=',num2str(ScaleCoArray(2))],...
       ['QBER with Scale Coefficient=',num2str(ScaleCoArray(3))],...
       ['Psift with Scale Coefficient=',num2str(ScaleCoArray(1))],...
       ['Psift with Scale Coefficient=',num2str(ScaleCoArray(2))],...
       ['Psift with Scale Coefficient=',num2str(ScaleCoArray(3))]);
axis([0,4,1.e-4,1.e-0]);