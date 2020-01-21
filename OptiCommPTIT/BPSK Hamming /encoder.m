%% Channel Encoder
% By Khashayar Namdar
% 
% University of Western Ontario
% 
% Computer and Electrical Engineering Department
% 
% For Digital Modulation and Coding Course
% 
% Professor Raveendra K. Rao
% 
% Summer 2018
% 
% Hamming Codes
% 
% (n,k) block
% 
% Block length: n=2^m -1
% 
% Number of message bits: k=2^m -m -1
% 
% Number of parity bits: n-k=m
% 
% (7,4)  n=7, k=4, m=3
% 
% G=[P|I(4)]
% 
% c=mG

function output=encoder(indata,n,k,p)
output=[];
%p=[1 1 0 ; 0 1 1; 1 1 1; 1 0 1];
G=cat(2,p,eye(k));
m=indata(1:k);
c=mod(m*G,2);
output=cat(2,output,c);
end