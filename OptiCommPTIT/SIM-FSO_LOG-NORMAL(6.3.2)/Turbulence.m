function [I]=Turbulence(Log_Int_var,No_symb,Io,t)
    %Log intensity Variance
    Var_l=Log_Int_var;
    %Number of symbols
    %No_symb=1e4;
    %Log normal atmospheric turbulence
    l=(sqrt(Var_l).*randn(1,No_symb))-(Var_l/2);
    I1=Io.*exp(l);
    for i=1:No_symb
        a=1+(i-1)*length(t);
        b=i*length(t);
        I(1,a:b)=I1(i);
    end
end