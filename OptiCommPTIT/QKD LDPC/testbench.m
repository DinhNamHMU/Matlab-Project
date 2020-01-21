function [] = testbench()

    load('data\LDPC');
    
    N = 4;
    BER_real = 0.08;
    [key_chan_Alice,key_chan_Bob,BER_real] = generatekey(19587,N,BER_real);
    
    disp(['testbench BER = ',num2str(BER_real)]);
    [SafeKey,ReconciliationRate,KeyRate] = post_process(G,H,key_chan_Alice,key_chan_Bob,N);
    disp(['Generate ',num2str(length(SafeKey)),' bits safe key from ',num2str(N*length(key_chan_Alice))])
    disp(['Safe key rate = ', num2str(KeyRate)]);
    disp(['Reconciliation efficiency = ',num2str(ReconciliationRate)]);
   
end

function [keyA,keyB,BER_real] = generatekey(keylen,N,BER)
    keyA = floor(rand(keylen,1)*(2^N));
    keyB = zeros(keylen,1);
    flip = zeros(keylen*N,1);
    for i = 1:keylen*N
        if(BER > rand())
            flip(i) = 1;
        end
    end
    for j = 1:keylen
        mask = 0 ;
        for k = 1:N
            mask = mask + power(2,N-k)*flip(N*(j-1)+k);
        end
        keyB(j) = bitxor(keyA(j),mask);
    end
    BER_real = sum(flip(:,1) == 1)/(keylen*N);
end