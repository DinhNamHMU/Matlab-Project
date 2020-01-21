clearvars
close all

%% Parameters

% Lognormal PDF parameters
% note: mu is defined different than in Matlab => for sdandard Matlab
% functions use log(mu) instead !
mu = 1;
sigma = .1;

% channel parameter
tau_c = 20e-3;

% sampling time
dt = 1e-4;

% number of channel samples
N = 1e6;

% number of uncorrelated realizations
L = 5;

%% SDE
% Generation
K = 2*mu^2*exp(sigma^2)*(exp(sigma^2)-1)/tau_c;
f = @(t,x) -K/2*(log(x/mu)+sigma^2)/sigma^2/x;
g = sqrt(K);

t = 0:dt:(dt*N);

sde_opt = sdeset('DGFUN',0, ...
    'ConstGFUN','yes', ...
    'NonNegative','yes');

for c = 1:L
    x(c,:) = sde_euler(f,g,t,mu-sigma^2/2,sde_opt);    
end

%% Time plot (example)
figure1 = figure(1);
hf1 = figure(1);
ax1 = axes('Parent',hf1, ...
    'FontSize',12,...
    'FontName','Times New Roman' ...
    );
plot1 = plot(t*1e3,x(1,:),'k','LineWidth',1.5);
grid on
xlabel('$t [msec]$','FontName','Times New Roman','Interpreter','latex')
ylabel('$x(t)$','FontName','Times New Roman','Interpreter','latex')
xlim(ax1,[0 50]);

%% PDF

% Empirical PDF
[f1,w1] = ecdf(x(:));
[heights1, positions1] = ecdfhist(f1,w1,150);
F1 = lognpdf(positions1,log(mu),sigma);

% Plot
hf2 = figure(2);
ax2 = axes('Parent',hf2, ...
    'FontSize',12,...
    'FontName','Times New Roman' ...
    );

plot2 = semilogy(positions1,F1, ...
    positions1,heights1);
set(plot2(1),'LineWidth',2,'Color','k');
set(plot2(2),'LineWidth',2,...
    'Color',[0.65 0.65 0.65], ...
    'LineStyle','--');
legend('Theory','Simulation ','Location','NorthEast')
xlabel('$x$','FontName','Times New Roman','Interpreter','latex')
ylabel('$f_x(x)$','FontName','Times New Roman','Interpreter','latex')
%ylim([1e-5 10])
%xlim([.95*min(positions2(:)) max(positions2(:))])
grid on
set(gcf, 'Color', 'w');

%% Auto-covariance function
hf3 = figure(3);
ax3 = axes('Parent',hf3, ...
    'FontSize',12,...
    'FontName','Times New Roman', ...
    'XScale','log' ...
    );
for k = 1:L
    Cxx(k,:) = xcov(x(k,:),round(tau_c/dt*3),'coeff');
end

plot3 = plot((0:dt:tau_c*3+dt)*1e3,Cxx(1:5,round(tau_c/dt*3):end),...
    (0:dt:tau_c*3+dt)*1e3,mean(Cxx(:,round(tau_c/dt*3):end)),...
    'LineWidth',1.5);
set(plot3(1:5),'LineWidth',2,...
    'Color',[0.8 0.8 0.8]);
set(plot3(6),'LineWidth',2,'Color','k');
set(plot3(6),'DisplayName','Mean')
set(plot3(5),'DisplayName','Simulation')
grid on
xlabel('$\tau [msec]$','FontName','Times New Roman','Interpreter','latex')
ylabel('$C_{xx}(\tau)$','FontName','Times New Roman','Interpreter','latex')
legend(plot3(5:6))
xlim(ax3,[0 tau_c*1e3*3]);
set(gcf, 'Color', 'w');
