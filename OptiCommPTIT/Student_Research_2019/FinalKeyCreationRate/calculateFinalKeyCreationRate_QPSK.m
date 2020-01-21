function Rf_Mbps=calculateFinalKeyCreationRate_QPSK(P_T_dBm)
    global Rb;
    alpha=0.5;
    
    P_sift=calculate_Psift_Rf_QPSK(P_T_dBm);
      
    Rs=P_sift*Rb;
    
    p=2*(jointProbabilite_QPSK_Rf_AB(0,0,P_T_dBm));
    q=2*(0.5-jointProbabilite_QPSK_Rf_AB(0,0,P_T_dBm)-jointProbabilite_QPSK_Rf_AB(0,1,P_T_dBm));
    pe=2*jointProbabilite_QPSK_Rf_AE(0,0,P_T_dBm);
    
    I_AB=p*log2(p)+(1-p-q)*log2(1-p-q)...
         -(alpha*p+(1-alpha)*(1-p-q))*log2(alpha*p+(1-alpha)*(1-p-q))...
         -(alpha*(1-p-q)+(1-alpha)*p)*log2(alpha*(1-p-q)+(1-alpha)*p);
    I_AE=1+pe*log2(pe)+(1-pe)*log2(1-pe);
    
    Rf=Rs*(I_AB-I_AE);
    Rf_Mbps=Rf/(10^6);
end