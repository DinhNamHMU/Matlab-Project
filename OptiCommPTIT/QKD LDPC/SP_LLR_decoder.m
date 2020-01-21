function [output,turn] = SP_LLR_decoder(H,r,p,synd0)

    % Sum Product LLR decoder for BSC
    
    % p = transfer probability
    % H = double parity check matrix 
    % r = received codeword
    % s = stop criterion syndrom
    maxiteration = 100;
    
    m = size(H,1);
    n = size(H,2);

    LLR0 = zeros(1,n);
    for i = 1:n
        if(r(i) == 1)
            LLR0(i) = log(p/(1-p));
        else
            LLR0(i) = log((1-p)/p);
        end
    end

    U = zeros(m,n); 
    for i = 1:m
        U(i,:) = LLR0; % [LLR0; LLR0; ...] intrinsic information
    end

    R = zeros(m,n);
    Q = zeros(m,n);
    synd = mod(r*H',2);
    synd0 = mod(synd0,2);
    output = r;
    turn = 0;

    while(checksyndrome(synd,synd0)~= 0)
        %disp(['iteration = ',num2str(turn)]);
        if(turn > maxiteration)
            turn = -1;
            break;
        end
        turn = turn + 1;
        %update bit node matrix Q
        for i = 1:n
            for j = 1:m
                if(H(j,i) ~= 0)
                    s = U(j,i);
                    for k = 1:m
                        if(H(k,i)~=0 && k~=j)
                            s = s + R(k,i);
                        end
                    end
                    Q(j,i) = s;
                end
            end
        end

        %update parity check node matrix R
        for i = 1:m
            for j = 1:n
                if(H(i,j)~= 0)
                    prd = 1;
                    for k = 1:n
                        if(H(i,k)~=0 && k~=j)
                            prd = prd * tanh(Q(i,k)/2); 
                        end
                    end
                    prd = 2*atanh(prd);
                    R(i,j) = prd;
                end
            end
        end

        % update decision vector
        r1 = zeros(1,n);
        for i = 1:n
            s = LLR0(i);
            for j = 1:m
                %s = U(j,i);
                if(H(j,i)~=0)
                    s = s + R(j,i);
                end
            end
            r1(i) = s;
        end

        % check 
        for i = 1:n
            if(r1(i)>=0)
                r1(i) = 0;
            else
                r1(i) = 1;
            end
        end
        
        % calculate syndrome
        synd = mod(r1*H',2);
        output = r1;
    end
end

function f = checksyndrome(h,s)
    % check if syndrome h equals to r
    % h is not on gf
    % s is not on gf neither
    f = 0;
    for i = 1:size(h,2)
        if(h(i) ~= s(i))
            f = 1;
            return;
        end
    end
end