clearvars
clf
close all

rng('default')
N = 5e5;
L = 10;
dt = 1e-4;
t = 0:dt:dt*N;
alpha = 5;
beta = 1.05;
tau = 20e-3;

x1 = zeros(L,N+1);
x2 = zeros(L,N+1);
xi1 = randn(L,N);
xi2 = randn(L,N);
x1(:,1) = 1*ones(L,1);
x2(:,1) = 1*ones(L,1);

%%
a = ones(L,1);
for k = 1:N
    x1(:,k+1) = 1/(1+dt/tau)*(x1(:,k)+dt/tau+sqrt(2*x1(:,k)*dt/tau/alpha).*xi1(:,k)+1/tau/alpha/2*(dt*xi1(:,k).^2-dt));
    x2(:,k+1) = 1/(1+dt/tau)*(x2(:,k)+dt/tau+sqrt(2*x2(:,k)*dt/tau/beta).*xi2(:,k)+1/tau/beta/2*(dt*xi2(:,k).^2-dt));
end

y = x1.*x2;

%% AutoCovariance

for k = 1:L
    Cyy(k,:) = xcov(y(k,:),round(tau/dt*3),'coeff');
end
t = 0:dt:tau*3;

theoryCyy = exp(-t/tau);
sig_x1 = 1/alpha;
sig_x2 = 1/beta;

theoryCyy2 = (sig_x1*sig_x2*exp(-2*t/tau) + (sig_x1+sig_x2)*exp(-t/tau))/(sig_x1*sig_x2 + sig_x1+sig_x2);

%%
hf3 = figure(3);
ax3 = axes('Parent',hf3, ...
    'FontSize',12,...
    'FontName','Times New Roman', ...
    'XScale','log' ...
    );
plot3 = plot(t*1e3,Cyy(1:8,round(tau/dt*3)+1:end),...
    t*1e3,mean(Cyy(1:8,round(tau/dt*3)+1:end)),...
    t*1e3,theoryCyy,...
    t*1e3,theoryCyy2,...
    'LineWidth',2);
set(plot3(1:8),'LineWidth',2,...
     'Color',[0.7 0.7 0.7]);
plot3(8).DisplayName = 'Simulation';
plot3(9).Color = 'k';
plot3(9).DisplayName = 'Mean';
plot3(10).DisplayName = '$\exp(-\tau/\tau_c)$';
plot3(10).LineStyle = '--';
plot3(10).Color = 'b';
plot3(11).DisplayName = 'Rigorous $b_I(\tau)$';
plot3(11).LineStyle = '-.';
plot3(11).Color = 'r';
grid on
xlabel('$\tau [msec]$','FontName','Times New Roman','Interpreter','latex')
ylabel('$C_{I}(\tau)$','FontName','Times New Roman','Interpreter','latex')
hl = legend(plot3(8:11));
set(hl,'Interpreter','latex','FontSize',11)
xlim(ax3,[0 tau*1e3*3]);
set(gcf, 'Color', 'w');

% export_fig covariance_gg_fixed.pdf
% export_fig covariance_gg_fixed.png
% hgsave covariance_gg_fixed
