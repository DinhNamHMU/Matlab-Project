function [P_sift]=calculate_Psift_Rf(P_T_dBm,ScaleCo,C2n) 
    P_sift=jointProbabilite_QPSK_Rf_AB(0,0,ScaleCo,P_T_dBm,C2n)+jointProbabilite_QPSK_Rf_AB(0,1,ScaleCo,P_T_dBm,C2n)...
           +jointProbabilite_QPSK_Rf_AB(1,0,ScaleCo,P_T_dBm,C2n)+jointProbabilite_QPSK_Rf_AB(1,1,ScaleCo,P_T_dBm,C2n);
end