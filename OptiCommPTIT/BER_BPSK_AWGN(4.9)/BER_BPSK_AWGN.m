%BER of BPSK Modulation in the AWGN Channel
clear;
clc; 

Rb = 1;                                                                  %Normalized bit rate
fc = Rb*5;                                                               %Carrier frequency;
Tb = 1/Rb;                                                               %Bit duration
SigLen = 1000;                                                           %Number of bits or symbols
fsamp = fc*10;                                                           %Sampling rate
nsamp = fsamp/Rb;                                                        %Samples per symbols
Tsamp = Tb/nsamp;                                                        %Sampling time
Eb=1;                                                                    %Energy per bit
Tx_filter = ones(1,nsamp);                                               %Transmitter filter
%bin_data = randint(1,SigLen);
bin_data=randi([0,1],[1,SigLen]);                                        %Generating prbs of length SigLen
data_format = 2*bin_data-1;                                              %BPSK constillation
t = Tsamp:Tsamp:Tb*SigLen;                                               %Time vector

carrier_signal=sqrt(2*Eb/nsamp)*sin(2*pi*fc*t);                          %Carrier signal
bin_signal = conv(Tx_filter,upsample(data_format,nsamp));
%bin_signal = rectpulse(OOK,nsamp);                                      %Rectangular pulse shaping
bin_signal = bin_signal(1:SigLen*nsamp);
Tx_signal = bin_signal.*carrier_signal;                                  %Transmitted signal

Eb_N0_dB = -3:10;                                                        %Multiple Eb/N0 values
for ii=1:length(Eb_N0_dB)
    Rx_signal=awgn(Tx_signal,Eb_N0_dB(ii)+3-10*log10(nsamp),'measured'); %Additive white gaussian noise
    
    Rx_output = Rx_signal.*carrier_signal;                               %Decoding process
    
    for jj=1:SigLen
        output(jj) = sum(MF_output((jj-1)* nsamp + 1:jj * nsamp));       %Matched filter output  
                                                                         %Alternatively method of matched filter is given in OOK simulation
    end
    rx_bin_data=zeros(1,SigLen);
    rx_bin_data(find(output>0)) = 1;
    [nerr(ii) ber(ii)] = biterr(rx_bin_data,bin_data);
end

%Plot function
figure
semilogy(Eb_N0_dB,ber,'bo','linewidth',2);
hold on
grid on
semilogy(Eb_N0_dB,0.5*erfc(sqrt(10.^(Eb_N0_dB/10))),'r-X','linewidth',2);