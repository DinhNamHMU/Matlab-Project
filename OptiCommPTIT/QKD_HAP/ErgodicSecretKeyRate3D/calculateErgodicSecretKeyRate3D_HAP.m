function S_Gamma=calculateErgodicSecretKeyRate3D_HAP(X_r_Array,Y_ScaleCoArray)
    alpha=0.5;
    
    %Scenario 1 
    p_Gamma=jointProbabiliteGamma_AB_HAP(1,1,Y_ScaleCoArray);
    q_Gamma=jointProbabiliteGamma_AB_HAP(1,0,Y_ScaleCoArray);
    e_Gamma=jointProbabiliteGamma_AE_HAP1(0,1,X_r_Array)+jointProbabiliteGamma_AE_HAP1(1,0,X_r_Array);
    
    I_AB_Gamma=p_Gamma.*log2(p_Gamma)+(1-p_Gamma-q_Gamma).*log2(1-p_Gamma-q_Gamma)...
         -(alpha.*p_Gamma+(1-alpha).*(1-p_Gamma-q_Gamma)).*log2(alpha.*p_Gamma+(1-alpha).*(1-p_Gamma-q_Gamma))...
         -(alpha.*(1-p_Gamma-q_Gamma)+(1-alpha).*p_Gamma).*log2(alpha.*(1-p_Gamma-q_Gamma)+(1-alpha).*p_Gamma);
    I_AE_Gamma=1+e_Gamma.*log2(e_Gamma)+(1-e_Gamma).*log2(1-e_Gamma);
    
    S_Gamma=I_AB_Gamma-I_AE_Gamma;
end
