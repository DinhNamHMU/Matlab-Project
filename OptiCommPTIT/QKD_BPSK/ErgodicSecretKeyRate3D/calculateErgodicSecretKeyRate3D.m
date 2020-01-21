function [S_Log,S_Gamma]=calculateErgodicSecretKeyRate3D(X_L_AE_Array,Y_ScaleCoArray)
    alpha=0.5;
    
    %Log-normal channels
    p_Log=2*(jointProbabiliteLogS_AB_3D(0,0,Y_ScaleCoArray));
    q_Log=2*(0.5-jointProbabiliteLogS_AB_3D(0,0,Y_ScaleCoArray)-jointProbabiliteLogS_AB_3D(0,1,Y_ScaleCoArray));
    pe_Log=2*jointProbabiliteLogS_AE_3D(0,0,X_L_AE_Array);
    
    I_AB_Log=p_Log.*log2(p_Log)+(1-p_Log-q_Log).*log2(1-p_Log-q_Log)...
         -(alpha.*p_Log+(1-alpha).*(1-p_Log-q_Log)).*log2(alpha.*p_Log+(1-alpha).*(1-p_Log-q_Log))...
         -(alpha.*(1-p_Log-q_Log)+(1-alpha).*p_Log).*log2(alpha.*(1-p_Log-q_Log)+(1-alpha).*p_Log);
    I_AE_Log=1+pe_Log.*log2(pe_Log)+(1-pe_Log).*log2(1-pe_Log);
    
    S_Log=I_AB_Log-I_AE_Log;
    
    %Gamma-Gamma channels
    p_Gamma=2*(jointProbabiliteGammaS_AB_3D(0,0,Y_ScaleCoArray));
    q_Gamma=2*(0.5-jointProbabiliteGammaS_AB_3D(0,0,Y_ScaleCoArray)-jointProbabiliteGammaS_AB_3D(0,1,Y_ScaleCoArray));
    pe_Gamma=2*jointProbabiliteGammaS_AE_3D(0,0,X_L_AE_Array);
    
    I_AB_Gamma=p_Gamma.*log2(p_Gamma)+(1-p_Gamma-q_Gamma).*log2(1-p_Gamma-q_Gamma)...
         -(alpha.*p_Gamma+(1-alpha).*(1-p_Gamma-q_Gamma)).*log2(alpha.*p_Gamma+(1-alpha).*(1-p_Gamma-q_Gamma))...
         -(alpha.*(1-p_Gamma-q_Gamma)+(1-alpha).*p_Gamma).*log2(alpha.*(1-p_Gamma-q_Gamma)+(1-alpha).*p_Gamma);
    I_AE_Gamma=1+pe_Gamma.*log2(pe_Gamma)+(1-pe_Gamma).*log2(1-pe_Gamma);
    
    S_Gamma=I_AB_Gamma-I_AE_Gamma;
end
