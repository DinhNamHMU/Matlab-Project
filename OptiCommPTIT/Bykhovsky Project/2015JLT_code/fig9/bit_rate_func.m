function [r_m, sinr_mn] = bit_rate_func(rho,p_mn)

global K Pt h_kmn noise

N1 = size(rho,2);

if length(size(rho)) ~= 2
    warning('!!!')
end

power_mn = Pt*rho./repmat(sum(rho,2),1,N1);
power_mn(isnan(power_mn)) = 0;
if nargin == 2    
    [r,~] = find(p_mn);
    p_allocated_idx = unique(r); % m* - that are power allocated
    power_mn(p_allocated_idx,:) = power_mn(p_allocated_idx,:).*p_mn(p_allocated_idx,:);
end

sinr_mn = zeros(K,N1);
for m = 1:K % for all transmitters
    for n = 1:N1        
        if rho(m,n)
            interf_mask = rho(:,n);
            interf_mask(m) = 0;
            interf_power = sum(h_kmn(:,m,n).^2.*power_mn(:,n).*interf_mask);
            sinr_mn(m,n) = h_kmn(m,m,n)^2 * power_mn(m,n)/(noise+ interf_power);
        end
    end
end

r_m = nansum(bits_snr(sinr_mn),2);
