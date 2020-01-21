function [steadyStateIndex]=findSteadyStateIndex(P1,index,steadyStateQuantity) 
    for i=1:steadyStateQuantity 
        if P1(i)==index 
            steadyStateIndex=i;
            break;
        end
    end
end