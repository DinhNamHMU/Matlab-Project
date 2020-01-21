%%%OOK BER calculation P42 Equation 2-37 
function bb=ber1(IP,deltaf)
global Pt;
global Ts;
global wl;
%Pt=1;
%global wl;
n=0.75;
R=0.85;
A=100;% to be determined
e=1.6022.*10.^(-19);


%wl=800*10^-9;
a=0; Dr=0.25;  G=100;%zengyi
F=G^0.5;
%Ts=10^-8;
IB=10^-8; Idc=10^-9; Rl=50;
T=300; hp=6.6260693*10^(-34); e=1.60217733*10^(-19); Kc=1.3806505*10^(-23);
v=3*10^8/wl; 
Ib=pi*Dr^2*IB/4;% background light power
i=e*n.*IP./(hp*v).*abs(cos(deltaf));
%Ks=IP*Ts*n/(hp*v);
Ks=i.*Ts./e;
Kb=Ib*Ts*n/(hp*v); 
deltaT=2*Kc*T*Ts/Rl;% thermal noise
m0=G*e*Kb+Idc*Ts;
delta00=G^2*F*e^2*Kb+deltaT;
m1=G*e*(Kb+Ks)+Idc*Ts;
delta11=G^2*e^2*F*(Ks+Kb)+deltaT; 

delta1=sqrt(delta11);delta0=sqrt(delta00);   % formula modification will make the Gaussian noise variance in the integration

% gama=(m0.*delta1.^2-m1.*delta0.^2)./(delta1.^2-delta0.^2)+delta0.*delta1./(delta1.^2-delta0.^2).*...
%     sqrt((m1-m0).^2+2*(delta1.^2-delta0.^2).*log(delta1./delta0));
gama=0;

% 
% BER0_11=1./sqrt(2*pi*delta00)*exp(-(y-m0).^2/(2*delta00))./2; 
% BER0_11=1./sqrt(2*pi*delta00)*exp(-(y-m1).^2/(2*delta00))./2;
% Modification formula Gaussian score variance variance
% BER1_01=1./sqrt(2.*pi.*delta11).*exp(-(y-m1).^2./(2.*delta11))./2;
% Modify formula Gaussian score Variance square

% BER_n1=int(BER0_11,y,gama,1000)+int(BER1_01,y,-1000,gama)
% ber=(1-0.5.*erfc((gama-m1)./sqrt(2.*delta11))).*0.5+(0.5.*erfc((gama+m0)./sqrt(2.*delta00))).*0.5
ber=(1-0.5.*erfc((gama-m1)./sqrt(2.*delta11))).*0.5+(0.5.*erfc((gama+m1)./sqrt(2.*delta11))).*0.5;
ber1=2.*ber.*(1-ber);
H=38000000; h0=100;a=0; r=0;
l=(H-h0)*sec(a);
theta=30*10^(-6); % beam angle
W=l*theta/2;% receiving face light radius
alfa=1;
% energy loss


% The following formula is obtained by P63 simulation for the downlink 
I_0l=alfa*Pt*Dr^2/(2*W^2); % average received light intensity
% modified one, followed by 10^9 for unit conversion We found that this can get better results

% dr0=drl(0);
%dr0=0.0068;% correct value
dr0=0.3;
% Modified one, which is calculated by P63 Equation 3-27. For the downlink, make sure it is correct.
bitrate=1e8;                                       % bit rate % Consider the effect of bit rate on bit error rate
Tb=1./bitrate;
fIF=1.*10^8;% to be determined
fgvar=2*pi.*fIF.*Tb;
%deltaf=zeros(1,10000);
%deltaf=linspace(-100,100,10000);
fg=1./(sqrt(2*pi.*fgvar)).*exp(-deltaf.^2./(2.*fgvar));
pr=1./(sqrt(2*pi*dr0))./(IP) .* ...
   exp(-(log(IP/I_0l)+2*r^2/(W^2)+dr0/2).^2./(2*dr0));%27 page 2-10

%bb=pr.*ber2;
bb=pr.*ber1.*fg;
%bb=pr;