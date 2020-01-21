%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% QPSK Modulation and Demodulation with addition of AWGN, raised cosine filtering 
%quantization noise,PAnon-linearity, phase noise and LO offset XXXXX
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


clc;
clear all;
close all;
numBits = 5000;
%data=[0  1 0 1 1 1 0 0 1 1] % information
data=randi([0 1], numBits, 1);  % Generate vector of binary data for first carrier
data2=randi([0 1], numBits, 1);  % Generate vector of binary data for second carrier

M = 4;                     % Size of signal constellation
k = log2(M);                % Number of bits per symbol
noiseVariance = 0.5;

po = pi/18; %Oscillator phase offset in radians
pim = pi/10; %Oscillator quadrature imbalance radians.

figure(1)
stem(data, 'linewidth',3)
grid on;
title('  Information before Transmiting ');
axis([ 0 numBits 0 1.5]);
data_NZR=2*data-1; % Data Represented at NZR form for QPSK modulation
s_p_data=reshape(data_NZR,2,length(data)/2);  % S/P conversion of data

data_NZR2=2*data2-1; % Data Represented at NZR form for QPSK modulation
s_p_data2=reshape(data_NZR2,2,length(data2)/2);  % S/P conversion of data

br=2*10.^6; %Let us transmission bit rate  1000000
fc=3*br; % carrier frequency
f = br;
T = 1/br; %Bit duration
Tc=1/br; % carrier period duration
t=Tc/99:Tc/99:Tc; % Time vector for one bit information
t1 = T/99:T/99:T;
fc2 = 4*br;
Ac = 2; %Amplitude of the carrier
y=[];
y_in=[];
y_qd=[];

%Modulation on the first carrier
for(i=1:length(data)/2)
    y1=s_p_data(1,i)*cos(2*pi*fc*t); % inphase component
    y2=s_p_data(2,i)*sin(2*pi*fc*t) ;% Quadrature component
    y_in=[y_in y1]; % inphase signal vector
    y_qd=[y_qd y2]; %quadrature signal vector
    y=[y y1+y2]; % modulated signal vector
end
Tx_sig1=y; % transmitting signal after modulation on the first carrier

y=[];
y_in=[];
y_qd=[];
%%Modulation on the second carrier
for(i=1:length(data)/2)
    y1=s_p_data2(1,i)*Ac*cos(2*pi*fc2*t); % inphase component
    y2=s_p_data2(2,i)*Ac*sin(2*pi*fc2*t) ;% Quadrature component
    y_in=[y_in y1]; % inphase signal vector
    y_qd=[y_qd y2]; %quadrature signal vector
    y=[y y1+y2]; % modulated signal vector
end
Tx_sig2=y; % transmitting signal after modulation on the second carrier

Tx_sig = Tx_sig1+Tx_sig2; % composite transmit signal with both the carriers


tt=T/99:T/99:(T*length(data))/2; %time vector spaced at Tc/99. where Tc = 1/fc

%Defining filter parameters
%Create square Root Raised Cosine Filter
span = 10;        % Filter span in symbols
rolloff = 0.25;   % Rolloff factor of filter
OSR = 4; %over sampling factor

rrcFilter = rcosdesign(rolloff, span, OSR);%creation of the filter
%fvtool(rrcFilter,'Analysis','Impulse'); %Plot the impulse response

Tx_Sig_fil_a = upfirdn(Tx_sig, rrcFilter, OSR, 1);% apply filtering and up-sample


figure(2)

subplot(3,1,1);
plot(tt,y_in,'linewidth',3), grid on;
title(' wave form for inphase component in QPSK modulation ');
xlabel('time(sec)');
ylabel(' amplitude(volt0');

subplot(3,1,2);
plot(tt,y_qd,'linewidth',3), grid on;
title(' wave form for Quadrature component in QPSK modulation ');
xlabel('time(sec)');
ylabel(' amplitude(volt0');


subplot(3,1,3);
plot(tt,Tx_sig,'r','linewidth',3), grid on;
title('QPSK modulated signal (sum of inphase and Quadrature phase signal)');
xlabel('time(sec)');
ylabel(' amplitude(volt0');


