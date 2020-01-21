function [P_sift_Log,P_sift_Gamma1,P_sift_Gamma2]=calculatePsiftRf(P_dBm) 
    %Log-normal channels
    P_sift_Log=jointProbabiliteLogRf_AB(0,0,P_dBm)+jointProbabiliteLogRf_AB(0,1,P_dBm)+jointProbabiliteLogRf_AB(1,0,P_dBm)+jointProbabiliteLogRf_AB(1,1,P_dBm);

    %Gamma-Gamma channels
    global C2n_1; 
    global C2n_2; 
    P_sift_Gamma1=jointProbabiliteGammaRf_AB(0,0,P_dBm,C2n_1)+jointProbabiliteGammaRf_AB(0,1,P_dBm,C2n_1)+jointProbabiliteGammaRf_AB(1,0,P_dBm,C2n_1)+jointProbabiliteGammaRf_AB(1,1,P_dBm,C2n_1);
    P_sift_Gamma2=jointProbabiliteGammaRf_AB(0,0,P_dBm,C2n_2)+jointProbabiliteGammaRf_AB(0,1,P_dBm,C2n_2)+jointProbabiliteGammaRf_AB(1,0,P_dBm,C2n_2)+jointProbabiliteGammaRf_AB(1,1,P_dBm,C2n_2);
end