function [packetLossRate,U,lb,delayOutageRate]=calculatePacketLossRate(v,M,B) 
    %Simulation Parameters 
    T=5*10^-3;                  %Packet transmission time over the wireless link
    F_dB=10;                    %Fading margin
    F=10^(F_dB/10);
    v_c=3*10^8;                 %Speed of light (m/s)
    f_c=900*10^6;               %Carrier frequency
    C=1/(5*10^-3);              %Wireless link capacity
    D=50*10^-3;                 %Maximum delay jitter
    t=20*10^-3;
    
    tmp1=0;
    tmp2=0;
    tmp4=0;
    sum1=0;
    sum2=0;
    tmp_RTT=0;

    %Calculation
    %Intial parameters
    stateQuantity=M*(B+1)*2;    %Quantity of states
    p_e=1-exp(-1/F);            %Packet error rate
    f_d=f_c*v/v_c;              %Doppler frequency
    p_In=besselj(0,2*pi*f_d*T); %Gaussian correlation coefficient
    p_In=abs(p_In);
    teta=sqrt((2/F)/(1-p_In^2));
    teta=abs(teta);

    p_bb=1-(marcumq(teta,p_In*teta)-marcumq(p_In*teta,teta))/(exp(1/F)-1);
    p_bg=1-p_bb;
    p_gg=(1-p_e*(2-p_bb))/(1-p_e);
    p_gb=1-p_gg;
    
    %Intial states
    state(stateQuantity)=struct;
    for i=1:stateQuantity
        state(i).numberPacket=0;
        state(i).channel='';
        state(i).transmitted=0;
    end

    count=0;
    for i=1:M
        for j=0:B 
                count=count+1;
                state(count).numberPacket=j;
                state(count).channel='g';
                state(count).transmitted=i;
        end
    end

    for i=1:M
        for j=0:B
                count=count+1;
                state(count).numberPacket=j;
                state(count).channel='b';
                state(count).transmitted=i;
        end
    end
    
