function [Result]=jointProbabiliteGammaS_AE_3D(bit_Alice,bit_Eve,X_L_AE_Array) 
    %Gamma-Gamma channels
    %Simulation Parameters
    
    %Laguerre polynomial weights and abscissas
    %tl-abscissas factor of Laguerre polynomial
    t=[0.137793470540,0.729454549503,1.808342901740,3.401433697855,5.552496140064,8.330152746764,11.843785837900,16.279257831378,21.996585811981,29.920697012274];
    %vl-weight factor of Laguerre polynomial
    v=[0.308441115765,0.401119929155,0.218068287612,0.0620874560987,0.00950151697518,0.000753008388588,0.0000282592334960,0.000000424931398496,0.00000000183956482398,0.000000000000991182721961]; 
    
    global Rb;
    global scale;
    P_dBm=0;                  %Peak transmitted power(dBm)
    P=(10^(P_dBm/10))*10^-3;
    ModDepth=0.4;             %Modulaton Depth
    q=1.6*10^-19;             %Electron charge
    g=15;                     %Multiply coefficient
    kA=0.7;                   %Ionization
    FA=kA*g+(2-1/g)*(1-kA);   %Excess noise factor
    Pb_dBm=-40;               %Average received background radiation power
    Pb=(10^(Pb_dBm/10))*10^-3;
    deltaf=Rb/2;              %Bandwidth
    kB=1.38*10^-23;           %Boltzmann's constant
    T=300;                    %Receiver temperature in Kelvin degree
    Fn=2;                     %Amplifier noise figure
    RL=1000;                  %Load impedance
    D=0.02;                   %Diameter
    tetaAngle=10^-3;          %Angle of divergence
    betal1=0.43;              %Attenuatation coefficient(dB/km)
    betal=betal1/4.343;
    lamda=1550*10^-9;         %Wavelength
    C2n=10^-14;               %Refractive index structure coefficient 
    nguy=0.62;                %Quantum efficiency
    h=6.626*10^-34;           %Planck's constant 
    c=3*10^8;                 %Speed of Light
    R=(nguy*q)/(h*c/lamda);   %Detector responsivity (A/W) 
    
    %Calculate QBER
    A=pi*(D/2)^2;             %Area of the receiver aperture
    X_L_AE_Array=X_L_AE_Array.*10^3;
    hl=A./(pi.*(tetaAngle./2.*X_L_AE_Array).^2).*exp(-betal.*X_L_AE_Array./1000);
    
    sigmaR2=1.23.*(2.*pi./lamda).^(7/6).*X_L_AE_Array.^(11/6).*C2n;
    alpha=(exp(0.49.*sigmaR2./(1+1.11.*(sqrt(sigmaR2)).^(12/5)).^(7/6))-1).^-1;
    beta=(exp(0.51.*sigmaR2./(1+0.69.*(sqrt(sigmaR2)).^(12/5)).^(5/6))-1).^-1;
    
    Sum=zeros(scale,scale);
    temp1=zeros(scale,scale);
    teta=zeros(scale,scale,length(t));
    b=zeros(scale,scale,length(t));
    special=zeros(scale,scale,length(t));
    a=zeros(scale,scale,length(t));
    
    for i=1:length(t)
        teta(:,:,i)=(((alpha.*beta).^alpha).*v(i).*t(i).^(-alpha+beta-1))./(gamma(alpha).*gamma(beta));
        b(:,:,i)=alpha;
        special(:,:,i)=alpha.*beta./t(i);
    end
    
    for i=1:length(t)
        temp1=temp1+teta(:,:,i).*gamma(b(:,:,i)).*special(:,:,i).^(-b(:,:,i));
    end

    for i=1:length(t)
        a(:,:,i)=teta(:,:,i)./temp1;     
        for l=1:length(t)
            i0=-1./(4.*special(:,:,i)).*R.*g.*P.*ModDepth.*hl.*t(l);
            i1=-i0;
            
            sigmaN_i_l=sqrt(2.*q.*FA.*g.^2.*R.*(1./(4.*special(:,:,i)).*P.*ModDepth.*hl.*t(l)+Pb).*deltaf+4.*kB.*T.*Fn.*deltaf./RL);
            
            dE=0;
            
            if bit_Alice==0 && bit_Eve==0 
                Sum=Sum+1/2.*a(:,:,i).*special(:,:,i).^(-b(:,:,i)).*v(l).*t(l).^(b(:,:,i)-1).*qfunc((i0-dE)./sigmaN_i_l);
            elseif bit_Alice==1 && bit_Eve==0
                Sum=Sum+1/2.*a(:,:,i).*special(:,:,i).^(-b(:,:,i)).*v(l).*t(l).^(b(:,:,i)-1).*qfunc((i1-dE)./sigmaN_i_l);    
            elseif bit_Alice==0 && bit_Eve==1
                Sum=Sum+1/2.*a(:,:,i).*special(:,:,i).^(-b(:,:,i)).*v(l).*t(l).^(b(:,:,i)-1).*qfunc((dE-i0)./sigmaN_i_l);
            else
                Sum=Sum+1/2.*a(:,:,i).*special(:,:,i).^(-b(:,:,i)).*v(l).*t(l).^(b(:,:,i)-1).*qfunc((dE-i1)./sigmaN_i_l);
            end
        end
    end
    
  	Result=Sum;
end