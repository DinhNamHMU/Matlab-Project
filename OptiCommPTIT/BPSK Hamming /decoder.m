%% Channel Decoder
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
% S=r*H';
% 
% H=[I(n-k)|P']
% 
% n-k=m=3

function output=decoder(indata,n,k,p)
H=cat(2,eye(n-k),p');
rsyndrome=mod(indata*H',2);
EP1=[0 0 0 0 0 0 0];
EP2=[0 0 0 0 0 0 1];
EP3=[0 0 0 0 0 1 0];
EP4=[0 0 0 0 1 0 0];
EP5=[0 0 0 1 0 0 0];
EP6=[0 0 1 0 0 0 0];
EP7=[0 1 0 0 0 0 0];
EP8=[1 0 0 0 0 0 0];
Synd1=mod(EP1*H',2);
Synd2=mod(EP2*H',2);
Synd3=mod(EP3*H',2);
Synd4=mod(EP4*H',2);
Synd5=mod(EP5*H',2);
Synd6=mod(EP6*H',2);
Synd7=mod(EP7*H',2);
Synd8=mod(EP8*H',2);
if rsyndrome==Synd1
    crmessage=mod(indata+EP1,2);
elseif rsyndrome==Synd2
    crmessage=mod(indata+EP2,2);
elseif rsyndrome==Synd3
    crmessage=mod(indata+EP3,2);
elseif rsyndrome==Synd4
    crmessage=mod(indata+EP4,2);
elseif rsyndrome==Synd5
    crmessage=mod(indata+EP5,2);
elseif rsyndrome==Synd6
    crmessage=mod(indata+EP6,2);
elseif rsyndrome==Synd7
    crmessage=mod(indata+EP7,2);
elseif rsyndrome==Synd8
    crmessage=mod(indata+EP8,2);
end
output=crmessage(4:7);
end