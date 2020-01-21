function [x,U]=calculateLinearEquation(A,b)
%Function to perform gauss eliminination
%FORWARD ELIMINATION
n=length(b);
m=zeros(n,1);
x=zeros(n,1);
for k =1:n-1
      %Compute the kth column of M
      m(k+1:n) = A(k+1:n,k)/A(k,k);
      %Compute
      %An=Mn*An-1;
      %bn=Mn*bn-1;
      for i=k+1:n
          A(i, k+1:n) = A(i,k+1:n)-m(i)*A(k,k+1:n);
      end
      b(k+1:n)=b(k+1:n)-b(k)*m(k+1:n);
end
U=triu(A);
%BACKWARD ELIMINATION
x(n)=b(n)/A(n,n);
for k =n-1:-1:1
      b(1:k)=b(1:k)-x(k+1)* U(1:k,k+1);
      x(k)=b(k)/U(k,k);
end
end