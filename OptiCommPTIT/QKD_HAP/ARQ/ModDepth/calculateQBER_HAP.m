function [QBER,P_sift]=calculateQBER_HAP(ModDepth)
    P_sift=jointProbabiliteGamma_AB_HAP(0,0,ModDepth)+jointProbabiliteGamma_AB_HAP(0,1,ModDepth)...
          +jointProbabiliteGamma_AB_HAP(1,0,ModDepth)+jointProbabiliteGamma_AB_HAP(1,1,ModDepth);
    P_error=jointProbabiliteGamma_AB_HAP(0,1,ModDepth)+jointProbabiliteGamma_AB_HAP(1,0,ModDepth);
    
    QBER=P_error/P_sift;
end