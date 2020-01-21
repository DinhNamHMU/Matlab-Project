function [QBER,P_sift]=calculateQBER_HAP(P_dBm)
    P_sift=jointProbabiliteGamma_AB_HAP(0,0,P_dBm)+jointProbabiliteGamma_AB_HAP(0,1,P_dBm)...
          +jointProbabiliteGamma_AB_HAP(1,0,P_dBm)+jointProbabiliteGamma_AB_HAP(1,1,P_dBm);
    P_error=jointProbabiliteGamma_AB_HAP(0,1,P_dBm)+jointProbabiliteGamma_AB_HAP(1,0,P_dBm);
    
    QBER=P_error/P_sift;
end