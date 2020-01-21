clc;
clear;
close all;

% total power
P = 5;

% power for each source node (P1>P2)
P1 = [1/10:1/10:3*P/5-1/10]';
P2 = P1./8;

% power for relay node
PR = P-(P1+P2);

% d1 = distance (S1->D1) = distance (S2->D2)
d1 = 1;

% d2 = distance (S1->S2) = distance (D1->D2)
d2 = 1/2;

% relay location
% alpha = angle (D1,S1,R)
alpha11 = atan((d2/2)/d1); % limit 1 for scenario a
alpha12 = atan(d2/d1); % limit 2 for scenario a
alpha1 = [alpha11+(alpha12-alpha11)/10:(alpha12-alpha11)/10:alpha12-(alpha12-alpha11)/10]';

alpha21 = atan(d2/d1); % limit 1 for scenario b
alpha22 = pi/2; % limit 2 for scenario b
alpha2 = [alpha21+(alpha22-alpha21)/10:(alpha22-alpha21)/10:alpha22-(alpha22-alpha21)/10]';

% d1R = distance (S1->R)
d1R11 = (d2/2)./sin(alpha1); % limit 1 for scenario a
d1R12 = d1./cos(alpha1); % limit 2 for scenario a

d1R21 = (d2/2)./sin(alpha2); % limit 1 for scenario b
d1R22 = d2./sin(alpha2); % limit 1 for scenario b

% pathloss exponent
nu = 3;

% rate
R = 5;

% loop for the realisations of various channels (retransmissions)
% Loop_k = 1000;
Loop_k = 10;

% loop for the simulation
% Loop = 100000;
Loop = 10000;

d1Rmin = zeros(length(P1),1);
alphamin = zeros(length(P1),1);
D = zeros(length(P1),1);
EBmin = zeros(length(P1),1);

