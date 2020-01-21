function [QBER,P_sift]=calculateQBER_BPSK_Gamma(ScaleCo,P_T_dBm,C2n) 
    P_sift=jointProbabilite_SIM_Gamma(0,0,ScaleCo,P_T_dBm,C2n)+jointProbabilite_SIM_Gamma(0,1,ScaleCo,P_T_dBm,C2n)...
          +jointProbabilite_SIM_Gamma(1,0,ScaleCo,P_T_dBm,C2n)+jointProbabilite_SIM_Gamma(1,1,ScaleCo,P_T_dBm,C2n);
    P_error=jointProbabilite_SIM_Gamma(0,1,ScaleCo,P_T_dBm,C2n)+jointProbabilite_SIM_Gamma(1,0,ScaleCo,P_T_dBm,C2n);
    
    QBER=P_error/P_sift;
end