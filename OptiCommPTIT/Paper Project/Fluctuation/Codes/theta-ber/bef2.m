% BDPSK
function bb=bef2(IP)
global theta;
global Pt;
%global wl;
Dr=0.25;
%global Dr;
%theta=30*10^(-6);
a=0; n=0.75; G=100; F=G^0.5; Ts=10^-8; IB=10^-8; Idc=10^-9; Rl=50;
T=300; hp=6.6260693*10^(-34); e=1.60217733*10^(-19); Kc=1.3806505*10^(-23);
wl=800*10^(-9);
v=3*10^8/wl; 
Ib=pi*Dr^2*IB/4;
Ks=IP*Ts*n/(hp*v); Kb=Ib*Ts*n/(hp*v); deltaT=2*Kc*T*Ts/Rl;
m0=G*e*Kb+Idc*Ts;
delta00=G^2*F*e^2*Kb+deltaT;
m1=G*e*(Kb+Ks)+Idc*Ts;
delta11=G^2*e^2*F*(Ks+Kb)+deltaT; 

delta1=sqrt(delta11);delta0=sqrt(delta00);   % formula modification will make the Gaussian noise variance in the integration

% gama=(m0.*delta1.^2-m1.*delta0.^2)./(delta1.^2-delta0.^2)+delta0.*delta1./(delta1.^2-delta0.^2).*...
%     sqrt((m1-m0).^2+2*(delta1.^2-delta0.^2).*log(delta1./delta0));
gama=0;
ber1=(1-0.5*erfc((gama-m1)./sqrt(2.*delta11)))*0.5+(0.5*erfc((gama+m1)./sqrt(2.*delta11)))*0.5;
ber=2.*(1-ber1).*ber1;
H=38000000; h0=100;a=0; r=0;
l=(H-h0)*sec(a);
 W=l*theta/2;
alfa=1;
%Pt=0.5;


% The following formula is obtained by P63 simulation for the downlink 
I_0l=alfa*Pt*Dr^2/(2*W^2); 
% modified one, followed by 10^9 for unit conversion We found that this can get better results

% dr0=drl(0);
% dr0=0.0484;
dr0=0.3;
% Modified one, which is calculated by P63 Equation 3-27. For the downlink, make sure it is correct.

% pr=1./(sqrt(2*pi*dr0))./(IP*I_0l) .* ...
%    exp(-(log(IP)+2*r^2/(W^2)+dr0/2).^2./(2*dr0));
pr=1./(sqrt(2*pi*dr0))./(IP).*exp(-(log(IP/I_0l)+2*r^2/(W^2)+dr0/2).^2./(2*dr0));
% pr=1./(sqrt(2*pi*dr0))./(IP*I_0l*3.5*10^7) .* ...
%    exp(-(log(IP*3.5*10^7)+2*r^2/(W^2)+dr0/2).^2./(2*dr0));
bb=pr.*ber;
end