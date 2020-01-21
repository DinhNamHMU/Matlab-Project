clc;
clear;
close all;

% total power
P = 5;

% power for each source node (P1=P2)
P1 = [1/10:1/10:P/2-1/10]';
P2 = P1;

% power for relay node
PR = P-(P1+P2);

% d1 = distance (S1->D1) = distance (S2->D2)
d1 = 1;

% d2 = distance (S1->S2) = distance (D1->D2)
d2 = 1/2;

% relay location determined through d0R in (0,d1)
d0R = [0+d1/10:d1/10:d1-d1/10]';

% d1R = distance (S1->R)
d1R = sqrt(d0R.^2+(d2^2)/4);

% alpha = angle (D1,S1,R)
alpha = atan((d2/2)./d0R);

% d2R = distance (S2->R)
d2R = sqrt(d2^2+d1R.^2-2*d2*d1R.*sin(alpha));

% dR1 = distance (R->D1)
dR1 = sqrt(d1^2+d1R.^2-2*d1*d1R.*cos(alpha));

% beta = angle (D2,S2,R)
beta = acos((d1R./d2R).*cos(alpha));

% dR2 = distance (R->D2)
dR2 = sqrt(d1^2+d2R.^2-2*d1*d2R.*cos(beta));

% pathloss exponent
nu = 3;

% rate
R = 5;

% loop for the realisations of various channels (retransmissions)
% Loop_k = 1000;
Loop_k = 100;

% loop for the simulation
% Loop = 100000;
Loop = 10000;

% number of retransmissions
K11 = zeros(length(d0R),1); % S1 -> D1
K22 = zeros(length(d0R),1); % S2 -> D2
KANC1 = zeros(length(d0R),1);
KANC2 = zeros(length(d0R),1);
d1Rmin = zeros(length(P1),1);
alphamin = zeros(length(P1),1);
EBmin = zeros(length(P1),1);
EB = zeros(length(P1),1);
D = zeros(length(P1),1);
for p1_idx=1:length(P1)
    for l=1:Loop
        for d0R_idx=1:length(d0R)
            % Direct transmission S1 -> D1
            for k=1:Loop_k
                h11(k) = sqrt(1/(d1^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                z11(k) = log2(1 + P1(p1_idx)*((abs(h11(k)))^2));
                z11_sum = 0;
                for i=1:k
                    z11_sum = z11_sum + z11(k);
                end
                if (z11_sum>R)
                    break;
                end
            end
            K11(d0R_idx) = k;
            % Direct transmission S2 -> D2
            for k=1:Loop_k
                h22(k) = sqrt(1/(d1^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                z22(k) = log2(1 + P2(p1_idx)*((abs(h22(k)))^2));
                z22_sum = 0;
                for i=1:k
                    z22_sum = z22_sum + z22(k);
                end
                if (z22_sum>R)
                    break;
                end
            end
            K22(d0R_idx) = k;
            
            % Relaying transmission S1 -> R -> D2
            for k=1:Loop_k
                h1R(k) = sqrt(1/(d1R(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                h2R(k) = sqrt(1/(d2R(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                hR2(k) = sqrt(1/(dR2(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                SNR1(k) = P1(p1_idx)*PR(p1_idx)*((abs(h1R(k)))^2)*((abs(hR2(k)))^2)/(PR(p1_idx)*((abs(hR2(k)))^2)+P1(p1_idx)*((abs(h1R(k)))^2)+P2(p1_idx)*((abs(h2R(k)))^2)+1);
                zANC1(k) = log2(1 + SNR1(k));
                zANC1_sum = 0;
                for i=1:k
                    zANC1_sum = zANC1_sum + zANC1(k);
                end
                if zANC1_sum>R
                    break;
                end
            end
            KANC1(d0R_idx) = k;
            
            % Relaying transmission S2 -> R -> D1
            for k=1:Loop_k
                h1R(k) = sqrt(1/(d1R(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                h2R(k) = sqrt(1/(d2R(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                hR1(k) = sqrt(1/(dR1(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                SNR2(k) = P2(p1_idx)*PR(p1_idx)*((abs(h2R(k)))^2)*((abs(hR1(k)))^2)/(PR(p1_idx)*((abs(hR1(k)))^2)+P2(p1_idx)*((abs(h2R(k)))^2)+P1(p1_idx)*((abs(h1R(k)))^2)+1);
                zANC2(k) = log2(1 + SNR2(k));
                zANC2_sum = 0;
                for i=1:k
                    zANC2_sum = zANC2_sum + zANC2(k);
                end
                if zANC2_sum>R
                    break;
                end
            end
            KANC2(d0R_idx) = k;
        end
        
        % effective delay
        %D = (max(KANC1,K11)+max(KANC2,K22)+KANC1+KANC2)./(2*R);
        
        % energy per bit
        EB = (P1(p1_idx).*max(KANC1,K11)+P2(p1_idx).*max(KANC2,K22)+(PR(p1_idx)/2).*KANC1+(PR(p1_idx)/2).*KANC2)./(2*R);

        
        % find relay location to minimize EB
        [EBmintemp,d0Rmin_idx] = min(EB);
        EBmin(p1_idx) = EBmin(p1_idx) + EBmintemp;
        d0Rmin = d0R(d0Rmin_idx);
        d1Rmin(p1_idx) = d1Rmin(p1_idx) + sqrt(d0Rmin^2+(d2^2)/4);
        alphamin(p1_idx) = alphamin(p1_idx) + atan((d2/2)./d0Rmin);        
        % effective delay
        D(p1_idx) = D(p1_idx) + (max(max(KANC1(d0Rmin_idx),K11(d0Rmin_idx)),max(KANC2(d0Rmin_idx),K22(d0Rmin_idx)))+max(KANC1(d0Rmin_idx),KANC2(d0Rmin_idx)))./(2*R);
               
        
    end
end

d1Rmin_avg = d1Rmin./Loop;
alphamin_avg = alphamin./Loop;
alphamindeg_avg = alphamin_avg*180/pi;
D_avg = D./Loop;
EBmin_avg = EBmin./Loop;

clc;
