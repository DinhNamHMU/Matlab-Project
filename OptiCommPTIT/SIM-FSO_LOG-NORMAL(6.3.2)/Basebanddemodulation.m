function [Dataout]=Basebanddemodulation(M,Demod_out2) 
    h = modem.pskdemod('M',M,'phaseoffset',pi/4,'SymbolOrder','gray');
    Dataout=demodulate(h,Demod_out2);
end