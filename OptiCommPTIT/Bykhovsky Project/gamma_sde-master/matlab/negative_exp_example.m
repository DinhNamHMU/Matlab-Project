clearvars
clf
close all

rng('default')
N = 5e5;
L = 100;
dt = 1e-4;
t = 0:dt:dt*N;
alpha = 1;
theta = 0.25;
tau = 20e-3;

x = zeros(L,N+1);
xi = randn(L,N);
x(:,1) = 1*ones(L,1);

%%
a = ones(L,1);
for k = 1:N
    x(:,k+1) = 1/(tau+dt)* ...
        (x(:,k)*tau + alpha*theta*dt + theta*dt/2*(xi(:,k).^2-1) ...
        + sqrt(2*x(:,k)*theta*tau*dt).*xi(:,k));
end

%% Time plot
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
[f,w] = ecdf(x(:));
[heights, positions] = ecdfhist(f,w,150);

y = linspace(0,max(x(:)),500);
F2 = theta^-alpha*(y).^(alpha-1).*exp(-y/theta)/gamma(alpha);

hf2 = figure(2);
ax2 = axes('Parent',hf2, ...
    'FontSize',12,...
    'FontName','Times New Roman' ...
    );

plot2 = bar(positions,heights,'hist');
set(plot2,'FaceColor', [0.75 0.75 0.75])
grid on
hold(ax2,'on')
plot(y,F2,'k','LineWidth',2);
hold(ax2,'off')
legend('Simulation','Theory','Location','SouthEast')
xlabel('$X$','FontName','Times New Roman','Interpreter','latex')
ylabel('$p_X(X)$','FontName','Times New Roman','Interpreter','latex')
xlim(ax2,[-.15 max(x(:))])
%
ax2b = axes('parent',hf2,'position',[.47 .43 .42 .42],...
    'FontSize',11,...
    'FontName','Times New Roman'); %  [left bottom width height]
plot2b = bar(positions,heights,'hist');
set(plot2b,'FaceColor', [0.75 0.75 0.75])
hold(ax2b,'on')
plot(y,F2,'k','LineWidth',2);
hold(ax2b,'off')
xlim(ax2b,[max(x(:))/2 max(x(:))]);
grid on
set(gcf, 'Color', 'w');


%% AutoCovariance

hf3 = figure(3);
ax3 = axes('Parent',hf3, ...
    'FontSize',12,...
    'FontName','Times New Roman', ...
    'XScale','log' ...
    );
for k = 1:L
    Cxx(k,:) = xcov(x(k,:),round(tau/dt*3),'coeff');
end

plot3 = plot((0:dt:tau*3+dt)*1e3,Cxx(1:5,round(tau/dt*3):end),...
    (0:dt:tau*3+dt)*1e3,mean(Cxx(:,round(tau/dt*3):end)),...
    'LineWidth',1.5);
set(plot3(1:5),'LineWidth',2,...
    'Color',[0.8 0.8 0.8]);
set(plot3(6),'LineWidth',2,'Color','k');  
set(plot3(6),'DisplayName','Mean')
set(plot3(5),'DisplayName','Simulation')
grid on
xlabel('$\tau [msec]$','FontName','Times New Roman','Interpreter','latex')
ylabel('$C_{XX}(\tau)$','FontName','Times New Roman','Interpreter','latex')
legend(plot3(5:6))
xlim(ax3,[0 60]);
set(gcf, 'Color', 'w');
