function [QBER,P_sift]=calculateQBER_HAP(ScaleCo)
    P_sift=jointProbabiliteGamma_AB_HAP(0,0,ScaleCo)+jointProbabiliteGamma_AB_HAP(0,1,ScaleCo)...
          +jointProbabiliteGamma_AB_HAP(1,0,ScaleCo)+jointProbabiliteGamma_AB_HAP(1,1,ScaleCo);
    P_error=jointProbabiliteGamma_AB_HAP(0,1,ScaleCo)+jointProbabiliteGamma_AB_HAP(1,0,ScaleCo);
    
    QBER=P_error/P_sift;
end