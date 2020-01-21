function psk=no(fai) 
%global wavelength;
%tt=1;
% drw=zeros(41,100000);
% wanderw=zeros(1,41);
% angle=0:1.5:60;
% divergence_angle=(5:1.875:80).*10.^(-6);
angle =0;
zenith=angle.*pi./180;
H = 38.*10.^6;% satellite height
h0=100;
z = (H-100).*sec(zenith);% distance of transmition
wavelength=1550.*10^(-9);% wavelength
k = 2.*pi./wavelength;% number of wave
Wo=0.3;% spot radius!!! ; waist=0.0329, to ensure that the spot radius is larger than the waist spot radius
divergence_angle= 30.*10.^(-6);%linspace(5,80,21).*10.^(-6);%

%Fo = z./(1-((z.*divergence_angle./Wo).^2-(2.*z./(k.*Wo.^2)).^2).^(0.5));
Waist=2.*wavelength./(pi.*divergence_angle);% waist radius
f=pi*(Waist.^2)/wavelength;% confocal parameter
z0=f.*(((Wo./Waist).^2-1).^0.5);% emission point from the waist distance %
Fo=z0+(f.^2)./z0;% radius of curvature at the launch aperture
Ao=2.*z./(k.*Wo.^2);
Oo = 1+z./Fo;
As = Ao./(Oo.^2+Ao.^2);
W=Wo+divergence_angle.*z./2;
Wmax=max(Wo)+max(divergence_angle).*(H-100).*sec(max(zenith))./2;
r=linspace(0,Wmax,100000);

%Power=0:0.1:4;                                       % average transmit power
Power=1;
c=3.*(1e8);                                                % speed of light
ff=c./wavelength;                                          % light frequency
yita=0.75;                                                 % quantum efficiency
h=6.625e-34;
bitrate=1e9;%1e9;
Ts=1./bitrate;
% Ps=(1:1:10000).*(1e-9);
Diameter=0.5;   % cheat receiving aperture
% Diameter=0:0.04:1.6;
alfa=1;
taoT=1;    % transmit antenna transmittance
taoR=1;    % receiving antenna transmittance
PT=Power*taoT;
I_0l=alfa.*PT.*(Diameter).^2./(2.*W.^2); 

 %-------------------------------Light intensity flicker variance-------------------------------

 IP1=6*10^-8;

%figure,plot(IP1,prI);
 
%%%%  BER
 
yita=0.75;     % quantum efficiency
G=100;       % average gain refers to Ding's paper
F=G^0.5;    % excess noise factor
IB=10^-9;   % background light power refers to Ding's paper
Idc=10^-9;  % dark current
Rl=50;      % Load Resistance
T=300;      % effective noise temperature 
hp=6.6260693*10^(-34);   % Planck constant 
e=1.60217733*10^(-19);   % electronic power
Kc=1.3806505*10^(-23);   % Boltzmann constant
ff=c/(wavelength); % light frequency
%Be=4e+7;         % APD bandwidth
Bw=1e-8;% 10 nm the bandwith of optical filter
Ib=pi*Diameter^2*IB*Bw/4;     % enters the background light of the system
%dietav=B0;
%
Kb=yita.*Ib.*Ts/(hp.*ff);
Ks=yita.*IP1.*Ts./(hp.*ff);
deltaTT=2.*Kc.*T.*Ts./Rl; % thermal noise
%
m0=(G.*e.*Kb+Idc.*Ts)*ones(1,1000);
m1=G.*e.*(Kb+Ks)+Idc.*Ts;
delta00=((G.*e).^2.*F.*Kb+deltaTT)*ones(1,1000);
delta11=(G.*e).^2.*F.*(Kb+Ks)+deltaTT;

 delta1=sqrt(delta11);delta0=sqrt(delta00);   % formula modification will make the Gaussian noise variance in the integration
 
 %gama=(m0.*delta1.^2-m1.*delta0.^2)./(delta1.^2-delta0.^2)+delta0.*delta1./(delta1.^2-delta0.^2).*...
  %   sqrt((m1-m0).^2+2*(delta1.^2-delta0.^2).*log(delta1./delta0));
 %gama(1)=0.0841*1.0e-05;
  
  psk=0.5.*erfc(m1./sqrt(2.*delta11).*cos(fai));
 
 % ook
 
 