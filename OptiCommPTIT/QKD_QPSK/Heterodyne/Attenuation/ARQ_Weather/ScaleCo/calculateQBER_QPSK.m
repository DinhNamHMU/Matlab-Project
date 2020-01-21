function [QBER,P_sift]=calculateQBER_QPSK(ScaleCo,alpha1) 
    P_sift=jointProbabilite_QPSK(0,0,ScaleCo,alpha1)+jointProbabilite_QPSK(0,1,ScaleCo,alpha1)...
          +jointProbabilite_QPSK(1,0,ScaleCo,alpha1)+jointProbabilite_QPSK(1,1,ScaleCo,alpha1);
    P_error=jointProbabilite_QPSK(0,1,ScaleCo,alpha1)+jointProbabilite_QPSK(1,0,ScaleCo,alpha1);
    QBER=P_error/P_sift;
end