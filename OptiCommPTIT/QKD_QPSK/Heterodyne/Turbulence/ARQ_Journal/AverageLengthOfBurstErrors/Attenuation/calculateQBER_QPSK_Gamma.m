function [QBER,P_sift]=calculateQBER_QPSK_Gamma(Attenuation,ScaleCo,P_T_dBm,C2n) 
    P_sift=jointProbabilite_QPSK_Gamma(0,0,Attenuation,ScaleCo,P_T_dBm,C2n)+jointProbabilite_QPSK_Gamma(0,1,Attenuation,ScaleCo,P_T_dBm,C2n)...
          +jointProbabilite_QPSK_Gamma(1,0,Attenuation,ScaleCo,P_T_dBm,C2n)+jointProbabilite_QPSK_Gamma(1,1,Attenuation,ScaleCo,P_T_dBm,C2n);
    P_error=jointProbabilite_QPSK_Gamma(0,1,Attenuation,ScaleCo,P_T_dBm,C2n)+jointProbabilite_QPSK_Gamma(1,0,Attenuation,ScaleCo,P_T_dBm,C2n);
    
    QBER=P_error/P_sift;
end