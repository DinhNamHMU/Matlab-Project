function [stateIndex2]=findStateIndex2(queueLength,channel,transmitted,count2,state2)  
     for i=1:count2 
        if state2(i).queueLength==queueLength && state2(i).channel==channel && state2(i).transmitted==transmitted 
            stateIndex2=i;
            break;
        end
     end
end