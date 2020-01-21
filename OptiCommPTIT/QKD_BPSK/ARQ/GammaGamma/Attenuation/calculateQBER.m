function [QBER_Gamma,P_sift_Gamma]=calculateQBER(ScaleCo,C2n,Attenuation)
    %Gamma-Gamma channels
    P_sift_Gamma=jointProbabiliteGamma(0,0,ScaleCo,C2n,Attenuation)+jointProbabiliteGamma(0,1,ScaleCo,C2n,Attenuation)...
                 +jointProbabiliteGamma(1,0,ScaleCo,C2n,Attenuation)+jointProbabiliteGamma(1,1,ScaleCo,C2n,Attenuation);
    P_error_Gamma=jointProbabiliteGamma(0,1,ScaleCo,C2n,Attenuation)+jointProbabiliteGamma(1,0,ScaleCo,C2n,Attenuation);
    QBER_Gamma=P_error_Gamma/P_sift_Gamma;
end