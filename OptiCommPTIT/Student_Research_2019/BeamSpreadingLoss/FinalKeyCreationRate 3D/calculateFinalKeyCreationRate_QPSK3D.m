function Rf_Mbps3D=calculateFinalKeyCreationRate_QPSK3D(X_r_Eve_Array,Y_P_T_dBm_rray)
    global Rb;
    alpha=0.5;
    
    P_sift=calculate_Psift_Rf_QPSK3D(Y_P_T_dBm_rray);
      
    Rs=P_sift.*Rb;
    
    p=2.*(jointProbabilite_QPSK_Rf_AB3D(0,0,Y_P_T_dBm_rray));
    q=2.*(0.5-jointProbabilite_QPSK_Rf_AB3D(0,0,Y_P_T_dBm_rray)-jointProbabilite_QPSK_Rf_AB3D(0,1,Y_P_T_dBm_rray));
    pe=2.*jointProbabilite_QPSK_Rf_AE3D(0,0,X_r_Eve_Array,Y_P_T_dBm_rray);
    
    I_AB=p.*log2(p)+(1-p-q).*log2(1-p-q)...
         -(alpha.*p+(1-alpha).*(1-p-q)).*log2(alpha.*p+(1-alpha).*(1-p-q))...
         -(alpha.*(1-p-q)+(1-alpha).*p).*log2(alpha.*(1-p-q)+(1-alpha).*p);
    I_AE=1+pe.*log2(pe)+(1-pe).*log2(1-pe);
    
    Rf=Rs.*(I_AB-I_AE);
    Rf_Mbps3D=Rf./(10.^6);
end