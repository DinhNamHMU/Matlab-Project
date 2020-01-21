function [BER,key_chan_Alice,key_chan_Bob] = BER_estimate(key_chan_Alice,key_chan_Bob,N)
    keyLength = length(key_chan_Alice);
    sampleLength = 100;
    
    sampleAlice = double(key_chan_Alice(keyLength-sampleLength + 1:keyLength));
    sampleBob = double(key_chan_Bob(keyLength-sampleLength + 1:keyLength));
    
    sample = sampleAlice - sampleBob;

    SER = sum(sample(:,1) ~= 0)/sampleLength;
    BER = SER/log2(N);
    key_chan_Alice = key_chan_Alice(1:keyLength-sampleLength);
    key_chan_Bob = key_chan_Bob(1:keyLength-sampleLength);
end