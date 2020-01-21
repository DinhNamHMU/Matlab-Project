function b = bits_snr(snr) 

G = qfuncinv(1e-3/2)^2/3;
b = log2(1 + snr/G);