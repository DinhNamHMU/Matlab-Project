function [QBER_Log,P_sift_Log,QBER_Gamma,P_sift_Gamma]=calculateQBER(ScaleCo)
    %Log-normal channels
    P_sift_Log=jointProbabiliteLog(0,0,ScaleCo)+jointProbabiliteLog(0,1,ScaleCo)...
               +jointProbabiliteLog(1,0,ScaleCo)+jointProbabiliteLog(1,1,ScaleCo);
    P_error_Log=jointProbabiliteLog(0,1,ScaleCo)+jointProbabiliteLog(1,0,ScaleCo);
    QBER_Log=P_error_Log/P_sift_Log;

    %Gamma-Gamma channels
    P_sift_Gamma=jointProbabiliteGamma(0,0,ScaleCo)+jointProbabiliteGamma(0,1,ScaleCo)...
                 +jointProbabiliteGamma(1,0,ScaleCo)+jointProbabiliteGamma(1,1,ScaleCo);
    P_error_Gamma=jointProbabiliteGamma(0,1,ScaleCo)+jointProbabiliteGamma(1,0,ScaleCo);
    QBER_Gamma=P_error_Gamma/P_sift_Gamma;
end