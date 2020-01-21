function [pb,ps]=cmsm(snrdb)
    N=10000;
    E=1;
    snr=10^(snrdb/10);
    sgma=sqrt(E/snr)/2;
    
    s00=[1 0];
    s01=[0 1];
    s11=[-1 0];
    s10=[0 -1];
    
    for i=1:N
        temp=rand;
        if(temp<0.25)
            dsource1(i)=0;
            dsource2(i)=0;
        elseif(temp<0.5)
            dsource1(i)=0;
            dsource2(i)=1;
        elseif(temp<0.75)
            dsource1(i)=1;
            dsource2(i)=0;
        else
            dsource1(i)=1;
            dsource2(i)=1;
        end
    end
    
    numofsymbolerror=0;
    numofbiterror=0;
    
    for i=1:N
        n(1)=normrnd(0,sgma);
        n(2)=normrnd(0,sgma);
        if((dsource1(i)==0) && (dsource2(i)==0))
            r=s00+n;
        elseif((dsource1(i)==0) && (dsource2(i)==1))
            r=s01+n;
        elseif((dsource1(i)==1) && (dsource2(i)==0))
            r=s10+n;
        else
            r=s11+n;
        end  
        
        c00=dot(r,s00);
        c01=dot(r,s01);
        c10=dot(r,s10);
        c11=dot(r,s11);
        
        cmax=max([c00 c01 c10 c11]);
        
        if(c00==cmax)
            decis1=0;decis2=0;
        elseif(c01==cmax)
            decis1=0;decis2=1;
        elseif(c10==cmax)
            decis1=1;decis2=0;
        else
            decis1=1;decis2=1;
        end
        
        symbolerror=0;
        if(decis1~=dsource1(i))
            numofbiterror=numofbiterror+1;
            symbolerror=1;
        end
        if(decis2~=dsource2(i))
            numofbiterror=numofbiterror+1;
            symbolerror=1;
        end
        if(symbolerror==1)
            numofsymbolerror=numofsymbolerror+1;
        end
    end
    
    ps=numofsymbolerror/N;
    pb=numofbiterror/(2*N);
end