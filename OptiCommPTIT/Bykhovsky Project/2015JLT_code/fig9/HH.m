function [bits,p,p_ratio] = HH(snr,target)

G = qfuncinv(1e-3/2)^2/3;
power = @(bits,snr) (2.^bits - 1)*G./snr;

N = length(snr);

if nargin == 1
    target = Inf;
    N_target = N;
else
    N_target = Inf;
end

bits = zeros(1,N);
while nansum(power(bits, snr)) < N_target && sum(bits) <= target
    delta_p = power(bits + 1, snr) - power(bits, snr);
    [~,index_min_add]=min(delta_p); 
    bits(index_min_add)=bits(index_min_add)+1; 
end
bits(index_min_add)=bits(index_min_add)-1;

p = power(bits,snr);
p(isnan(p)) = 0;
%p = p'*N/sum(p);
p_ratio = sum(p)/N;