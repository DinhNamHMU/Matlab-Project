%% Demodulator
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
% x(t)*fi1(t)  then integrate from 0 to Tb and decide
% 
% if x1>0, choose 1
% 
% if x1<0, choose 0

function output=demodulator(indata,fi1,t,Tb,SR,n)
multS=fi1.*indata;
%plot(t,multS);
for i=1:n
    sum=0;
    for j=1:SR
        sum=sum+(1/SR)*Tb*multS((i-1)*SR+j); %delt= (1/SR)*Tb
    end
    if sum >=0
        output(i)=1;
    elseif sum<0
        output(i)=0;
    end
    %display(sum)
end
end