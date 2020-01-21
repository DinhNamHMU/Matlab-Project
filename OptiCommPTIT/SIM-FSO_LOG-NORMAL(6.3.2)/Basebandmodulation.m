function [Inphase,Quadrature,Datain]=Basebandmodulation(M,symb,N_sub)
    Datain=randi([0,M-1],[symb,N_sub]);
    H=modem.pskmod('M',M,'phaseoffset',pi/4,'SymbolOrder','gray');
    Y=modulate(H,Datain);
    Inphase=real(Y);
    Quadrature=imag(Y);
end

