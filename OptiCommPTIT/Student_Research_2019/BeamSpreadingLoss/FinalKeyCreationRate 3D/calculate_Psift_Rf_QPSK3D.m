function P_sift=calculate_Psift_Rf_QPSK3D(Y_P_T_dBm_rray) 
    P_sift=jointProbabilite_QPSK_Rf_AB3D(0,0,Y_P_T_dBm_rray)+jointProbabilite_QPSK_Rf_AB3D(0,1,Y_P_T_dBm_rray)...
           +jointProbabilite_QPSK_Rf_AB3D(1,0,Y_P_T_dBm_rray)+jointProbabilite_QPSK_Rf_AB3D(1,1,Y_P_T_dBm_rray);
end