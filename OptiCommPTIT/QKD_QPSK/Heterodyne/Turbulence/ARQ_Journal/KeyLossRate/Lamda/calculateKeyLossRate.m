function [keyLossRate]=calculateKeyLossRate(M,B,QBER,P_sift,lamda) 
    %Simulation Parameters 
    global Rb;                                   %Bit rate(bps)
    global lamda_wavelength;                     %Wavelength (m)
    global v_wind;                               %Wind speed (m/s)
    global H_G;                                  %Ground station height (m)
    global H_a;                                  %Amospheric altitude (m)
    global l_k;                                  %Length of bit string(in bits)
    global zenithAng_Do

    t_k=l_k/Rb;                                  %Transmission time of bit string(second)
    zenithAng=pi*zenithAng_Do/180;               %(rad)
    L_SG=(H_a-H_G)/cos(zenithAng);
    t_0=sqrt(lamda_wavelength*L_SG)/v_wind;      %Turbulence coherent time(second)

    tmp1=0;
    tmp2=0;
    sum1=0;
    sum2=0;

    %Calculation
    %Intial parameters
    stateQuantity=M*(B+1)*2;    %Quantity of states
    
    %Channel state transition probabilities
    KER=1-(1-QBER)^(l_k*P_sift);
    p_bb=KER*(1-t_k/t_0);
    p_bg=1-p_bb;
    p_gg=(1-KER)*(1-t_k/t_0);
    p_gb=1-p_gg;
   
    %Intial states
    state(stateQuantity)=struct;
    for i=1:stateQuantity
        state(i).numberKey=0;
        state(i).channel='';
        state(i).transmitted=0;
    end

    count=0;
    for i=1:M
        for j=0:B 
                count=count+1;
                state(count).numberKey=j;
                state(count).channel='g';
                state(count).transmitted=i;
        end
    end

    for i=1:M
        for j=0:B
                count=count+1;
                state(count).numberKey=j;
                state(count).channel='b';
                state(count).transmitted=i;
        end
    end
    
    %Transition probability matrix
    [P2,P1,steadyStateQuantity]=calculateTransitionProbability(stateQuantity,state,lamda,t_k,M,B,p_gg,p_gb,p_bg,p_bb);
    
    %Steady state probability
    steadyState=calculateSteadyState(P2);
    
    %Key loss rate
    if M==1 
        for i=1:M
            sum1=sum1+steadyState(findSteadyStateIndex(P1,findStateIndex(B,'g',i,stateQuantity,state),steadyStateQuantity))...
                     +steadyState(findSteadyStateIndex(P1,findStateIndex(B,'b',i,stateQuantity,state),steadyStateQuantity));
        end
        for i=0:B-1 
            sum2=sum2+steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',M,stateQuantity,state),steadyStateQuantity));
        end
        
        keyLossRate=sum1+sum2;
    else
        for i=1:M
            tmp1=tmp1+steadyState(findSteadyStateIndex(P1,findStateIndex(B,'g',i,stateQuantity,state),steadyStateQuantity))...
                     +steadyState(findSteadyStateIndex(P1,findStateIndex(B,'b',i,stateQuantity,state),steadyStateQuantity));
        end
        for i=1:B-1 
            tmp2=tmp2+steadyState(findSteadyStateIndex(P1,findStateIndex(i,'b',M,stateQuantity,state),steadyStateQuantity));
        end
    
        keyLossRate=tmp1+tmp2;
    end
end