function [stateIndex]=findStateIndex(numberPacket,channel,transmitted,stateQuantity,state)
    for i=1:stateQuantity
        if state(i).numberPacket==numberPacket && state(i).channel==channel && state(i).transmitted==transmitted 
            stateIndex=i;
            break;
        end 
    end
end