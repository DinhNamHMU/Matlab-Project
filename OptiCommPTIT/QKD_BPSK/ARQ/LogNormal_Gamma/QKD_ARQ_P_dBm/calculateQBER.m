function [QBER_Log,P_sift_Log,QBER_Gamma,P_sift_Gamma]=calculateQBER(P_dBm)
    %Log-normal channels
    P_sift_Log=jointProbabiliteLog(0,0,P_dBm)+jointProbabiliteLog(0,1,P_dBm)+jointProbabiliteLog(1,0,P_dBm)+jointProbabiliteLog(1,1,P_dBm);
    P_error_Log=jointProbabiliteLog(0,1,P_dBm)+jointProbabiliteLog(1,0,P_dBm);
    QBER_Log=P_error_Log/P_sift_Log;

    %Gamma-Gamma channels
    P_sift_Gamma=jointProbabiliteGamma(0,0,P_dBm)+jointProbabiliteGamma(0,1,P_dBm)+jointProbabiliteGamma(1,0,P_dBm)+jointProbabiliteGamma(1,1,P_dBm);
    P_error_Gamma=jointProbabiliteGamma(0,1,P_dBm)+jointProbabiliteGamma(1,0,P_dBm);
    QBER_Gamma=P_error_Gamma/P_sift_Gamma;
end