%%XXXXXXXXXXXXXXXXXX Addition of quantization noise XXXXXXXXXXXXXXXXXXXXXXXX
% Digitally modulated signals are generated using DSP and DACs where the
%quantization noise added by the DAC would degrade the Signal to noise
%ratio
n1 = 10; % Number of bits of the ADC/DAC
max1= (2^n1)-1; %maximum n1 bit value
m=length(Tx_Sig_fil_a);

%conversion of the signal ybb to n1 bits digital values quantized to the
%nearest integer value
Vref = Ac*2; % Reference voltage of the converter
conv_fact1 = max1/Vref; %conversion scale for the analogue samples to convert to 16 bits
resolution = Vref/max1;
for s=1:1:m
    z1(s)=(Tx_Sig_fil_a(s)+Ac)*conv_fact1; %generating 'n1' bit digital representation 
                                           %of each sample of the carrier  
end

x1 = nearest(z1); % Each value is quantized to its nearest n1 bit number

for s=1:1:m
    y_tx(s) = ((x1(s)*Vref/max1)-Ac); %generating the analogue equivalent voltage of 
                                       %each 'n1' bit sample 
    qerr1(s) = Tx_Sig_fil_a(s)-y_tx(s);
    
end

N = 2^(nextpow2(m));

figure()
%figure, hold on
subplot(3,1,1)
plot(fftshift(20*log10(abs(fft(Tx_Sig_fil_a)/(N*0.5)))), 'r');
hold on
plot(fftshift(20*log10(abs(fft(y_tx(s))/(N*0.5)))), 'b');
title('Spectra of the carrier signals before and after quantization')
%figure, hold on
subplot(3,1,2)
plot(fftshift(real(fft(y_tx)/(N*0.5))), 'r');
title ('Spectra of the real part of the quantized carrier signals')
%figure, hold on
subplot(3,1,3)
plot(fftshift(imag(fft(y_tx)/(N*0.5))), 'b');
title ('Spectra of the imag part of the quantized carrier signals')
hold off;
%%Addition of non-linear impairments caused by the PA
%Modelling the PA with power sweep data available from a datasheet
Pin_dBm=[17 19 21 23 25 27 29 31 33 35 37 38 39 40 41]; %inputs in dBm
Pout_dBm = [33.5 35.2 36.8 38.3 40 41.8 43.4 45 47 49.6 51.8 52.2 52.5 52.8 53.4];% outputs in dBm

%Step 1: Converting the powers from dBm to milliwatts
x_PA= 10.^(Pin_dBm/10);%input power in mW
y_PA= 10.^(Pout_dBm/10);%output power in mW

%Step 2: Converting the input and output powers to voltages in a 50 ohms
%system
V_in_PA = sqrt(x_PA)/50;
V_out_PA = sqrt(y_PA)/50;

%Step 3: deriving a third order non-linear model of the PA being analyzed
%with curve fitting equations to relate the input and output voltages
%Strategy:
%Form a matrix of inputs X =[x1 x1^2 x1^3
%                            x2 x2^2 x2^3
%                            ............
%                            xn xn^2 xn^3]
%
%Form a matrix Y of outputs =[y1 
%                             y2 
%                             .
%                             yn]
%
% Let matrix A=[a1
%               a2 
%               a3] be the scaling factors for the row elements of X
% Then X * A = Y
% or, A = X\Y;

V_in_PA_sq = V_in_PA.^2;
V_in_PA_cu = V_in_PA.^3;

