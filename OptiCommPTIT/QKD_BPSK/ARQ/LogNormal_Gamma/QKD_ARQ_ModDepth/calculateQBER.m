function [QBER_Log,P_sift_Log,QBER_Gamma,P_sift_Gamma]=calculateQBER(ModDepth)
    %Log-normal channels
    P_sift_Log=jointProbabiliteLog(0,0,ModDepth)+jointProbabiliteLog(0,1,ModDepth)+jointProbabiliteLog(1,0,ModDepth)+jointProbabiliteLog(1,1,ModDepth);
    P_error_Log=jointProbabiliteLog(0,1,ModDepth)+jointProbabiliteLog(1,0,ModDepth);
    QBER_Log=P_error_Log/P_sift_Log;

    %Gamma-Gamma channels
    P_sift_Gamma=jointProbabiliteGamma(0,0,ModDepth)+jointProbabiliteGamma(0,1,ModDepth)+jointProbabiliteGamma(1,0,ModDepth)+jointProbabiliteGamma(1,1,ModDepth);
    P_error_Gamma=jointProbabiliteGamma(0,1,ModDepth)+jointProbabiliteGamma(1,0,ModDepth);
    QBER_Gamma=P_error_Gamma/P_sift_Gamma;
end