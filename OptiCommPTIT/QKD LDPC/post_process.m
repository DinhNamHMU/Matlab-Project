function [safeKey, REC_eff, SafeKeyRate] = post_process(G,H,key_chan_Alice,key_chan_Bob,N)
    
    siftedKeyLength = N*length(key_chan_Alice);
    [BER_estimated,key_chan_Alice,key_chan_Bob] = BER_estimate(key_chan_Alice,key_chan_Bob,N);
    
    [BER_eff,hashlen,key,REC_eff] = LDPC_reconciliation(key_chan_Alice,key_chan_Bob,N,G,H,BER_estimated);
    
    safeKey = [];
    if(length(key)~= 0)
        safeKey = key_privacy_amplify(BER_eff,size(G,1),size(G,2),hashlen,key);
    end
    SafeKeyRate = length(safeKey)/(N*length(key_chan_Alice));
end