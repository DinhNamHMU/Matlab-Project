function [P2,P1,count]=calculateTransitionProbability(stateQuantity,state,lamda,T,M,B,p_gg,p_gb,p_bg,p_bb) 
    P=zeros(stateQuantity,stateQuantity);
    count=0;
    
    %Part 1
    count=count+1;
    P1(count)=findStateIndex(0,'g',1,stateQuantity,state);
    P(findStateIndex(0,'g',1,stateQuantity,state),findStateIndex(0,'g',1,stateQuantity,state))=(1-lamda*T)*p_gg;
    P(findStateIndex(0,'g',1,stateQuantity,state),findStateIndex(0,'b',1,stateQuantity,state))=(1-lamda*T)*p_gb;
    P(findStateIndex(0,'g',1,stateQuantity,state),findStateIndex(1,'g',1,stateQuantity,state))=lamda*T*p_gg;
    P(findStateIndex(0,'g',1,stateQuantity,state),findStateIndex(1,'b',1,stateQuantity,state))=lamda*T*p_gb;
    
    %Part 2
    for i=1:(B-1)
        for j=1:M
           count=count+1;
           P1(count)=findStateIndex(i,'g',j,stateQuantity,state);
           P(findStateIndex(i,'g',j,stateQuantity,state),findStateIndex(i-1,'g',1,stateQuantity,state))=(1-lamda*T)*p_gg;
           P(findStateIndex(i,'g',j,stateQuantity,state),findStateIndex(i-1,'b',1,stateQuantity,state))=(1-lamda*T)*p_gb;
           P(findStateIndex(i,'g',j,stateQuantity,state),findStateIndex(i,'g',1,stateQuantity,state))=lamda*T*p_gg;
           P(findStateIndex(i,'g',j,stateQuantity,state),findStateIndex(i,'b',1,stateQuantity,state))=lamda*T*p_gb;
        end
    end
    
    %Part 3
    for i=1:M
        count=count+1;
        P1(count)=findStateIndex(B,'g',i,stateQuantity,state);
        P(findStateIndex(B,'g',i,stateQuantity,state),findStateIndex(B-1,'g',1,stateQuantity,state))=p_gg;
        P(findStateIndex(B,'g',i,stateQuantity,state),findStateIndex(B-1,'b',1,stateQuantity,state))=p_gb;
    end
    
    %Part 4
    count=count+1;
    P1(count)=findStateIndex(0,'b',1,stateQuantity,state);
    P(findStateIndex(0,'b',1,stateQuantity,state),findStateIndex(0,'g',1,stateQuantity,state))=(1-lamda*T)*p_bg;
    P(findStateIndex(0,'b',1,stateQuantity,state),findStateIndex(0,'b',1,stateQuantity,state))=(1-lamda*T)*p_bb;
    P(findStateIndex(0,'b',1,stateQuantity,state),findStateIndex(1,'g',1,stateQuantity,state))=lamda*T*p_bg;
    P(findStateIndex(0,'b',1,stateQuantity,state),findStateIndex(1,'b',1,stateQuantity,state))=lamda*T*p_bb;
    
    %Part 5
    for i=1:(B-1) 
        for j=1:(M-1)
            count=count+1;
            P1(count)=findStateIndex(i,'b',j,stateQuantity,state);
            P(findStateIndex(i,'b',j,stateQuantity,state),findStateIndex(i,'g',j+1,stateQuantity,state))=(1-lamda*T)*p_bg;
            P(findStateIndex(i,'b',j,stateQuantity,state),findStateIndex(i,'b',j+1,stateQuantity,state))=(1-lamda*T)*p_bb;
            P(findStateIndex(i,'b',j,stateQuantity,state),findStateIndex(i+1,'g',j+1,stateQuantity,state))=lamda*T*p_bg;
            P(findStateIndex(i,'b',j,stateQuantity,state),findStateIndex(i+1,'b',j+1,stateQuantity,state))=lamda*T*p_bb;
        end
    end
    
    %Part 6
    for i=1:(B-1)
        count=count+1;
        P1(count)=findStateIndex(i,'b',M,stateQuantity,state);
        P(findStateIndex(i,'b',M,stateQuantity,state),findStateIndex(i-1,'g',1,stateQuantity,state))=(1-lamda*T)*p_bg;
        P(findStateIndex(i,'b',M,stateQuantity,state),findStateIndex(i-1,'b',1,stateQuantity,state))=(1-lamda*T)*p_bb;
        P(findStateIndex(i,'b',M,stateQuantity,state),findStateIndex(i,'g',1,stateQuantity,state))=lamda*T*p_bg;
        P(findStateIndex(i,'b',M,stateQuantity,state),findStateIndex(i,'b',1,stateQuantity,state))=lamda*T*p_bb;
    end
    
    %Part 7
    for i=1:(M-1)
        count=count+1;
        P1(count)=findStateIndex(B,'b',i,stateQuantity,state);
        P(findStateIndex(B,'b',i,stateQuantity,state),findStateIndex(B,'g',i+1,stateQuantity,state))=p_bg;
        P(findStateIndex(B,'b',i,stateQuantity,state),findStateIndex(B,'b',i+1,stateQuantity,state))=p_bb;
    end
    
    %Part 8
    count=count+1;
    P1(count)=findStateIndex(B,'b',M,stateQuantity,state);
    P(findStateIndex(B,'b',M,stateQuantity,state),findStateIndex(B-1,'g',1,stateQuantity,state))=p_bg;
    P(findStateIndex(B,'b',M,stateQuantity,state),findStateIndex(B-1,'b',1,stateQuantity,state))=p_bb;
   
    %Find transition matrix
    P2=zeros(count,count);
    
    for i=1:count
        for j=1:count 
            P2(i,j)=P(P1(i),P1(j));
        end
    end
end