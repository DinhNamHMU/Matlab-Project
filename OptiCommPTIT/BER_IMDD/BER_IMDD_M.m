clear
P1_dB = -40;
M = [10:1:200];
y = CalculateBERM(M, P1_dB);

% Plot
close all
figure
semilogy(M,y,'b.-');      
grid on
xlabel('He so nhan APD M');
ylabel('LOG (BER)');