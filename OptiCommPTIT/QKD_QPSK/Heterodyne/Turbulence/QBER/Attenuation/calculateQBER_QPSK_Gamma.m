function [QBER,P_sift]=calculateQBER_QPSK_Gamma(ScaleCo,P_T_dBm,C2n,Attenuation) 
    P_sift=jointProbabilite_QPSK_Gamma(0,0,ScaleCo,P_T_dBm,C2n,Attenuation)+jointProbabilite_QPSK_Gamma(0,1,ScaleCo,P_T_dBm,C2n,Attenuation)...
          +jointProbabilite_QPSK_Gamma(1,0,ScaleCo,P_T_dBm,C2n,Attenuation)+jointProbabilite_QPSK_Gamma(1,1,ScaleCo,P_T_dBm,C2n,Attenuation);
    P_error=jointProbabilite_QPSK_Gamma(0,1,ScaleCo,P_T_dBm,C2n,Attenuation)+jointProbabilite_QPSK_Gamma(1,0,ScaleCo,P_T_dBm,C2n,Attenuation);
    
    QBER=P_error/P_sift;
end