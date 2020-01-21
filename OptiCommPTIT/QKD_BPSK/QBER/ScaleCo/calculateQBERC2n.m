function [QBER_Gamma_C2n,P_sift_Gamma_C2n]=calculateQBERC2n(ScaleCo,C2n)
    P_sift_Gamma_C2n=jointProbabiliteGammaC2n(0,0,ScaleCo,C2n)+jointProbabiliteGammaC2n(0,1,ScaleCo,C2n)...
                     +jointProbabiliteGammaC2n(1,0,ScaleCo,C2n)+jointProbabiliteGammaC2n(1,1,ScaleCo,C2n);
    P_error_Gamma_C2n=jointProbabiliteGammaC2n(0,1,ScaleCo,C2n)+jointProbabiliteGammaC2n(1,0,ScaleCo,C2n);
    QBER_Gamma_C2n=P_error_Gamma_C2n/P_sift_Gamma_C2n;
end