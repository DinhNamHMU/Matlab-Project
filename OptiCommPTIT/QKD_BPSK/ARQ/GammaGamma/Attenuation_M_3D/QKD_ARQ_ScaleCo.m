%Quantum key distribution and ARQ protocol over free-space optics using
%dual-threshold direct-detection receiver
clear;
clc;

%Parameters Simulation
C2n_Strong=10^-13;
ScaleCo_Strong=1.9;

B=10; %BS buffer size
scale=10;
M_retransmission=linspace(0,9,scale);
M_transmission=size(1,length(M_retransmission));
for i=1:length(M_retransmission)
    M_transmission(i)=M_retransmission(i)+1;
end
AttenuationArray=(linspace(0,3,scale))';

%Calculate Key loss rate
%Strong turbulence
v1_retransmission=ones(length(M_retransmission),1);
v1_transmission=ones(length(M_transmission),1);
v2=ones(length(AttenuationArray),1);
X_retransmission=v1_retransmission*M_retransmission;
X_transmission=v1_transmission*M_transmission;
Y_AttenuationArray=AttenuationArray*v2';

keyLossRate_Strong=zeros(length(M_transmission),length(M_transmission));
QBER_Strong=zeros(length(M_transmission),length(M_transmission));
P_sift_Strong=zeros(length(M_transmission),length(M_transmission));

for i=1:length(M_transmission) 
    for j=1:length(M_transmission) 
        [QBER_Strong(i,j),P_sift_Strong(i,j)]=calculateQBER(ScaleCo_Strong,C2n_Strong,Y_AttenuationArray(i,j));
        keyLossRate_Strong(i,j)=calculateKeyLossRate(X_transmission(i,j),B,QBER_Strong(i,j),P_sift_Strong(i,j));
    end
end

%Plot function of the key loss rate
%Strong turbulence
figure(1)
surfc(X_retransmission,Y_AttenuationArray,keyLossRate_Strong);
xlabel('Number of retransmission, M');
ylabel('D-T scale coefficient, \varsigma');
zlabel('Key loss rate, KLR');
colorbar;
colormap('jet');

figure(2)
contourf(X_retransmission,Y_AttenuationArray,keyLossRate_Strong);
grid on
ax=gca;
ax.GridColor='White';
ax.GridLineStyle=':';
ax.GridAlpha=1;
ax.Layer='top';
xlabel('Number of retransmission, M');
ylabel('D-T scale coefficient, \varsigma');
zlabel('Key loss rate, KLR');
colorbar
colormap('jet');