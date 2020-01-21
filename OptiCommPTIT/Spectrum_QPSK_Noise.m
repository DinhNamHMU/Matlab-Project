%Script for simulating the transmit spectrum of a QPSK modulated symbol affected by phase noise and thermal noise
clear;
clc;
N=10^5;                                                         %Number of symbols
os=4;                                                           %Oversampling factor
Es_N0_dB=40;
phi_rms_deg_vec=[0:1:5];
%Root raised cosine filter
t_by_Ts=[-4:1/os:4];
beta=0.5;
ht=(sin(pi*t_by_Ts*(1-beta))+4*beta*t_by_Ts.*cos(pi*t_by_Ts*(1+beta)))./(pi*t_by_Ts.*(1-(4*beta*t_by_Ts).^2));
ht((length(t_by_Ts)-1)/2+1)=1-beta+4*beta/pi;
ht([-os/(4*beta) os/(4*beta)]+(length(t_by_Ts)-1)/2+1) = beta/sqrt(2)*((1+2/pi)*sin(pi/(4*beta))+(1-2/pi)*cos(pi/(4*beta)));
ht=ht/sqrt(os);

for ii=1:length(Es_N0_dB)
	for jj=1:length(phi_rms_deg_vec)
	   %Transmitter
	   ip_re=rand(1,N)>0.5;                                     %Generating 0,1 with equal probability
	   ip_im=rand(1,N)>0.5;                                     %Generating 0,1 with equal probability
	   s = 1/sqrt(2)*(2*ip_re-1+j*(2*ip_im-1));                 %QPSK modulation 
	   % Pulse shaping 
	   s_os=[s ; zeros(os-1,length(s))];
	   s_os=s_os(:).';	
	   s_os=conv(ht,s_os);
	   s_os=s_os(1:os*N);	
	   % Thermal and Phase Noise addition
	   n=1/sqrt(2)*[randn(1,N*os)+j*randn(1,N*os)];             %Thermal noise 
	   phi=phi_rms_deg_vec(jj)*(pi/180)*randn(1,N*os)*sqrt(os); %Phase noise
	   y=s_os.*exp(j*phi)+10^(-Es_N0_dB(ii)/20)*n; 
	   %Computing the transmit spectrum
	   [Pxx1(jj,:) W2]=pwelch(y,[],[],1024,'twosided');
	   %Matched filtering
	   y_mf_out=conv(y,fliplr(ht));
	   y_mf_out=y_mf_out(length(ht):os:end);
	   %Error vector 
	   error_vec=(y_mf_out-s);	
	   evm(ii,jj)=error_vec*error_vec';	
	   theory_evm(ii,jj)=10^(-Es_N0_dB(ii)/10)+2-2*exp(-(phi_rms_deg_vec(jj)*pi/180).^2/2);
	end
end

%Plot function
figure;
plot([-512:511]/1024,10*log10(fftshift(Pxx1)));
xlabel('frequency, Hz'); ylabel('amplitude, dB');
legend('0 deg rms','1 deg rms', '2 deg rms', '3 deg rms', '4 deg rms', '5 deg rms');
title('spectrum Es/N0 = 40dB, root raised cosine filtering and different rms phase noise');
axis([-0.5 0.5 -50 5]); grid on;
