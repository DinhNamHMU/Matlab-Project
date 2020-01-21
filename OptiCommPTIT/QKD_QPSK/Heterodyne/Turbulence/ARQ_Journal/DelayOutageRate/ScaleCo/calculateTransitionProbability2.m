function [P]=calculateTransitionProbability2(count2,state2,M,B,p_gg,p_gb,p_bg,p_bb)
    P=zeros(count2,count2);
    
    %Part1
    for i=2:B 
        for j=1:M 
            P(findStateIndex2(i,'g',j,count2,state2),findStateIndex2(i-1,'g',1,count2,state2))=p_gg;
            P(findStateIndex2(i,'g',j,count2,state2),findStateIndex2(i-1,'b',1,count2,state2))=p_gb;
        end
    end
    
    %Part2
    for i=2:B
        for j=1:(M-1)
            P(findStateIndex2(i,'b',j,count2,state2),findStateIndex2(i,'g',j+1,count2,state2))=p_bg;
            P(findStateIndex2(i,'b',j,count2,state2),findStateIndex2(i,'b',j+1,count2,state2))=p_bb;
        end
    end
    
    %Part3
    for i=2:B 
        P(findStateIndex2(i,'b',M,count2,state2),findStateIndex2(i-1,'g',1,count2,state2))=p_bg;
        P(findStateIndex2(i,'b',M,count2,state2),findStateIndex2(i-1,'b',1,count2,state2))=p_bb;
    end
    
    %Part4
    for i=1:M 
        P(findStateIndex2(1,'g',i,count2,state2),findStateIndex2('s','s','s',count2,state2))=1;
    end
    
    %Part5
    for i=1:(M-1) 
        P(findStateIndex2(1,'b',i,count2,state2),findStateIndex2(1,'g',i+1,count2,state2))=p_bg;
        P(findStateIndex2(1,'b',i,count2,state2),findStateIndex2(1,'b',i+1,count2,state2))=p_bb;
    end
    
    %Part6
    P(findStateIndex2(1,'b',M,count2,state2),findStateIndex2('f','f','f',count2,state2))=1;
end