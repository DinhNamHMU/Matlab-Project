function f=ber2(IP,deltaf)
global Pt;
global Ts
global G;
H=38000000; h0=100;a=0; r=0;
l=(H-h0)*sec(a);
theta=30*10^(-6); W=l*theta/2;
alfa=1;Dr=0.25;

% The following formula is obtained by P63 simulation for the downlink
I_0l=alfa*Pt*Dr^2/(2*W^2); % accepts a strong average
% modified one, followed by 10^9 for unit conversion We found that this can get better results

% dr0=drl(0);
dr01=0.3;%variance
% Modified one, which is calculated by P63 Equation 3-27. For the downlink, make sure it is correct. 
%IP=(0:1:10000)*10^-10;
pr1=1./(sqrt(2*pi*dr01))./(IP).*exp(-(log(IP/I_0l)+dr01/2).^2./(2*dr01));% received light intensity probability density
%plot(IP,pr1); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%
bitrate=1e8;                                       % bit rate % Consider the effect of bit rate on bit error rate
Tb=1./bitrate;
R=0.85;
A=100;% to be determined
e=1.6022.*10.^(-19);
n=0.75;

fIF=1.*10^8;% to be determined
fgvar=2*pi.*fIF.*Tb;
%deltaf=zeros(1,10000);
%deltaf=linspace(-100,100,10000);
fg=1./(sqrt(2*pi.*fgvar)).*exp(-deltaf.^2./(2.*fgvar));
%kam=R.*A.^2./(2.*q);
%SNR=kam.*IP.*abs(cos(deltaf));
%f1=0.5.*erfc(kam.*IP.*abs(cos(deltaf))).*(cos(deltaf)>0)+(1-0.5.*(erfc(kam.*IP.*abs(cos(deltaf))))).*(cos(deltaf)<0);
%%
%G=100;
n=0.75; 
%Ts=10^-8; 
IB=10^-8; hp=6.625*10^(-34); v=3*10^8/(800*10^(-9)); T=300;
Kc=1.3806505*10^(-23);Rl=50;
F=G^0.5;
%Ks=IP*Ts*n/(hp*v);

i=e*n.*IP./(hp*v).*abs(cos(deltaf));
Ks=i.*Ts./e;
%Ks=i.*Ts./e;
Ib=pi*Dr^2*IB/4;

Kb=Ib*Ts*n/(hp*v);% background light power
deltaT=2*Kc*T*Ts/Rl;
delta11=G^2*e^2*F*(Ks+Kb)+deltaT; 
%%

snr=i.^2./(2.*delta11);
%f1=0.5.*erfc(sqrt(snr)).*(cos(deltaf)>0)+(1-0.5.*erfc(sqrt(snr))).*(cos(deltaf)<0);
f11=0.5.*erfc(sqrt(snr));
%f1=2.*(1-f11).*(f11);
f1=0.5.*(1-(erf(sqrt(snr))).^2);
%f=2.*f11.*pr1.*fg;
IB=10^-8; Idc=10^-9; Rl=50;wl=800*10^-9;
T=300; hp=6.6260693*10^(-34); e=1.60217733*10^(-19); Kc=1.3806505*10^(-23);
v=3*10^8/wl; 
Ib=pi*Dr^2*IB/4;
gama=0;
m1=G*e*(Kb+Ks)+Idc*Ts;
ber=(1-0.5.*erfc((gama-m1)./sqrt(2.*delta11))).*0.5+(0.5.*erfc((gama+m1)./sqrt(2.*delta11))).*0.5;
ber1=2.*ber.*(1-ber);
f=ber1.*fg.*pr1;
