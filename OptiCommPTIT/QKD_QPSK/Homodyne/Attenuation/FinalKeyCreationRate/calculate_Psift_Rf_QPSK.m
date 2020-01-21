function [P_sift]=calculate_Psift_Rf_QPSK(P_T_dBm) 
    P_sift=jointProbabilite_QPSK_Rf_AB(0,0,P_T_dBm)+jointProbabilite_QPSK_Rf_AB(0,1,P_T_dBm)...
           +jointProbabilite_QPSK_Rf_AB(1,0,P_T_dBm)+jointProbabilite_QPSK_Rf_AB(1,1,P_T_dBm);
end