function S_Gamma2=calculateErgodicSecretKeyRate3D_HAP2(X_r_Array,Y_ScaleCoArray)
    alpha=0.5;
    
    %Scenario 2 
    p_Gamma=jointProbabiliteGamma_AB_HAP(1,1,Y_ScaleCoArray);
    q_Gamma=jointProbabiliteGamma_AB_HAP(1,0,Y_ScaleCoArray);
    e_Gamma2=jointProbabiliteGamma_AE_HAP2(0,1,X_r_Array)+jointProbabiliteGamma_AE_HAP2(1,0,X_r_Array);
    
    I_AB_Gamma=p_Gamma.*log2(p_Gamma)+(1-p_Gamma-q_Gamma).*log2(1-p_Gamma-q_Gamma)...
         -(alpha.*p_Gamma+(1-alpha).*(1-p_Gamma-q_Gamma)).*log2(alpha.*p_Gamma+(1-alpha).*(1-p_Gamma-q_Gamma))...
         -(alpha.*(1-p_Gamma-q_Gamma)+(1-alpha).*p_Gamma).*log2(alpha.*(1-p_Gamma-q_Gamma)+(1-alpha).*p_Gamma);
    I_AE_Gamma2=1+e_Gamma2.*log2(e_Gamma2)+(1-e_Gamma2).*log2(1-e_Gamma2);
    
    S_Gamma2=I_AB_Gamma-I_AE_Gamma2;    
end
