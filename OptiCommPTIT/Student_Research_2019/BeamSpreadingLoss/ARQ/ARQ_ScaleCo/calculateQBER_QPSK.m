function [QBER,P_sift]=calculateQBER_QPSK(ScaleCo) 
    P_sift=jointProbabilite_QPSK(0,0,ScaleCo)+jointProbabilite_QPSK(0,1,ScaleCo)...
          +jointProbabilite_QPSK(1,0,ScaleCo)+jointProbabilite_QPSK(1,1,ScaleCo);
    P_error=jointProbabilite_QPSK(0,1,ScaleCo)+jointProbabilite_QPSK(1,0,ScaleCo);
    QBER=P_error/P_sift;
end