function [QBER_Log_Phase_Damping,P_sift_Log_Phase_Damping]=calculateQBER_Damping(DampingCo,ScaleCo) 
    %Log_normal channels with PLL-Phase Noise versus Damping Coefficient
    P_sift_Log_Phase_Damping=jointProbabiliteLogPhaseNoiseDamping(0,0,DampingCo,ScaleCo)+jointProbabiliteLogPhaseNoiseDamping(0,1,DampingCo,ScaleCo)+jointProbabiliteLogPhaseNoiseDamping(1,0,DampingCo,ScaleCo)+jointProbabiliteLogPhaseNoiseDamping(1,1,DampingCo,ScaleCo);
    P_error_Log_Phase_Damping=jointProbabiliteLogPhaseNoiseDamping(0,1,DampingCo,ScaleCo)+jointProbabiliteLogPhaseNoiseDamping(1,0,DampingCo,ScaleCo);
    QBER_Log_Phase_Damping=P_error_Log_Phase_Damping/P_sift_Log_Phase_Damping;
end