function [S]=calculateErgodicSecretKeyRate3D_QPSK(X_r_Eve_Array,Y_ScaleCoArray)
    alpha=0.5;
        
    p=2*(jointProbabilite_QPSK_S_AB_3D(0,0,Y_ScaleCoArray));
    q=2*(0.5-jointProbabilite_QPSK_S_AB_3D(0,0,Y_ScaleCoArray)-jointProbabilite_QPSK_S_AB_3D(0,1,Y_ScaleCoArray));
    pe=2*jointProbabilite_QPSK_S_AE_3D(0,0,X_r_Eve_Array);
    
    I_AB=p.*log2(p)+(1-p-q).*log2(1-p-q)...
         -(alpha.*p+(1-alpha).*(1-p-q)).*log2(alpha.*p+(1-alpha).*(1-p-q))...
         -(alpha.*(1-p-q)+(1-alpha).*p).*log2(alpha.*(1-p-q)+(1-alpha).*p);
    I_AE=1+pe.*log2(pe)+(1-pe).*log2(1-pe);
    
    S=I_AB-I_AE;
end
