function blockp = key_privacy_amplify(BER,infolen,codewordlen,hashlen,key)
    
    codeRate = infolen/codewordlen;
    capacityBSC = 1 + BER*log2(BER) + (1-BER)*log2(1-BER);
    beta = codeRate/capacityBSC;
    hashRate = hashlen/codewordlen;
    secretKeyRate = beta*capacityBSC - hashRate;
    key = transpose(key);
    key = reshape(key,size(key,1)*size(key,2),1);
    
    m = secretKeyRate*length(key);
    n = length(key);
    unitLen = 100;
    toeplitzDescriptor = round(rand(1,m + n - 1)); % transmitted from Alice to Bob
    blockp = blockprod(toeplitzDescriptor,n,unitLen,key);
end

function vout = blockprod(d,n,unitLen,v)
    m = length(d) + 1 - n ;
    blockm = ceil(m/unitLen);
    blockn = ceil(n/unitLen);
    v = [v; zeros(blockn* unitLen - n,1)];
    
    vout = [];
    
    d  = [zeros(1,blockn * unitLen - n) d zeros(1,blockm * unitLen - m)];
    
    for i = 1:blockm
        
        vm = zeros(unitLen,1);
        
        for j = 1:blockn
            dij = [];
            if(i <= j)
                beg = unitLen*(blockn - j) + 1 + unitLen*(i - 1);
                dij = d(beg:beg - 2 + 2*unitLen);
            else
                edn = length(d) - (blockm - i)*unitLen - (j - 1)*unitLen;
                dij = d(edn - 2*unitLen + 2: edn);
            end
            
            Tij = getToeplitz(dij,unitLen);
            
            vm = vm + Tij*v(unitLen*(j-1) + 1:unitLen*j);
        end
        
        vout = [vout;vm];
    end
    
    vout = mod(vout(1:m),2);
end

function v = fastSquareToeplitzMulVector(d,n,v)
    % d length must be odd
    L = length(d);
    m = L+1-n;
    d1 = [d(n+1:L) d(n) d d(n) d(1:n-1)];
    C = getToeplitz(d1,L+1);
    v = [v;zeros(m,1)];
    v = fft(v);
    v = uint8(real(ifft(ifft(transpose(fft(C)))*v)));
    v = mod(v,2);
    v = v(1:m);
end

function T = getToeplitz(descriptor, n)
    % descriptor length = n + m - 1, n >= m or n < m 
    L = length(descriptor);
    m = L - n + 1;
    
    T = zeros(n,n);
    for i = 1:n
        for j = n - i + 1:n
            T(j - n + i ,j) = descriptor(i);
        end
    end
    
    for i = n + 1:m + n - 1
        for j = i - n + 1: m
            T(j, j - i + n) = descriptor(i);
        end
    end
    T = T(1:m,1:n);
end