function [stateIndex]=findStateIndex(numberKey,channel,transmitted,stateQuantity,state)
    for i=1:stateQuantity
        if state(i).numberKey==numberKey && state(i).channel==channel && state(i).transmitted==transmitted 
            stateIndex=i;
            break;
        end 
    end
end