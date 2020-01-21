function h_f =freq_gain_values(N)

% All frequency values are in MHz.
Fs = 100;  % Sampling Frequency
order = 3;   % Order
Fpass = 10;  % Passband Frequency
Fstop = 49;  % Stopband Frequency
Wpass = 1;   % Passband Weight
Wstop = 10;  % Stopband Weight
% Calculate the coefficients using the FIRLS function.
b  = firls(order, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Wpass Wstop]);
Hd = dfilt.dffir(b);

H = freqz(Hd,130);
h_f = abs(H(1:N)/H(1))';