function [QBER_Gamma,P_sift_Gamma]=calculateQBER(ScaleCo,C2n)
    %Gamma-Gamma channels
    P_sift_Gamma=jointProbabiliteGamma(0,0,ScaleCo,C2n)+jointProbabiliteGamma(0,1,ScaleCo,C2n)+jointProbabiliteGamma(1,0,ScaleCo,C2n)+jointProbabiliteGamma(1,1,ScaleCo,C2n);
    P_error_Gamma=jointProbabiliteGamma(0,1,ScaleCo,C2n)+jointProbabiliteGamma(1,0,ScaleCo,C2n);
    QBER_Gamma=P_error_Gamma/P_sift_Gamma;
end