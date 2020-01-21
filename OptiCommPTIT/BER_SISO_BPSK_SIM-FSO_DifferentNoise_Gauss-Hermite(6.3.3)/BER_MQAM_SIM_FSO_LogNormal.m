%Evaluation of BER of SISO M-QAM SIM FSO under weak turbulence using the Gauss-Hermite Quadrature integration approach.
%Considering Background and thermal noise.
clear;
clc;
%Simulation Parameters
M=16;                                          %Number of levels; M-ary QAM; M should be even
Rb=155e6;                                      %Symbol rate
R=1;                                           %Responsivity
M_ind=1;                                       %Modulation index
A=1;                                           %Subcarrier signal amplitude
RL=50;                                         %Load resistance
Temp=300;                                      %Ambient temperature
wavl=850e-9;                                   %Optical source wavelength
%Background Noise
%Considering 1 cm^2 receiving aperture
sky_irra=1e-3;                                 %At 850nm wavelength, in W/cm^2-um-sr
sun_irra=550e-4;                               %At 850nm wavelength, in W/cm^2-um
FOV=0.6;                                       %In radian
OBP=1e-3;                                      %Optical filter bandwidth in micrometre
Isky=sky_irra*OBP*(4/pi)*FOV^2;                %Sky irradiance
Isun=sun_irra*OBP;                             %Sun irradiance
%Rytov Variance
Range=1e3;                                     %Link range in meters
Cn=0.75e-14;                                   %Refractive index structure parameter
Rhol=1.23*(Range^(11/6))*Cn*(2*pi/wavl)^(7/6); %Log irradiance variance (Must be less than 1)
Varl=Rhol;                                     %Log intensity variance
r=sqrt(Varl);                                  %Log intensity standard deviation
%Physical constants
E_c=1.602e-19;                                 %Electronic charge
B_c=1.38e-23;                                  %Boltzmann constant
Pd=A^2/2;
Ktemp=(4*B_c*Temp*Rb/RL)+(2*E_c*R*Rb*(Isun+Isky));
K1=3*log2(M)*((R*M_ind)^2)*Pd/(2*(M-1)*Ktemp);
%Background and thermal noise combined
%Hermite polynomial weights and roots
w20=[2.22939364554e-13,4.39934099226e-10,1.08606937077e-7,7.8025564785e-6,0.000228338636017,0.00324377334224, 0.0248105208875,0.10901720602,0.286675505363,0.462243669601,...
0.462243669601,0.286675505363,0.10901720602, 0.0248105208875,0.00324377334224,0.000228338636017, 7.8025564785e-6,1.08606937077e-7,4.39934099226e-10,2.22939364554e-13];
x20=[-5.38748089001,-4.60368244955,-3.94476404012,-3.34785456738,-2.78880605843,-2.25497400209,-1.73853771212,-1.2340762154,-0.737473728545,-0.245340708301,...
0.245340708301,0.737473728545,1.2340762154,1.73853771212,2.25497400209,2.78880605843,3.34785456738,3.94476404012,4.60368244955,5.38748089001];
%BER evaluation
Io=logspace(-10,-4,30);                         %Average received irradiance
IodBm =10*log10(Io*1e3);                        %Average received irradiance in dBm
SNR2=((R.*Io).^2)./(Ktemp);
SNR2dB=10*log10(SNR2);
for i1=1:length(Io)
    GH1=0;
    for i2=1:length(x20)
        arg1=sqrt(K1)*Io(i1)*exp(x20(i2)*sqrt(2)*r-Varl/2);
        temp1=w20(i2)*qfunc(arg1);
        GH1=GH1+temp1;
    end
    BER1(i1)=2*(1-(1/sqrt(M)))*GH1/(log2(M)*sqrt(pi));
end
%Plot function
semilogy(IodBm,BER1)
xlabel('Received average irradiance,E[I] (dBm)')
ylabel('BER')
