function [] = G_generator()

    % Encode: e = r*G;
    % Check:  h = e*transpose(H)
    % Decode: r_decode = (e_decode*V)(m+1:n)
    
    H = H_generator();
    disp('Parity check matrix H generated.');
    
    if(checkgirth(H) ~= 0)
        disp('Error: Parity check matrix H girth = 4');
        return ;
    else
        disp('Check: Parity check matrix H girth > 4');
    end

    m = size(H,1);
    n = size(H,2);
    [r,HR,nzpos] = GS(H,m,n); % H, HR is (0,1) double

    if(r ~= m)
        disp("Error: Parity check matrix H not full rank");
        return ;
    else
        disp("Check: Parity check matrix full rank");
        V = gfunity(n); % V is column permutation matrix
        for i = 1:r
            if(nzpos(i) == i)
                continue;
            else
                % swap column 
                tmpcol = HR(:,nzpos(i));
                HR(:,nzpos(i)) = HR(:,i);
                HR(:,i) = tmpcol;
                % update V
                P = gfunity(n);
                P(i,i) = 0; P(nzpos(i),nzpos(i)) = 0; P(i,nzpos(i)) = 1; P(nzpos(i),i) = 1;
                V = V * P;
            end
        end
    end

    T = HR(1:m,1:m);
    S = HR(1:m,m+1:n);
    disp('Column permutating matrix V generated');
    
    I = gfunity(n-m);
    G = mod([S'*(triuinvgf2(T))' I]*V',2);
    disp('Generating matrix G generated')
    C = mod(G*H',2);
    if(sum(C(:) == 1) ~= 0)
        disp('Error: G not orthogonal to H');
        return ;
    else
        disp('Check: G orthogonal to H');
    end
    save('data\LDPC','H','G','V');
    
end

function [rk,H,nzpos] = GS(H,m,n)
    % gauss elimination
    nzpos = zeros(m,1);
    
    rk = 0;
    for i = 1:n
        %find first 1
        rowid = 0;
        for j = rk+1:m
            if(H(j,i) == 1)
                rowid = j;
                break;
            end
        end

        if(rowid == 0)
            % empty column
            continue;
        else
            % eliminate
            rk = rk + 1;
            nzpos(rk) = i;
            for k = rowid+1:m
                if(H(k,i) == 1)
                    H(k,:) = abs(H(k,:) - H(rowid,:));
                end
            end
            % swap row(rowid) with row(rk)
            tmprow = H(rowid,:);
            H(rowid,:) = H(rk,:);
            H(rk,:) = tmprow;
        end
    end
    
end

function A = gfunity(r)
    A = zeros(r,r);
    for i = 1:r
        A(i,i) = 1;
    end
end

function A = triuinvgf2(M)
    % get the inverse of a triu matrix
    k = size(M,1);
    A = [];
    U = gfunity(k);
    for i = 1:k % col
        col = zeros(k,1);
        for j = 0:k-1
            col(k-j) = mod(U(k-j,i) - M(k-j,:)*col,2);
        end
        A = [A col];
    end
end

function f = checkgirth(H)
    % check H
    m = size(H,1);
    n = size(H,2);
    f = 0;
    for i = 1:m-1
        for j = i+1:m
            c = 0;
            for k = 1:n
                if(H(i,k) == 1 && H(j,k) == 1)
                    c = c + 1;
                end
            end
            if(c>=2)
                f = 1;
            end
        end
    end
end