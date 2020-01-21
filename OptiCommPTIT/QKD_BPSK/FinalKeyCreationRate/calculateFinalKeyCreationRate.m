function [Rf_Log_Mbps,Rf_Gamma1_Mbps,Rf_Gamma2_Mbps]=calculateFinalKeyCreationRate(P_dBm)
    global Rb;
    alpha=0.5;
    
    [P_sift_Log,P_sift_Gamma1,P_sift_Gamma2]=calculatePsiftRf(P_dBm);
    
    %Log-normal channels   
    Rs_Log=P_sift_Log*Rb;
    
    p_Log=2*(jointProbabiliteLogRf_AB(0,0,P_dBm));
    q_Log=2*(0.5-jointProbabiliteLogRf_AB(0,0,P_dBm)-jointProbabiliteLogRf_AB(0,1,P_dBm));
    pe_Log=2*jointProbabiliteLogRf_AE(0,0,P_dBm);
    
    I_AB_Log=p_Log*log2(p_Log)+(1-p_Log-q_Log)*log2(1-p_Log-q_Log)...
         -(alpha*p_Log+(1-alpha)*(1-p_Log-q_Log))*log2(alpha*p_Log+(1-alpha)*(1-p_Log-q_Log))...
         -(alpha*(1-p_Log-q_Log)+(1-alpha)*p_Log)*log2(alpha*(1-p_Log-q_Log)+(1-alpha)*p_Log);
    I_AE_Log=1+pe_Log*log2(pe_Log)+(1-pe_Log)*log2(1-pe_Log);
    
    Rf_Log=Rs_Log*(I_AB_Log-I_AE_Log);
    Rf_Log_Mbps=Rf_Log/(10^6);
    
    %Gamma-Gamma channels
    global C2n_1;  
    global C2n_2; 
    
    %Refractive index structure coefficient 1
    Rs_Gamma1=P_sift_Gamma1*Rb;
    
    p_Gamma1=2*(jointProbabiliteGammaRf_AB(0,0,P_dBm,C2n_1));
    q_Gamma1=2*(0.5-jointProbabiliteGammaRf_AB(0,0,P_dBm,C2n_1)-jointProbabiliteGammaRf_AB(0,1,P_dBm,C2n_1));
    pe_Gamma1=2*jointProbabiliteGammaRf_AE(0,0,P_dBm,C2n_1);
    
    I_AB_Gamma1=p_Gamma1*log2(p_Gamma1)+(1-p_Gamma1-q_Gamma1)*log2(1-p_Gamma1-q_Gamma1)...
         -(alpha*p_Gamma1+(1-alpha)*(1-p_Gamma1-q_Gamma1))*log2(alpha*p_Gamma1+(1-alpha)*(1-p_Gamma1-q_Gamma1))...
         -(alpha*(1-p_Gamma1-q_Gamma1)+(1-alpha)*p_Gamma1)*log2(alpha*(1-p_Gamma1-q_Gamma1)+(1-alpha)*p_Gamma1);
    I_AE_Gamma1=1+pe_Gamma1*log2(pe_Gamma1)+(1-pe_Gamma1)*log2(1-pe_Gamma1);
    
    Rf_Gamma1=Rs_Gamma1*(I_AB_Gamma1-I_AE_Gamma1);
    Rf_Gamma1_Mbps=Rf_Gamma1/(10^6);

    %Refractive index structure coefficient 2
    Rs_Gamma2=P_sift_Gamma2*Rb;
    
    p_Gamma2=2*(jointProbabiliteGammaRf_AB(0,0,P_dBm,C2n_2));
    q_Gamma2=2*(0.5-jointProbabiliteGammaRf_AB(0,0,P_dBm,C2n_2)-jointProbabiliteGammaRf_AB(0,1,P_dBm,C2n_2));
    pe_Gamma2=2*jointProbabiliteGammaRf_AE(0,0,P_dBm,C2n_2);
    
    I_AB_Gamma2=p_Gamma2*log2(p_Gamma2)+(1-p_Gamma2-q_Gamma2)*log2(1-p_Gamma2-q_Gamma2)...
         -(alpha*p_Gamma2+(1-alpha)*(1-p_Gamma2-q_Gamma2))*log2(alpha*p_Gamma2+(1-alpha)*(1-p_Gamma2-q_Gamma2))...
         -(alpha*(1-p_Gamma2-q_Gamma2)+(1-alpha)*p_Gamma2)*log2(alpha*(1-p_Gamma2-q_Gamma2)+(1-alpha)*p_Gamma2);
    I_AE_Gamma2=1+pe_Gamma2*log2(pe_Gamma2)+(1-pe_Gamma2)*log2(1-pe_Gamma2);
    
    Rf_Gamma2=Rs_Gamma2*(I_AB_Gamma2-I_AE_Gamma2);
    Rf_Gamma2_Mbps=Rf_Gamma2/(10^6);
end