function rawH = H_generator() 

    % rate = 1/2 (1200,3,6) parity check matrix 
    % parity check matrix has dimension checkLen * codeLen 
    
    rate = 3/6;
    rw = 3/(1-rate);
    checkLen = 600;
    codeLen = checkLen/(1-rate);

    rawH = [];
    hash = tril(ones(checkLen,checkLen));
    rowWeight = zeros(checkLen,1);
    colWeight = 3*ones(codeLen,1);

    cutoff = codeLen - 100;
    
    for i = 1:codeLen
        if(i < cutoff)
            while (1)
                R = sort(ceil(rand(3,1)*checkLen));
                if(hash(R(1),R(2)) == 0 && hash(R(2),R(3)) == 0 && hash(R(1),R(3)) == 0 && rowWeight(R(1))<6 && rowWeight(R(2))<6 && rowWeight(R(3))<6) % no overlapped pair 
                    hash(R(1),R(2)) = 1;hash(R(2),R(3)) = 1;hash(R(1),R(3)) = 1;
                    rowWeight(R(1)) = rowWeight(R(1)) + 1;rowWeight(R(2)) = rowWeight(R(2)) + 1;rowWeight(R(3)) = rowWeight(R(3)) + 1;
                    newCol = zeros(checkLen,1);newCol(R(1)) = 1;newCol(R(2)) = 1;newCol(R(3)) = 1;rawH = [rawH newCol];
                    break;
                end
            end
        else 
            arr = getRowLower6(rowWeight,checkLen,rw);
            arrlen = length(arr);
            count = 0;
            while (1)
                count = count + 1;
               if(arrlen >= 3 && count < arrlen*arrlen) 
                   R = sort(ceil(rand(3,1)*arrlen));
                   if(hash(arr(R(1)),arr(R(2))) == 0 && hash(arr(R(2)),arr(R(3))) == 0 && hash(arr(R(1)),arr(R(3))) == 0)
                       hash(arr(R(1)),arr(R(2))) = 1; hash(arr(R(2)),arr(R(3))) = 1; hash(arr(R(1)),arr(R(3))) =1;
                       rowWeight(arr(R(1))) = rowWeight(arr(R(1))) + 1;rowWeight(arr(R(2))) = rowWeight(arr(R(2))) + 1;rowWeight(arr(R(3))) = rowWeight(arr(R(3))) + 1;
                       newCol = zeros(checkLen,1);newCol(arr(R(1))) = 1;newCol(arr(R(2))) = 1;newCol(arr(R(3))) = 1;rawH = [rawH newCol];
                       break;
                   end
               else
                   % find a not overlapped column but maybe uneven row weight
                    R = sort(ceil(rand(3,1)*checkLen));
                    if(hash(R(1),R(2)) == 0 && hash(R(2),R(3)) == 0 && hash(R(1),R(3)) == 0) % no overlapped pair 
                        hash(R(1),R(2)) = 1;hash(R(2),R(3)) = 1;hash(R(1),R(3)) = 1;
                        rowWeight(R(1)) = rowWeight(R(1)) + 1;rowWeight(R(2)) = rowWeight(R(2)) + 1;rowWeight(R(3)) = rowWeight(R(3)) + 1;
                        newCol = zeros(checkLen,1);newCol(R(1)) = 1;newCol(R(2)) = 1;newCol(R(3)) = 1;rawH = [rawH newCol];
                        break;
                    end
               end
            end
        end
    end
    
    % adjust row weights
    for i = 1:checkLen
        if(rowWeight(i) < rw)
            while(rowWeight(i) < rw)
                r = ceil(rand(1,1)*codeLen);
                while(1)
                    if(rawH(i,r) == 0 && checkhash(hash,rawH(:,r),i,checkLen) == 0)
                        rowWeight(i) = rowWeight(i) + 1;
                        colWeight(r) = colWeight(r) + 1;
                        rawH(i,r) = 1;
                        
                        % update hash
                        for k = 1:checkLen
                            if(rawH(k,r) == 1)
                                hash(min(k,i),max(k,i)) = 1;
                            end
                        end
                        
                        break;
                    else
                        r = ceil(rand(1,1)*codeLen);
                    end
                end
            end
        end
    end
end

function f = checkhash(hash,col,index,colLen)
    f = 0;
    for i = 1:colLen
        if(i < index && col(i) == 1)
            if(hash(i,index) == 1)
                f = 1;
            end
        end
        if(i > index && col(i) == 1)
            if(hash(index,i) == 1)
                f = 1;
            end
        end
    end
end

function arr = getRowLower6(L,rowNum,rw)
    arr = [];
    for i = 1:rowNum
       if(L(i) < rw)
           arr = [arr i];
       end
    end
end