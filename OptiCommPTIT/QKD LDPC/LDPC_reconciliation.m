function [BER_eff,hashlen,key,eff] = LDPC_reconciliation(key_chan_Alice,key_chan_Bob,N,G,H,BER)

    % QKD key reconciliation
    % BER_eff = reconciliated key BER
    % hashlen = hash infomation bit number
    % key = reconciliated key
    % eff = reconciliation efficiency
    
    segmentNum = floor(length(key_chan_Alice)/(size(G,2)/N));
    
    keyAlice = zeros(1,segmentNum*size(G,2));
    keyBob = zeros(1,segmentNum*size(G,2));
    for i = 1:segmentNum*size(G,2)/N
        keyAlice((i-1)*N+1:i*N) = expandbit(key_chan_Alice(i),N);
        keyBob((i-1)*N+1:i*N) = expandbit(key_chan_Bob(i),N);
    end
    
    keyAlice = transpose(reshape(keyAlice,size(G,2),segmentNum)); %(0,1) segment
    keyBob = transpose(reshape(keyBob,size(G,2),segmentNum)); %(0,1) segment
    turns = zeros(1,segmentNum); % iteration turns
    dist_origin = zeros(1,segmentNum);
    dist_decoded = zeros(1,segmentNum);
    md5Alice = zeros(1,segmentNum);
    md5Bob = zeros(1,segmentNum);
    md5check = zeros(1,segmentNum);
    keyAliceDouble = double(transpose(reshape(key_chan_Alice(1:segmentNum*size(G,2)/N),size(G,2)/N,segmentNum)));
    keyBobDouble = zeros(segmentNum, size(G,2)/N);
    keyBob_d = zeros(segmentNum,size(G,2));
    
    % iterating decode
    for i = 1:segmentNum
        disp(['seg = ',num2str(i)])
        % Alice's action
        keyRand = ceil(rand(1,size(G,1)));
        d = abs(mod(keyRand*G,2) - keyAlice(i,:)); % d is transmitted to Bob
        
        % Bob's action
        rowBob = abs(keyBob(i,:) - d);
        [rout,turns(i)] = SP_LLR_decoder(H,rowBob,BER,zeros(1,size(H,1)));
        rowBob_d = abs(rout - d);
        keyBob_d(i,:) = rowBob_d;
        
        % analyze
        dist_origin(i) = sum(abs(keyAlice(i,:) - keyBob(i,:))); % not included in the reconciliation scheme
        dist_decoded(i) = sum(abs(keyAlice(i,:) - rowBob_d));   % not included in the reconciliation scheme
        
        for k = 1:size(G,2)/N
            keyBobDouble(i,k) = accuml(rowBob_d((k-1)*N+1: k*N),N);
        end
        
    end
    
    % hash check
    hashlen = 0;
    for i = 1:segmentNum
        [md5Alice(i),hashlen] = md5(keyAliceDouble(i,:));
        [md5Bob(i),hashlen] = md5(keyBobDouble(i,:));
        if(md5Alice(i) ~= md5Bob(i))
            md5check(i) = -1;
        end
    end
    
    % update BER and generate key
    key = [];
    biterr_eff = 0;
    for i = 1:segmentNum
        if(md5check(i) == 0)
            d = abs(keyBob(i,:) - keyBob_d(i,:));
            key = [key; keyBob_d(i,:)];
            biterr_eff = biterr_eff + sum(d(1,:) == 1);
        end
    end
    
    BER_eff = -1;
    D = segmentNum - abs((sum(md5check(1,:))));
    if(D ~= 0)
        BER_eff = biterr_eff/(D*size(G,2));
    end
    
%     for i = 1:segmentNum
%         disp(['segment: ',num2str(i),' iteration: ',num2str(turns(i)),' origin_dist: ',num2str(dist_origin(i)), ' decoded_dist: ', num2str(dist_decoded(i)), ' md5check: ',num2str(md5check(i))]);
%     end

    eff =D*size(G,2)/(N*length(key_chan_Alice));
        
end

function b = expandbit(a,N)
    a = double(a);
    b = zeros(1,N);
    
    for i = 0:N - 1
        if(mod(a,2) == 0)
            b(N - i) = 0;
        else
            b(N - i) = 1;
        end
        
        if(a<=1)
            break;
        else
            a = floor(a/2);
        end
    end
end

function [hashint,hashlen] = md5(key)
    hashlen = 128;
    md5obj = java.security.MessageDigest.getInstance('md5');
    hash = md5obj.digest(key);
    hashint = java.math.BigInteger(1,hash);
    hashint.toString(16);
end

function d = accuml(arr,N)
    d = 0;
    for i = 0:N-1
        d = d + (2^i)*arr(N-i);
    end
end
