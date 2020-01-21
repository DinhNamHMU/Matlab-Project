% simulation for channel estimation techniequs using LS, LMMMSE, and
% computationally efficient LMMMSE methods. 
% Prepared by: Hiren Gami
% Ref: J J Van de Beek, "Synchronization and Channel Estimation in OFDM 
% systems", Ph.D thesis,Sept. 1998 

clc
clear all

nCP = 8; %round(Tcp/Ts);
nFFT = 64; 
NT = nFFT + nCP;
F = dftmtx(nFFT)/sqrt(nFFT);
MC = 1500;
EsNodB = 0:5:40;
snr = 10.^(EsNodB/10);
beta = 17/9;
M = 16;
modObj = modem.qammod(M);
demodObj = modem.qamdemod(M);
L = 5;
ChEstLS = zeros(1,length(EsNodB));
ChEstMMSE = zeros(1,length(EsNodB));
TD_ChEstMMSE = zeros(1,length(EsNodB));
TDD_ChEstMMSE = zeros(1,length(EsNodB));
TDQabs_ChEstMMSE = zeros(1,length(EsNodB));

for ii = 1:length(EsNodB)
    disp('EsN0dB is :'); disp(EsNodB(ii));tic;
    ChMSE_LS = 0;
    ChMSE_LMMSE=0; 
    TDMSE_LMMSE =0;
    TDDMSE_LMMSE=0;
    TDQabsMSE_LMMSE =0;
    for mc = 1:MC
    % Random channel taps
        g = randn(L,1)+1i*randn(L,1);
        g = g/norm(g);
        H = fft(g,nFFT);
    % generation of symbol
        X = randi([0 M-1],nFFT,1);  %BPSK symbols
        XD = modulate(modObj,X)/sqrt(10); % normalizing symbol power
        x = F'*XD;
        xout = [x(nFFT-nCP+1:nFFT);x];        
    % channel convolution and AWGN
        y = conv(xout,g);
        nt =randn(nFFT+nCP+L-1,1) + 1i*randn(nFFT+nCP+L-1,1);
        No = 10^(-EsNodB(ii)/10);
        y =  y + sqrt(No/2)*nt;
    % Receiver processing
        y = y(nCP+1:NT);
        Y = F*y;
    % frequency doimain LS channel estimation 
        HhatLS = Y./XD; 
        ChMSE_LS = ChMSE_LS + ((H -HhatLS)'*(H-HhatLS))/nFFT;
    % Frequency domain LMMSE estimation
        Rhh = H*H';
        W = Rhh/(Rhh+(beta/snr(ii))*eye(nFFT));
        HhatLMMSE = W*HhatLS;
        ChMSE_LMMSE = ChMSE_LMMSE + ((H -HhatLMMSE)'*(H-HhatLMMSE))/nFFT;        
    % Time domain LMMSE estimation
        ghatLS = ifft(HhatLS,nFFT);
        Rgg = g*g';
        WW = Rgg/(Rgg+(beta/snr(ii))*eye(L));
        ghat = WW*ghatLS(1:L);
        TD_HhatLMMSE = fft(ghat,nFFT);%        
        TDMSE_LMMSE = TDMSE_LMMSE + ((H -TD_HhatLMMSE)'*(H-TD_HhatLMMSE))/nFFT;   
    % Time domain LMMSE estimation - ignoring channel covariance
        ghatLS = ifft(HhatLS,nFFT);
        Rgg = diag(g.*conj(g));
        WW = Rgg/(Rgg+(beta/snr(ii))*eye(L));
        ghat = WW*ghatLS(1:L);
        TDD_HhatLMMSE = fft(ghat,nFFT);%        
        TDDMSE_LMMSE = TDDMSE_LMMSE + ((H -TDD_HhatLMMSE)'*(H-TDD_HhatLMMSE))/nFFT;    
    % Time domain LMMSE estimation - ignoring smoothing matrix
        ghatLS = ifft(HhatLS,nFFT);
        TDQabs_HhatLMMSE = fft(ghat,nFFT);%        
        TDQabsMSE_LMMSE = TDQabsMSE_LMMSE + ((H -TDQabs_HhatLMMSE)'*(H-TDQabs_HhatLMMSE))/nFFT;                  
    end
    ChEstLS(ii) = ChMSE_LS/MC;
    ChEstMMSE(ii)=ChMSE_LMMSE/MC;
    TD_ChEstMMSE(ii)=TDMSE_LMMSE/MC;
    TDD_ChEstMMSE(ii)=TDMSE_LMMSE/MC;
    TDQabs_ChEstMMSE(ii)=TDQabsMSE_LMMSE/MC;
    toc;
end

% Channel estimation 
semilogy(EsNodB,ChEstLS,'r','LineWidth',2);
hold on;grid on;xlabel('EsNodB'); ylabel('Channel MSE');
semilogy(EsNodB,ChEstMMSE,'k','LineWidth',2);
semilogy(EsNodB,TD_ChEstMMSE,'g','LineWidth',2);
semilogy(EsNodB,TDD_ChEstMMSE,'m','LineWidth',2);
semilogy(EsNodB,TDQabs_ChEstMMSE,'b','LineWidth',2);

% Theoratical bound calculation
semilogy(EsNodB,beta./snr,'-.r*','LineWidth',2);
ThLMMSE = (1/nFFT)*(beta./snr).*(1./(1+(beta./snr)));
semilogy(EsNodB,ThLMMSE,'-.k*','LineWidth',2);
legend('LS','MMSE', 'TD LMMSE','TDD LMMSE','TD Qabs LMMSE','Theory-LS', 'Theory-LMMSE');