for p1_idx=1:length(P1)
    for l=1:Loop
        %% Scenario a
        % number of retransmissions
        K11a = zeros(length(alpha1),9); % S1 -> D1
        K22a = zeros(length(alpha1),9); % S2 -> D2
        KANC1a = zeros(length(alpha1),9);
        KANC2a = zeros(length(alpha1),9);
        
        
        for alpha1_idx=1:length(alpha1)
            d1R = [d1R11(alpha1_idx)+(d1R12(alpha1_idx)-d1R11(alpha1_idx))/10:(d1R12(alpha1_idx)-d1R11(alpha1_idx))/10:d1R12(alpha1_idx)-(d1R12(alpha1_idx)-d1R11(alpha1_idx))/10]';
            
            % d2R = distance (S2->R)
            d2R = sqrt(d2^2+d1R.^2-2*d2*d1R.*sin(alpha1(alpha1_idx)));
            
            % dR1 = distance (R->D1)
            dR1 = sqrt(d1^2+d1R.^2-2*d1*d1R.*cos(alpha1(alpha1_idx)));
            
            % beta = angle (D2,S2,R)
            beta = acos((d1R./d2R).*cos(alpha1(alpha1_idx)));
            
            % dR2 = distance (R->D2)
            dR2 = sqrt(d1^2+d2R.^2-2*d1*d2R.*cos(beta));
            
            for d1R_idx = 1:length(d1R)
                
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
                K11a(alpha1_idx,d1R_idx) = k;
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
                K22a(alpha1_idx,d1R_idx) = k;
                
                % Relaying transmission S1 -> R -> D2
                for k=1:Loop_k
                    h1R(k) = sqrt(1/(d1R(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                    h2R(k) = sqrt(1/(d2R(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                    hR2(k) = sqrt(1/(dR2(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
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
                KANC1a(alpha1_idx,d1R_idx) = k;
                
                % Relaying transmission S2 -> R -> D1
                for k=1:Loop_k
                    h1R(k) = sqrt(1/(d1R(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                    h2R(k) = sqrt(1/(d2R(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                    hR1(k) = sqrt(1/(dR1(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
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
                KANC2a(alpha1_idx,d1R_idx) = k;
            end
        end
                       
        % energy per bit
        EB1 = (P1(p1_idx).*max(KANC1a,K11a)+P2(p1_idx).*max(KANC2a,K22a)+(PR(p1_idx)/2).*KANC1a+(PR(p1_idx)/2).*KANC2a)./(2*R);        
        
        % find relay location to minimize EB
        [EBmin1temp,alpha1mintemp_idx] = min(EB1);
        [EBmin1temp1,d1R1min_idx] = min(EBmin1temp);
        EBmin1 = EBmin1temp1;
        alpha1min_idx=alpha1mintemp_idx(d1R1min_idx);
        alpha1min = alpha1(alpha1min_idx);
        
        d1R1min = d1R11(alpha1min_idx)+d1R1min_idx*(d1R12(alpha1min_idx)-d1R11(alpha1min_idx))/10;       
        
        % effective delay
        D1 = (max(max(KANC1a(alpha1min_idx,d1R1min_idx),K11a(alpha1min_idx,d1R1min_idx)),max(KANC2a(alpha1min_idx,d1R1min_idx),K22a(alpha1min_idx,d1R1min_idx)))+max(KANC1a(alpha1min_idx,d1R1min_idx),KANC2a(alpha1min_idx,d1R1min_idx)))./(2*R);
        
        %% Scenario b
        % number of retransmissions
        K11b = zeros(length(alpha1),9); % S1 -> D1
        K22b = zeros(length(alpha1),9); % S2 -> D2
        KANC1b = zeros(length(alpha1),9);
        KANC2b = zeros(length(alpha1),9);
        
        
        for alpha2_idx=1:length(alpha2)
            d1R = [d1R21(alpha2_idx)+(d1R22(alpha2_idx)-d1R21(alpha2_idx))/10:(d1R22(alpha2_idx)-d1R21(alpha2_idx))/10:d1R22(alpha2_idx)-(d1R22(alpha2_idx)-d1R21(alpha2_idx))/10]';
            
            % d2R = distance (S2->R)
            d2R = sqrt(d2^2+d1R.^2-2*d2*d1R.*sin(alpha1(alpha1_idx)));
            
            % dR1 = distance (R->D1)
            dR1 = sqrt(d1^2+d1R.^2-2*d1*d1R.*cos(alpha1(alpha1_idx)));
            
            % beta = angle (D2,S2,R)
            beta = acos((d1R./d2R).*cos(alpha1(alpha1_idx)));
            
            % dR2 = distance (R->D2)
            dR2 = sqrt(d1^2+d2R.^2-2*d1*d2R.*cos(beta));
            
            for d1R_idx = 1:length(d1R)
                
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
                K11b(alpha2_idx,d1R_idx) = k;
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
                K22b(alpha2_idx,d1R_idx) = k;
                
                % Relaying transmission S1 -> R -> D2
                for k=1:Loop_k
                    h1R(k) = sqrt(1/(d1R(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                    h2R(k) = sqrt(1/(d2R(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                    hR2(k) = sqrt(1/(dR2(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
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
                KANC1b(alpha2_idx,d1R_idx) = k;
                
                % Relaying transmission S2 -> R -> D1
                for k=1:Loop_k
                    h1R(k) = sqrt(1/(d1R(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                    h2R(k) = sqrt(1/(d2R(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
                    hR1(k) = sqrt(1/(dR1(d1R_idx)^nu))*sqrt(0.5)*(randn(1)+1i*randn(1));
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
                KANC2b(alpha2_idx,d1R_idx) = k;
            end
        end
        
        % energy per bit
        EB2 = (P1(p1_idx).*max(KANC1b,K11b)+P2(p1_idx).*max(KANC2b,K22b)+(PR(p1_idx)/2).*KANC1b+(PR(p1_idx)/2).*KANC2b)./(2*R);        
        
        % find relay location to minimize EB
        [EBmin2temp,alpha2mintemp_idx] = min(EB2);
        [EBmin2temp1,d1R2min_idx] = min(EBmin2temp);
        EBmin2 = EBmin2temp1;
        alpha2min_idx=alpha2mintemp_idx(d1R2min_idx);
        alpha2min = alpha2(alpha2min_idx);
        
        d1R2min = d1R21(alpha2min_idx)+d1R2min_idx*(d1R22(alpha2min_idx)-d1R21(alpha2min_idx))/10;
        
        % effective delay
        D2 = (max(max(KANC1b(alpha2min_idx,d1R2min_idx),K11b(alpha2min_idx,d1R2min_idx)),max(KANC2b(alpha2min_idx,d1R2min_idx),K22b(alpha2min_idx,d1R2min_idx)))+max(KANC1b(alpha2min_idx,d1R2min_idx),KANC2b(alpha2min_idx,d1R2min_idx)))./(2*R);
        
        if EBmin1<EBmin2
            EBmin(p1_idx) = EBmin(p1_idx) + EBmin1;
            alphamin(p1_idx) = alphamin(p1_idx)+ alpha1min;
            d1Rmin(p1_idx) = d1Rmin(p1_idx) + d1R1min;
            D(p1_idx) = D(p1_idx) + D1;
        else
            EBmin(p1_idx) = EBmin(p1_idx) + EBmin2;
            alphamin(p1_idx) = alphamin(p1_idx) + alpha2min;
            d1Rmin(p1_idx) = d1Rmin(p1_idx) + d1R2min;
            D(p1_idx) = D(p1_idx) + D2;
        end
        
    end
end

d1Rmin_avg = d1Rmin./Loop;
alphamin_avg = alphamin./Loop;
alphamindeg_avg = alphamin_avg*180/pi;
D_avg = D./Loop;
EBmin_avg = EBmin./Loop;

clc;
