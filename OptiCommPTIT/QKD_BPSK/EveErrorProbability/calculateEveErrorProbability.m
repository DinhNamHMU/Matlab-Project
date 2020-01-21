function [e_Log,e_Gamma1,e_Gamma2]=calculateEveErrorProbability(ModDepth,g) 
     %Log-normal channels
     e_Log=jointProbabiliteLogEve(0,1,ModDepth,g)+jointProbabiliteLogEve(1,0,ModDepth,g);
     
     %Gamma-Gamma channels
     global C2n_1;
     global C2n_2;
     e_Gamma1=jointProbabiliteGammaEve(0,1,ModDepth,C2n_1,g)+jointProbabiliteGammaEve(1,0,ModDepth,C2n_1,g);
     e_Gamma2=jointProbabiliteGammaEve(0,1,ModDepth,C2n_2,g)+jointProbabiliteGammaEve(1,0,ModDepth,C2n_2,g);
end