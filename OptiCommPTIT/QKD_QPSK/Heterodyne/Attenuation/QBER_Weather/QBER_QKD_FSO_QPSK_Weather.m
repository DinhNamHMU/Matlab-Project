%Calculate QBER of Quantum Key Distribution System Using Dual Threshold
%Heterodyne Detection Receiver over Free-Space Optics with QPSK scheme 
clear;
clc;

%Simulator Parameters
global P_LO_dBm;     %Power of Local Oscillator(dBm)
       P_LO_dBm=0;

ScaleCoArr=0:0.1:4;  %Threshold scale coefficient
ScaleCo=1.5;
P_T_dBm1=0;          %Transmitted power(dBm)-> Value=0||5
P_T_dBm2=5;   
P_T_dBmArr=-10:1:10;

%Atmospheric attenuation coefficient(dB/km)
alphaAir=0.43; %Clear air
alphaFog=3.34; %Moderate fog
alphaRain=5.8; %Moderate rain (12.5 mm/h)

%Calculate QBER
%Clear air
[QBER11_Air,P_sift11_Air,QBER12_Air,P_sift12_Air,QBER2_Air,P_sift2_Air...
,QBER3_Air,P_sift3_Air]=calculateQBER_QPSK_Weather(alphaAir); 

% %Plot function of QBER versus Threshold scale coefficient
% figure(1)
% subplot(1,2,1);
% %P_T_dBm=0
% semilogy(ScaleCoArr,QBER11_Air,'b-o',ScaleCoArr,P_sift11_Air,'r-*');
% grid on
% xlabel('Threshold scale coefficient, p');
% ylabel('Probability');
% title(['P_{T} = ',num2str(P_T_dBm1),' (dBm). Under a clear weather condition.'],'FontWeight','Normal');
% legend('QBER','P_{sift}');
% axis([0,4,1.e-4,1.e-0]);
% 
% subplot(1,2,2);
% %P_T_dBm=5
% semilogy(ScaleCoArr,QBER12_Air,'b-o',ScaleCoArr,P_sift12_Air,'r-*');
% grid on
% xlabel('Threshold scale coefficient, p');
% ylabel('Probability');
% title(['P_{T} = ',num2str(P_T_dBm2),' (dBm). Under a clear weather condition.'],'FontWeight','Normal');
% legend('QBER','P_{sift}');
% axis([0,4,1.e-4,1.e-0]);
% 
% %Plot function of BER versus Transmitted power
% figure(2)
% semilogy(P_T_dBmArr,QBER2_Air,'b-o',P_T_dBmArr,P_sift2_Air,'b-*');
% hold on
% grid on
% semilogy(P_T_dBmArr,QBER3_Air,'r-o',P_T_dBmArr,P_sift3_Air,'r-*');
% xlabel('Transmitted power, P_{T} (dBm)');
% ylabel('Probability');
% title(['QBER and P_{sift} versus the transmitted power with p=',num2str(ScaleCo),'. Under a moderate fog condition.'],'FontWeight','Normal');
% legend('QBER Heterodyne','P_{sift} Heterodyne','QBER Direct Detection','P_{sift} Direct Detection','Location','southwest');
% axis([-10,10,1.e-4,1.e-0]);

%Moderate fog
[QBER11_Fog,P_sift11_Fog,QBER12_Fog,P_sift12_Fog,QBER2_Fog,P_sift2_Fog...
,QBER3_Fog,P_sift3_Fog]=calculateQBER_QPSK_Weather(alphaFog); 

%Plot function of QBER versus Threshold scale coefficient
figure(3)
subplot(1,2,1);
%P_T_dBm=0
semilogy(ScaleCoArr,QBER11_Fog,'b-o',ScaleCoArr,P_sift11_Fog,'r-*');
grid on
xlabel('Threshold scale coefficient, p');
ylabel('Probability');
title(['P_{T} = ',num2str(P_T_dBm1),' (dBm). Under a moderate fog condition.'],'FontWeight','Normal');
legend('QBER','P_{sift}');
% axis([0,4,1.e-4,1.e-0]);

subplot(1,2,2);
%P_T_dBm=5
semilogy(ScaleCoArr,QBER12_Fog,'b-o',ScaleCoArr,P_sift12_Fog,'r-*');
grid on
xlabel('Threshold scale coefficient, p');
ylabel('Probability');
title(['P_{T} = ',num2str(P_T_dBm2),' (dBm). Under a moderate fog condition.'],'FontWeight','Normal');
legend('QBER','P_{sift}');
% axis([0,4,1.e-4,1.e-0]);

% Plot function of BER versus Transmitted power
figure(4)
semilogy(P_T_dBmArr,QBER2_Fog,'b-o',P_T_dBmArr,P_sift2_Fog,'b-*');
hold on
grid on
semilogy(P_T_dBmArr,QBER3_Fog,'r-o',P_T_dBmArr,P_sift3_Fog,'r-*');
xlabel('Transmitted power, P_{T} (dBm)');
ylabel('Probability');
title(['QBER and P_{sift} versus the transmitted power with p=',num2str(ScaleCo),'. Under a moderate fog condition.'],'FontWeight','Normal');
legend('QBER Heterodyne','P_{sift} Heterodyne','QBER Direct Detection','P_{sift} Direct Detection','Location','southwest');
% axis([-10,10,1.e-4,1.e-0]);

%Moderate rain
