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
KMAC = zeros(length(d0R),1); % {S1,S2} -> R
KBC = zeros(length(d0R),1); % R -> {D1,D2}
d1Rmin = zeros(length(P1),1);
alphamin = zeros(length(P1),1);
D = zeros(length(P1),1);
EBmin = zeros(length(P1),1);
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
            
            % MAC phase {S1,S2} -> R
            for k=1:Loop_k
                h1R(k) = sqrt(1/(d1R(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                h2R(k) = sqrt(1/(d2R(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                z1R(k) = log2(1 + P1(p1_idx)*((abs(h1R(k)))^2));
                z2R(k) = log2(1 + P2(p1_idx)*((abs(h2R(k)))^2));
                zR(k) = log2(1 + P1(p1_idx)*((abs(h1R(k)))^2) + P2(p1_idx)*((abs(h2R(k)))^2));
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
            KMAC(d0R_idx) = k;
            
            % BC phase R -> {D1,D2}
            for k1=1:Loop_k
                hR1(k1) = sqrt(1/(dR1(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                zR1(k1) = log2(1 + PR(p1_idx)*((abs(hR1(k1)))^2));
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
                hR2(k2) = sqrt(1/(dR2(d0R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                zR2(k2) = log2(1 + PR(p1_idx)*((abs(hR2(k2)))^2));
                zR2_sum = 0;
                for i=1:k2
                    zR2_sum = zR2_sum + zR2(k2);
                end
                if (zR2_sum>R)
                    break;
                end
            end
            KBC2 = k2;
            KBC(d0R_idx) = max(KBC1,KBC2);
        end
                      
        % 1st time slot (direct + MAC)
        K1 = max(KMAC,max(K11,K22));
        % 2nd time slot (BC)
        K2 = KBC;

        % energy per bit
        EB = (P1(p1_idx).*max(KMAC,K11)+P2(p1_idx).*max(KMAC,K22)+PR(p1_idx).*K2)./(2*R);        
        
        % find relay location to minimize EB
        [EBmintemp,d0Rmin_idx] = min(EB);
        EBmin(p1_idx) = EBmin(p1_idx) + EBmintemp;
        d0Rmin = d0R(d0Rmin_idx);
        d1Rmin(p1_idx) = d1Rmin(p1_idx) + sqrt(d0Rmin^2+(d2^2)/4);
        alphamin(p1_idx) = alphamin(p1_idx) + atan((d2/2)./d0Rmin);                
        % effective delay
        D(p1_idx) = D(p1_idx) + (K1(d0Rmin_idx)+K2(d0Rmin_idx))./(2*R);
        
        
    end
end

d1Rmin_avg = d1Rmin./Loop;
alphamin_avg = alphamin./Loop;
alphamindeg_avg = alphamin_avg*180/pi;
D_avg = D./Loop;
EBmin_avg = EBmin./Loop;

clc;
