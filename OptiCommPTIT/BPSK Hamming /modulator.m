%% Modulator
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
% Coherent Phase Shift Keying Modulator
% 
% BPSK
% 
% s1(t)=sqrt(2*Eb/Tb)*cos(2*pi*fc*t+0)
% 
% s2(t)=sqrt(2*Eb/Tb)*cos(2*pi*fc*t+pi)=-s1(t)
% 
% fi1(t)=sqrt(2/Tb)*cos(2*pi*fc*t)
% 
% s1(t)=sqrt(Eb)*fi1(t)
% 
% s2(t)=-sqrt(Eb)*fi1(t)
% 
% Signal Dimensionality:1 (N=1)

function output=modulator(indata,fi1,t,Eb,n)
%plot(t,fi1);
for i=1:size(indata,2)
    for j=1:size(t,2)/n
        if indata(i)==1
            output((i-1)*size(t,2)/n+j)=sqrt(Eb)*fi1((i-1)*size(t,2)/n+j);
        elseif indata(i)==0
            output((i-1)*size(t,2)/n+j)=-1*sqrt(Eb)*fi1((i-1)*size(t,2)/n+j);
        else
            error('codeword is not binary')
        end
        %display((i-1)*100+j)
    end
end