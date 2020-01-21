function [QBER,P_sift]=calculateQBER_QPSK(ScaleCo,P_T_dBm) 
    P_sift=jointProbabilite_QPSK(0,0,ScaleCo,P_T_dBm)+jointProbabilite_QPSK(0,1,ScaleCo,P_T_dBm)+jointProbabilite_QPSK(1,0,ScaleCo,P_T_dBm)+jointProbabilite_QPSK(1,1,ScaleCo,P_T_dBm);
    P_error=jointProbabilite_QPSK(0,1,ScaleCo,P_T_dBm)+jointProbabilite_QPSK(1,0,ScaleCo,P_T_dBm);
    QBER=P_error/P_sift;
end