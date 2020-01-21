function y = CalculateBERM(M, P1_dB)
% Tinh BER cua he thong IM-DD buoc song 0.85 micromet. Theo he so nhan M.
% Tham so
P1_dB = -40; % Cong suat bit 1
P0 = 0; % Cong suat bit 0
I0 = 0; % Cuong do bit 0
M = [10:1:200]; % He so nhan -> APD
R = 1; % Dap ung photodiot
q = 1.6*10^-19;

deltaF = 1*10^9; % Bang tan
kB = 1.38*10^-23;% Hang so Boltzman
T = 25+273; % Nhiet do tuyet doi
RL = 10^3; % Dien tro tai
Fn = 2; % He so nhieu khuech dai

% Tinh BER
for ii=1 : length(M) 
    FA(ii) = M(ii)^0.5; % He so nhieu troi APD
    Prec(ii) = ((10^(P1_dB/10))*10^-3 + P0)/2; % Doi dBm sang W
    I1(ii) = 2*M(ii)*R*Prec(ii);
    sigma2S(ii) = 2*q*M(ii)^2*FA(ii)*R*2*Prec(ii)*deltaF;
    sigma2T = 4*kB*T/RL*Fn*deltaF;
    sigma1 = (sigma2S(ii)+sigma2T)^0.5;
    sigma0 = sqrt(sigma2T);
    Q(ii) = (I1(ii)-I0)/(sigma1+sigma0);
    BER(ii) = 0.5*erfc(Q(ii)/2^0.5);
    y = BER;
end

end