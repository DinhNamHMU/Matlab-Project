clc;
clear;
close all;

% d1 = distance (S1->D1) = distance (S2->D2)
d1 = 1;

% d2 = distance (S1->S2) = distance (D1->D2)
d2 = 1/sqrt(3);

% d1R = distance (S1->R) 
%d1R = 7/8;

% alpha = angle (D1,S1,R)
alpha = pi/6;

d1R = d1/2/cos(alpha);

% d2R = distance (S2->R)
d2R = sqrt(d2^2+d1R^2-2*d2*d1R*sin(alpha));

% dR1 = distance (R->D1)
dR1 = sqrt(d1^2+d1R^2-2*d1*d1R*cos(alpha));

% beta = angle (D2,S2,R)
beta = acos((d1R/d2R)*cos(alpha));

% dR2 = distance (R->D2)
dR2 = sqrt(d1^2+d2R^2-2*d1*d2R*cos(beta));

% pathloss exponent
nu = 3;

% fraction of power allocated to two source nodes S1 and S2
lambda = 2/3;
% -> fraction of power allocated to relay node R = 1-lambda

% total power
P = [0.01:0.01:1].';

% power for each source node
P1 = lambda/2*P;
P2 = lambda/2*P;

% power for relay node
PR = (1-lambda)*P;

% rate
R = 5;

% loop for the realisations of various channels (retransmissions)
Loop_k = 100;

% loop for the simulation
Loop = 1000;

% number of retransmissions
K11 = zeros(length(P),1); % S1 -> D1
K22 = zeros(length(P),1); % S2 -> D2
KANC1 = zeros(length(P),1);
KANC2 = zeros(length(P),1);

for p=1:length(P)
    for l=1:Loop
        % Direct transmission S1 -> D1
        for k=1:Loop_k
            h11(k) = sqrt(1/(d1^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            z11(k) = log2(1 + P1(p)*((abs(h11(k)))^2));
            z11_sum = 0;
            for i=1:k
                z11_sum = z11_sum + z11(k);
            end
            if (z11_sum>R)
                break;
            end
        end
        K11(p) = K11(p) + k;
        % Direct transmission S2 -> D2
        for k=1:Loop_k
            h22(k) = sqrt(1/(d1^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            z22(k) = log2(1 + P2(p)*((abs(h22(k)))^2));
            z22_sum = 0;
            for i=1:k
                z22_sum = z22_sum + z22(k);
            end
            if (z22_sum>R)
                break;
            end
        end
        K22(p) = K22(p) + k;
        
        % Relaying transmission S1 -> R -> D2
        for k=1:Loop_k
            h1R(k) = sqrt(1/(d1R^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            h2R(k) = sqrt(1/(d2R^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            hR2(k) = sqrt(1/(dR2^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            SNR1(k) = P1(p)*PR(p)*((abs(h1R(k)))^2)*((abs(hR2(k)))^2)/(PR(p)*((abs(hR2(k)))^2)+P1(p)*((abs(h1R(k)))^2)+P2(p)*((abs(h2R(k)))^2)+1);
            zANC1(k) = log2(1 + SNR1(k));
            zANC1_sum = 0;
            for i=1:k
                zANC1_sum = zANC1_sum + zANC1(k);
            end
            if zANC1_sum>R
                break;
            end
        end
        KANC1(p) = KANC1(p) + k;
        
        % Relaying transmission S2 -> R -> D1
        for k=1:Loop_k
            h1R(k) = sqrt(1/(d1R^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            h2R(k) = sqrt(1/(d2R^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            hR1(k) = sqrt(1/(dR1^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            SNR2(k) = P2(p)*PR(p)*((abs(h2R(k)))^2)*((abs(hR1(k)))^2)/(PR(p)*((abs(hR1(k)))^2)+P2(p)*((abs(h2R(k)))^2)+P1(p)*((abs(h1R(k)))^2)+1);
            zANC2(k) = log2(1 + SNR2(k));
            zANC2_sum = 0;
            for i=1:k
                zANC2_sum = zANC2_sum + zANC2(k);
            end
            if zANC2_sum>R
                break;
            end
        end
        KANC2(p) = KANC2(p) + k;
        
    end
end

% average number of retransmissions
K11_avg = K11./Loop;
K22_avg = K22./Loop;
KANC1_avg = KANC1./Loop;
KANC2_avg = KANC2./Loop;

% effective delay
% D = (max(KANC1_avg,K11_avg)+max(KANC2_avg,K22_avg)+KANC1_avg+KANC2_avg)./(2*R);
D = (max(max(KANC1_avg,K11_avg),max(KANC2_avg,K22_avg))+max(KANC1_avg,KANC2_avg))./(2*R);

% energy per bit
EB = (P1.*max(KANC1_avg,K11_avg)+P2.*max(KANC2_avg,K22_avg)+(PR/2).*KANC1_avg+(PR/2).*KANC2_avg)./(2*R);

clc;
