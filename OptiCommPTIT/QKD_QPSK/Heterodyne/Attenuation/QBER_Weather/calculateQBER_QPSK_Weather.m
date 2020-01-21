function [QBER11,P_sift11,QBER12,P_sift12,QBER2,P_sift2,QBER3,P_sift3]=calculateQBER_QPSK_Weather(alpha1) 
    %Simulator Parameters
    ScaleCoArr=0:0.1:4;  %Threshold scale coefficient
    ScaleCo=1.5;
    P_T_dBm1=0;          %Transmitted power(dBm)-> Value=0||5
    P_T_dBm2=5;   
    P_T_dBmArr=-10:1:10;
    
    %Scale Coefficient
    QBER11=zeros(1,length(ScaleCoArr));
    P_sift11=zeros(1,length(ScaleCoArr));
    QBER12=zeros(1,length(ScaleCoArr));
    P_sift12=zeros(1,length(ScaleCoArr));

    %P_T_dBm
    QBER2=zeros(1,length(P_T_dBmArr));
    P_sift2=zeros(1,length(P_T_dBmArr));
    QBER3=zeros(1,length(P_T_dBmArr));
    P_sift3=zeros(1,length(P_T_dBmArr));

    %Calculate QBER
    for i=1:length(ScaleCoArr)
        [QBER11(i),P_sift11(i)]=calculateQBER_QPSK(ScaleCoArr(i),P_T_dBm1,alpha1);
    end
    for i=1:length(ScaleCoArr)
        [QBER12(i),P_sift12(i)]=calculateQBER_QPSK(ScaleCoArr(i),P_T_dBm2,alpha1);
    end
    for i=1:length(P_T_dBmArr) 
        [QBER2(i),P_sift2(i)]=calculateQBER_QPSK(ScaleCo,P_T_dBmArr(i),alpha1);
    end
    for i=1:length(P_T_dBmArr)
        [QBER3(i),P_sift3(i)]=calculateQBER_QPSK_DD(ScaleCo,P_T_dBmArr(i),alpha1);
    end
end