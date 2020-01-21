clc;
clear;
close all;

% d1 = distance (S1->D1) = distance (S2->D2)
d1 = 1;

% d2 = distance (S1->S2) = distance (D1->D2)
d2 = 1/sqrt(3);

% distance (S1->D2)
d12 = sqrt(d1^2+d2^2);
% distance (S2->D1)
d21 = sqrt(d1^2+d2^2);

% pathloss exponent
nu = 3;

% fraction of power allocated to two source nodes S1 and S2
lambda = 1; % since there is no relay node R

% total power
P = [0.01:0.01:1].';

% power for each source node
P1 = lambda/2*P;
P2 = lambda/2*P;

% rate
R = 5;

% loop for the realisations of various channels (retransmissions)
Loop_k = 100;

% loop for the simulation
Loop = 1000;

% number of retransmissions
K11 = zeros(length(P),1); % S1 -> D1
K12 = zeros(length(P),1); % S1 -> D2
K21 = zeros(length(P),1); % S2 -> D1
K22 = zeros(length(P),1); % S2 -> D2

for p=1:length(P)
    for l=1:Loop
        for k=1:Loop_k
            alpha11(k) = sqrt(1/(d1^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            z11(k) = log2(1 + P1(p)*((abs(alpha11(k)))^2));
            z11_sum = 0;
            for i=1:k
                z11_sum = z11_sum + z11(k);
            end
            if (z11_sum>R)
                break;
            end
        end
        K11(p) = K11(p) + k;
        for k=1:Loop_k
            alpha12(k) = sqrt(1/(d12^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            z12(k) = log2(1 + P1(p)*((abs(alpha12(k)))^2));
            z12_sum = 0;
            for i=1:k
                z12_sum = z12_sum + z12(k);
            end
            if (z12_sum>R)
                break;
            end
        end
        K12(p) = K12(p) + k;
        for k=1:Loop_k
            alpha21(k) = sqrt(1/(d21^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            z21(k) = log2(1 + P2(p)*((abs(alpha21(k)))^2));
            z21_sum = 0;
            for i=1:k
                z21_sum = z21_sum + z21(k);
            end
            if (z21_sum>R)
                break;
            end
        end
        K21(p) = K21(p) + k;
        for k=1:Loop_k
            alpha22(k) = sqrt(1/(d1^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
            z22(k) = log2(1 + P2(p)*((abs(alpha22(k)))^2));
            z22_sum = 0;
            for i=1:k
                z22_sum = z22_sum + z22(k);
            end
            if (z22_sum>R)
                break;
            end
        end
        K22(p) = K22(p) + k;
    end
end

% average number of retransmissions
K11_avg = K11./Loop;
K12_avg = K12./Loop;
K21_avg = K21./Loop;
K22_avg = K22./Loop;

% effective delay
D = (max(K11_avg,K12_avg)+max(K21_avg,K22_avg))./(2*R);

% energy per bit
EB = (P1.*max(K11_avg,K12_avg)+P2.*max(K21_avg,K22_avg))./(2*R);

clc;