%     %Calculate lamda in steady state - steady state sending rate
%     lamda=C/2;                  %Flow throughput (packet per second)
%     
%     %Transition probability matrix
%     [P2,P1,steadyStateQuantity]=calculateTransitionProbability(stateQuantity,state,lamda,T,M,B,p_gg,p_gb,p_bg,p_bb);
%     
%     %Steady state probability
%     steadyState=calculateSteadyState(P2);
%     
%     %Packet loss rate
%     if M==1 
%         for i=1:M
%             sum1=sum1+steadyState(findSteadyStateIndex(P1,findStateIndex(B,'g',i,stateQuantity,state),steadyStateQuantity))...
%                      +steadyState(findSteadyStateIndex(P1,findStateIndex(B,'b',i,stateQuantity,state),steadyStateQuantity));
%         end
%         for i=0:B-1 
%             sum2=sum2+steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',M,stateQuantity,state),steadyStateQuantity));
%         end
%         
%         packetLossRate=sum1+sum2;
%     else
%         for i=1:M
%             tmp1=tmp1+steadyState(findSteadyStateIndex(P1,findStateIndex(B,'g',i,stateQuantity,state),steadyStateQuantity))...
%                      +steadyState(findSteadyStateIndex(P1,findStateIndex(B,'b',i,stateQuantity,state),steadyStateQuantity));
%         end
%         for i=1:B-1 
%             tmp2=tmp2+steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',M,stateQuantity,state),steadyStateQuantity));
%         end
%     
%         packetLossRate=tmp1+tmp2;
%     end 
%    
%     %Round trip time
%     for i=1:B 
%         for j=1:M
%             tmp_RTT=tmp_RTT+i*(steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',j,stateQuantity,state),steadyStateQuantity))...
%                               +steadyState(findSteadyStateIndex(P1,findStateIndex(i,'g',j,stateQuantity,state),steadyStateQuantity)));
%         end
%     end
% 
%     RTT=2*t+1/lamda*tmp_RTT;
%     
%     %Average length of burst errors (packets)
%     lb=1/(1-p_bb^M); 
%     
%     %The loss event rate
%     p=packetLossRate/lb;
%     
%     %Lamda update
%     TO=4*RTT;
%     lamda=1/(RTT*sqrt(2*p/3)+TO*(3*sqrt(3*p/8))*p*(1+32*p^2));
%     
%     %Reset parameters
%     sum1=0;
%     sum2=0;
%     tmp1=0;
%     tmp2=0;
%     tmp_RTT=0;
%     
%     while lamda~=p
%         
%         %Calculate lamda in steady state - steady state sending rate 
%         %Transition probability matrix
%         [P2,P1,steadyStateQuantity]=calculateTransitionProbability(stateQuantity,state,lamda,T,M,B,p_gg,p_gb,p_bg,p_bb);
%     
%         %Steady state probability
%         steadyState=calculateSteadyState(P2);
%     
%         %Packet loss rate
%         if M==1 
%             for i=1:M
%                 sum1=sum1+steadyState(findSteadyStateIndex(P1,findStateIndex(B,'g',i,stateQuantity,state),steadyStateQuantity))...
%                          +steadyState(findSteadyStateIndex(P1,findStateIndex(B,'b',i,stateQuantity,state),steadyStateQuantity));
%             end
%             for i=0:B-1 
%                 sum2=sum2+steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',M,stateQuantity,state),steadyStateQuantity));
%             end
%         
%             packetLossRate=sum1+sum2;
%         else
%             for i=1:M
%                 tmp1=tmp1+steadyState(findSteadyStateIndex(P1,findStateIndex(B,'g',i,stateQuantity,state),steadyStateQuantity))...
%                          +steadyState(findSteadyStateIndex(P1,findStateIndex(B,'b',i,stateQuantity,state),steadyStateQuantity));
%             end
%             for i=1:B-1 
%                 tmp2=tmp2+steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',M,stateQuantity,state),steadyStateQuantity));
%             end
%     
%             packetLossRate=tmp1+tmp2;
%         end 
%    
%         %Round trip time
%         for i=1:B 
%             for j=1:M
%                 tmp_RTT=tmp_RTT+i*(steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',j,stateQuantity,state),steadyStateQuantity))...
%                                   +steadyState(findSteadyStateIndex(P1,findStateIndex(i,'g',j,stateQuantity,state),steadyStateQuantity)));
%             end
%         end
% 
%         RTT=2*t+1/lamda*tmp_RTT;
%     
%         %Average length of burst errors (packets)
%         lb=1/(1-p_bb^M); 
%     
%         %The loss event rate
%         p=packetLossRate/lb;
%     
%         %Lamda update
%         TO=4*RTT;
%         lamda=1/(RTT*sqrt(2*p/3)+TO*(3*sqrt(3*p/8))*p*(1+32*p^2));
%         
%         %Reset parameters
%         sum1=0;
%         sum2=0;
%         tmp1=0;
%         tmp2=0;
%         tmp_RTT=0;
%     end
   
    lamda=175; %My selection
    %Transition probability matrix
    [P2,P1,steadyStateQuantity]=calculateTransitionProbability(stateQuantity,state,lamda,T,M,B,p_gg,p_gb,p_bg,p_bb);
    
    %Steady state probability
    steadyState=calculateSteadyState(P2);
    
    %Packet loss rate
    if M==1 
        for i=1:M
            sum1=sum1+steadyState(findSteadyStateIndex(P1,findStateIndex(B,'g',i,stateQuantity,state),steadyStateQuantity))...
                     +steadyState(findSteadyStateIndex(P1,findStateIndex(B,'b',i,stateQuantity,state),steadyStateQuantity));
        end
        for i=0:B-1 
            sum2=sum2+steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',M,stateQuantity,state),steadyStateQuantity));
        end
        
        packetLossRate=sum1+sum2;
    else
        for i=1:M
            tmp1=tmp1+steadyState(findSteadyStateIndex(P1,findStateIndex(B,'g',i,stateQuantity,state),steadyStateQuantity))...
                     +steadyState(findSteadyStateIndex(P1,findStateIndex(B,'b',i,stateQuantity,state),steadyStateQuantity));
        end
        for i=1:B-1 
            tmp2=tmp2+steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',M,stateQuantity,state),steadyStateQuantity));
        end
    
        packetLossRate=tmp1+tmp2;
    end 
    
    %Link utilization
    U=lamda*(1-packetLossRate)/C;
    
    %Average length of burst errors (packets)
    lb=1/(1-p_bb^M); 
    
    %The probability of the intial state
    tmp3=steadyState(findSteadyStateIndex(P1,findStateIndex(0,'g',1,stateQuantity,state),steadyStateQuantity))...
        +steadyState(findSteadyStateIndex(P1,findStateIndex(0,'b',1,stateQuantity,state),steadyStateQuantity));
  
    for i=2:B
        for j=1:M 
            tmp4=tmp4+steadyState(findSteadyStateIndex(P1,findStateIndex(i-1,'g',j,stateQuantity,state),steadyStateQuantity))...
                     +steadyState(findSteadyStateIndex(P1,findStateIndex(i-1,'b',j,stateQuantity,state),steadyStateQuantity));
        end
    end 
    
    tmp3_comma=steadyState(findSteadyStateIndex(P1,findStateIndex(1,'g',1,stateQuantity,state),steadyStateQuantity))...
        +steadyState(findSteadyStateIndex(P1,findStateIndex(1,'b',1,stateQuantity,state),steadyStateQuantity));
    
    Sum_v=tmp3+tmp4;
    
    %Delay outage rate
    delayOutageRate=calculateDelayOutageRate(T,D,M,B,p_gg,p_gb,p_bg,p_bb,tmp3,tmp4,tmp3_comma,Sum_v);
end