V_in_PA_eff1 = [V_in_PA' V_in_PA_sq' V_in_PA_cu'];
V_out_PA_eff = V_out_PA';

V_gain1 = V_in_PA_eff1\V_out_PA_eff;
Vout_est1 = V_in_PA_eff1 * V_gain1;

Vout_comp = [V_out_PA' Vout_est1];
figure(7), hold on
plot(V_in_PA,V_out_PA, 'b')
%legend('actual data')
plot(V_in_PA,Vout_est1', 'm')
legend('actual data',' backslash curve fitting data' )
xlabel('Input voltage in volts')
ylabel('Output voltage in volts')
title('Actual and curve fitting data comparison in volts')

y_tx_sq = y_tx.^2;
y_tx_cu = y_tx.^3;

y_tx_eff = [y_tx' y_tx_sq' y_tx_cu'];
%y_pa_est = y_dac_eff * V_gain1;

y_tx_PA =  y_tx_eff*V_gain1;

Tx_Sig_fil = y_tx_PA'+(resolution*2); %addition of dc offset

%% XXXXXXXXXXXXXXXXXXXXXXXXXXXX QPSK demodulation XXXXXXXXXXXXXXXXXXXXXXXXXX
Rx_gain_dB = 0;
Rx_gain = 10^(Rx_gain_dB/20);
Rx_Sig_Fil = Tx_Sig_fil*Rx_gain;


%Addition of noise
%Rx_Sig_Fil = Tx_Sig_fil;

EbNo =10; % set EB/No in dB
snr = EbNo + 10*log10(k) - 10*log10(OSR); %Calculate the effective SNR in dB
Path_Loss_dB = 30;%Pathloss in dB
path_loss = 10^(-Path_Loss_dB/20);

noiseVariance = 10^(-snr/10);%calculation of noise variance
noise = sqrt(noiseVariance)* randn( 1, length(Tx_Sig_fil)); %Generation of noise
figure(5)
plot(noise+Tx_Sig_fil);
Rx_Sig_Fil = awgn(Tx_Sig_fil, snr, 'measured');% Add AWGN to the signal generated

%Rx_Sig_Fil = noise+Tx_Sig_fil; %addition of AWGN generated

Rx_Sig_Fil = Rx_Sig_Fil.*path_loss;

figure(3)
%tt1=(T)/100:(T)/100:((T)*length(Tx_Sig_fil)); %time vector spaced at Tc/99. where Tc = 1/fc
tt1=(T)/OSR:(T)/OSR:((T/OSR)*length(Tx_Sig_fil));
subplot(2,1,1);
plot(tt1,Tx_Sig_fil,'linewidth',3), grid on;
title(' wave form for inphase component in QPSK modulation ');
xlabel('time(sec)');
ylabel(' amplitude(volt0');

subplot(2,1,2);
plot(tt1,Rx_Sig_Fil,'linewidth',3), grid on;
title(' wave form for Quadrature component in QPSK modulation ');
xlabel('time(sec)');
ylabel(' amplitude(volt0');

Rx_Sig = upfirdn(Rx_Sig_Fil, rrcFilter, 1, OSR);% apply filtering and down-sample
Rx_data=[];
%Rx_sig=Tx_sig; % Received signal
Rx_sig = Rx_Sig(span+1:end-span);

%Perform coherent detection of the received QPSK signal with noise
for i=1:1:length(data)/2

    %%XXXXXX inphase coherent dector XXXXXXX
    Z_in=Rx_sig((i-1)*length(t)+1:i*length(t)).*cos(2*pi*fc*t+(po)); %extract a period of the 
    %signal received and multiply the received signal with the cosine component of the carrier signal
    
    Z_in_intg=(trapz(t,Z_in))*(2/T);% integration using Trapizodial rule 
                                    %over a period of half bit duration
 

    if(Z_in_intg>resolution) % Decision Maker
        Rx_in_data=1;
    else
       Rx_in_data=0; 
    end
    
    %%XXXXXX Quadrature coherent dector XXXXXX
    Z_qd=Rx_sig((i-1)*length(t)+1:i*length(t)).*sin(2*pi*fc*t+(po+pim));
    %above line indicat multiplication ofreceived & Quadphase carred signal
    
    Z_qd_intg=(trapz(t,Z_qd))*(2/T);%integration using trapizodial rull
        if (Z_qd_intg>resolution)% Decession Maker
            Rx_qd_data=1;
        else
            Rx_qd_data=0; 
        end
        
        
        Rx_data=[Rx_data  Rx_in_data  Rx_qd_data]; % Received Data vector
end



figure(4)
subplot(2,1,1)
stem(data,'linewidth',3) 
title('Information transmitted ');
axis([ 0 numBits 0 1.5]), grid on;
subplot(2,1,2)
stem(Rx_data,'linewidth',3) 
title('Information received ');
axis([ 0 numBits 0 1.5]), grid on;

%dataSymbolsOut = pskdemod(Rx_Sig, 2);
%Rx_data2 = dataSymbolsOut;
[numErrors, ber] = biterr(data', Rx_data);
fprintf('\nThe bit error rate = %5.2e, based on %d errors\n', ...
    ber, numErrors)


% XXXXXXXXXXXXXXXXXXXXXXXXX    end of program    XXXXXXXXXXXXXXXXXXXXXXXXXX