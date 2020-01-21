clc;
clear;
close all;

% d1 = distance (S1->D1) = distance (S2->D2)
d1 = 1;

% d2 = distance (S1->S2) = distance (D1->D2)
d2 = 1/sqrt(3);

% d1R = distance (S1->R) 
%d1R = 1/2*sqrt(d1^2+d2^2);


% alpha = angle (D1,S1,R)
%alpha = atan(d2/d1);
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
KMAC = zeros(length(P),1); % {S1,S2} -> R
KBC = zeros(length(P),1); % R -> {D1,D2}

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
        
        % MAC phase {S1,S2} -> R
        for k=1:Loop_k
            h1R(k) = sqrt(1/(d1R^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            h2R(k) = sqrt(1/(d2R^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            z1R(k) = log2(1 + P1(p)*((abs(h1R(k)))^2));
            z2R(k) = log2(1 + P2(p)*((abs(h2R(k)))^2));
            zR(k) = log2(1 + P1(p)*((abs(h1R(k)))^2) + P2(p)*((abs(h2R(k)))^2));
            z1R_sum = 0;
            z2R_sum = 0;
            zR_sum = 0;
            for i=1:k
                z1R_sum = z1R_sum + z1R(k);
                z2R_sum = z2R_sum + z2R(k);
                zR_sum = zR_sum + zR(k);
            end
            if (z1R_sum>R) && (z2R_sum>R) && (zR_sum>2*R)
                break;
            end
        end
        KMAC(p) = KMAC(p) + k;
        
        % BC phase R -> {D1,D2}
        for k1=1:Loop_k
            hR1(k1) = sqrt(1/(dR1^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            zR1(k1) = log2(1 + PR(p)*((abs(hR1(k1)))^2));
            zR1_sum = 0;
            for i=1:k1
                zR1_sum = zR1_sum + zR1(k1);
            end
            if (zR1_sum>R)
                break;
            end
        end
        KBC1 = k1;
        for k2=1:Loop_k
            hR2(k2) = sqrt(1/(dR2^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            zR2(k2) = log2(1 + PR(p)*((abs(hR2(k2)))^2));
            zR2_sum = 0;
            for i=1:k2
                zR2_sum = zR2_sum + zR2(k2);
            end
            if (zR2_sum>R)
                break;
            end
        end
        KBC2 = k2;
        KBC(p) = KBC(p) + max(KBC1,KBC2);
        
    end
end

% average number of retransmissions
K11_avg = K11./Loop;
K22_avg = K22./Loop;
KMAC_avg = KMAC./Loop;
KBC_avg = KBC./Loop;
% 1st time slot (direct + MAC)
K1_avg = max(KMAC_avg,max(K11_avg,K22_avg));
% 2nd time slot (BC)
K2_avg = KBC_avg;

% effective delay
D = (K1_avg+K2_avg)./(2*R);

% energy per bit
EB = (P1.*max(KMAC_avg,K11_avg)+P2.*max(KMAC_avg,K22_avg)+PR.*K2_avg)/(2*R);

clc;
