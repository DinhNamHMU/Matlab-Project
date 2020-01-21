%% Channel
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
% The |randn| function returns a sample of random numbers from a normal distribution 
% with mean 0 and variance 1. The general theory of random variables states that 
% if _x_ is a random variable whose mean is _?x_ and variance is _?_2_x_, then 
% the random variable, _y_, defined by _y_=_ax_+_b_,where _a_ and _b_ are constants, 
% has mean _?y_=_a?x_+_b_ and variance _?_2_y_=_a_2_?_2_x_. You can apply this 
% concept to get a sample of normally distributed random numbers with mean 500 
% and variance 25.
% 
% First, initialize the random number generator to make the results in this 
% example repeatable.
% 
% |rng(0,'twister');|
% 
% Create a vector of 1000 random values drawn from a normal distribution 
% with a mean of 500 and a standard deviation of 5.
% 
% |a = 5;|
% 
% |b = 500;|
% 
% |y = a.*randn(1000,1) + b;|
% 
% Calculate the sample mean, standard deviation, and variance.
% 
% |stats = [mean(y) std(y) var(y)]|

function output=channel(indata,EbtoN0,Pb)
%linEbtoN0=10^(0.1*EbtoN0);
%N0=Eb/linEbtoN0;
%output=awgn(indata,EbtoN0,'measured') ;
output=awgn(indata,EbtoN0,Pb) ;
%output=awgn(indata,EbtoN0) ;
%noise=sqrt(0.5*N0)*randn(1,size(indata,2));
%output=indata+noise;
end