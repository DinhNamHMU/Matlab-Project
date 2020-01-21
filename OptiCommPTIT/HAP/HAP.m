%Performance enhancement of LEO-to-ground FSO systems using
%All-optical HAP-based relaying - Minh Q. Vu

%Simulation Parameters
global P_t_S;
global P_t_P;
global G_A;

P_t_dBm=18; %Transmitted power (dBm)
P_t=10^(P_t_dBm/10)*10^(-3);
P_t_S=P_t;
P_t_P=P_t;
G_A_dB=10;  %Gian of amplifier (dB)
G_A=10^(G_A_dB/10);

P_th=-65:5:-20;

%Calculation
[P_PG,N_0_P,P_r_P]=probabilityPG();
BER_e2e_DAF=zeros(1,length(P_th));

for i=1:length(P_th)
    BER_e2e_DAF(i)=1-1/2*(1-0.5*erfc(P_th(i)/sqrt(N_0_P)))*(1-P_PG)...
                   -1/2*(1-0.5*erfc((P_r_P-P_th(i))/sqrt(N_0_P)))*(1-P_PG)...
                   -1/4*erfc(P_th(i)/sqrt(N_0_P))*P_PG...
                   -1/4*erfc((P_r_P-P_th(i))/sqrt(N_0_P))*P_PG;
end

%Plot function
semilogy(P_th,BER_e2e_DAF);
xlabel('Threshold power, P_{th} (dBm)');
ylabel('BER');