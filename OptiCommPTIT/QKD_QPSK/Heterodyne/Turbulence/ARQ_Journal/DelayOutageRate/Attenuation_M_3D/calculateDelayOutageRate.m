function [delayOutageRate]=calculateDelayOutageRate(T,D,M,B,p_gg,p_gb,p_bg,p_bb,tmp3,tmp4,tmp3_comma,Sum_v) 
    %Calculation
    %Intial state
    count2=0;
    tmp1=0;tmp2=0;tmp5=0;tmp6=0;
    state2(10000)=struct;
    
    %Part 1
    for i=2:B
        for j=1:M
            count2=count2+1;
            state2(count2).queueLength=i;
            state2(count2).channel='g';
            state2(count2).transmitted=j;
        end
    end
    
    %Part 2
    for i=2:B
        for j=1:(M-1) 
            count2=count2+1;
            state2(count2).queueLength=i;
            state2(count2).channel='b';
            state2(count2).transmitted=j;
        end
    end
    
    %Part 3
    for i=2:B
        count2=count2+1;
        state2(count2).queueLength=i;
        state2(count2).channel='b';
        state2(count2).transmitted=M;
    end
    
    %Part 4
    for i=1:M 
        count2=count2+1;
        state2(count2).queueLength=1;
        state2(count2).channel='g';
        state2(count2).transmitted=i;
    end
    
    %Part 5
    for i=1:(M-1) 
        count2=count2+1;
        state2(count2).queueLength=1;
        state2(count2).channel='b';
        state2(count2).transmitted=i;
    end
    
    %Part 6
    count2=count2+1;
    state2(count2).queueLength=1;
    state2(count2).channel='b';
    state2(count2).transmitted=M;
    
    %Absorbing state
    %Success
    count2=count2+1;
    state2(count2).queueLength='s';
    state2(count2).channel='s';
    state2(count2).transmitted='s';
    
    %Failure
    count2=count2+1;
    state2(count2).queueLength='f';
    state2(count2).channel='f';
    state2(count2).transmitted='f';
    
    %Transition probability matrix
    P=calculateTransitionProbability2(count2,state2,M,B,p_gg,p_gb,p_bg,p_bb);
    
    %The conditional probability that the queuing delay of a successfully received packet is larger than D/T slots
    %(0,s,1)
    for i=(D/T+2):(1*M)
        P1=P^i;
        tmp1=tmp1+P1(findStateIndex2(1,'g',1,count2,state2),findStateIndex2('s','s','s',count2,state2))...
                 +P1(findStateIndex2(1,'b',1,count2,state2),findStateIndex2('s','s','s',count2,state2));      
    end
    
    for i=1:(1*M) 
        P1=P^i;
        tmp2=tmp2+P1(findStateIndex2(1,'g',1,count2,state2),findStateIndex2('s','s','s',count2,state2))...
                 +P1(findStateIndex2(1,'b',1,count2,state2),findStateIndex2('s','s','s',count2,state2));  
    end
    
    %(q-1,s,m)
    for i=2:B
        for j=1:M
            for k=(D/T+2):((i-1)*M) 
                P1=P^k;
                tmp5=tmp5+P1(findStateIndex2(i-1,'g',j,count2,state2),findStateIndex2('s','s','s',count2,state2))...
                         +P1(findStateIndex2(i-1,'b',j,count2,state2),findStateIndex2('s','s','s',count2,state2));
            end
            
            for k=(i-1):((i-1)*M) 
                P1=P^k;
                tmp6=tmp6+P1(findStateIndex2(i-1,'g',j,count2,state2),findStateIndex2('s','s','s',count2,state2))...
                         +P1(findStateIndex2(i-1,'b',j,count2,state2),findStateIndex2('s','s','s',count2,state2));
            end
        end
    end   
    
    Pr1=tmp1/tmp2;
    Pr2=tmp5/tmp6;
    Pr=1/Sum_v*(Pr1*tmp3_comma+Pr2*tmp4);
    
    %Delay outage rate
    delayOutageRate=Pr;
end