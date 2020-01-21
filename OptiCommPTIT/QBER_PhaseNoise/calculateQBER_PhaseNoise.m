function [QBER_Log_Phase,P_sift_Log_Phase]=calculateQBER_PhaseNoise(ScaleCo,DampingCo)
    %Log_normal channels with PLL-Phase Noise
    P_sift_Log_Phase=jointProbabiliteLogPhaseNoise(0,0,ScaleCo,DampingCo)+jointProbabiliteLogPhaseNoise(0,1,ScaleCo,DampingCo)...
                    +jointProbabiliteLogPhaseNoise(1,0,ScaleCo,DampingCo)+jointProbabiliteLogPhaseNoise(1,1,ScaleCo,DampingCo);
    P_error_Log_Phase=jointProbabiliteLogPhaseNoise(0,1,ScaleCo,DampingCo)+jointProbabiliteLogPhaseNoise(1,0,ScaleCo,DampingCo);
    QBER_Log_Phase=P_error_Log_Phase/P_sift_Log_Phase;
end