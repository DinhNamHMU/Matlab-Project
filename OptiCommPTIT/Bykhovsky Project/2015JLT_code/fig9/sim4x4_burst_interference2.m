clearvars

global K Pt h_kmn noise

%% Initialize
% Configuration
K = 16;
M = K;
N = 64;

% Power
Pt = 1; % Normalized power of transmitter
max_dB = 22.2; % maximum SNR [dB]
noise = Pt*10^-(max_dB/10)/N;

h_n = freq_gain_values(N);

ref = sum(bits_snr(Pt/N*h_n(1:N).^2/noise));
refHH = sum(HH(Pt/N*h_n.^2/noise));

interf_default = 10.^(-23/20);

% Reuse = 2
%% Channel Gain
h_km = zeros(K,K);
for i = 1:K % constant
    if i == 11
        interf_default = 10.^(-12/20);
    else
        interf_default = 10.^(-23/20);
    end
    temp_mat = zeros(sqrt(K),sqrt(K));
    [I,J] = ind2sub([sqrt(K) sqrt(K)],i);
    temp_mat(I,J) = 1; % 0,0
    if (I - 1) > 0
        % if (J - 1) > 0 % -1,-1
        %    temp_mat(I-1,J-1) = interf_default;
        % end
        if J  > 0 % -1,0
            temp_mat(I-1,J) = interf_default;
        end
        %         if (J + 1) <= sqrt(K) % -1,1
        %             temp_mat(I-1,J+1) = interf_default;
        %         end
    end
    if (J - 1) > 0 % 0,-1
        temp_mat(I,J-1) = interf_default;
    end
    if (J + 1) <= sqrt(K) % 0,1
        temp_mat(I,J+1) = interf_default;
    end
    if (I + 1) <= sqrt(K)
        %         if (J - 1) > 0 % 1,-1
        %             temp_mat(I+1,J-1) = interf_default;
        %         end
        if J  > 0 % 1,0
            temp_mat(I+1,J) = interf_default;
        end
        %         if (J + 1) <= sqrt(K) % 1,1
        %             temp_mat(I+1,J+1) = interf_default;
        %         end
    end
    h_km(i,:) = temp_mat(:);
end
h_km = (h_km + h_km')/2;

for n = 1:N
    h_kmn(:,:,n) = h_km*h_n(n);
end
%clear h_km;

%% Algorithm

cnt1 = 1;
rho = boolean(zeros(K,N));
for m = 1:K
    for i = 1:N
        run_idx = find(~rho(:,i));
        delta_r_m = zeros(1, numel(run_idx));
        r_m_ref = sum(bit_rate_func(rho));
        for k = 1:numel(run_idx)
            temp_rho = rho;
            temp_rho(run_idx(k),i) = true;
            delta_r_m(k) = sum(bit_rate_func(temp_rho))- r_m_ref;
        end
        [max_delta, I] = max(delta_r_m);
        if max_delta > 0
            rho(run_idx(I),i) = 1;
        end
        %disp([num2str(r_m_ref) ' ' num2str(nnz(~rho)) ' ' num2str([i m])])
    end
end

[r_m,sinr] = bit_rate_func(rho);

%% bit-and-power allocation

[~,sort_idx2] = sort(r_m,'ascend');
R_min = sum(HH(sinr(sort_idx2(1),rho(sort_idx2(1),:))));

for m = 1:K
    R_m(sort_idx2(m)) = sum(HH(sinr(sort_idx2(m),find(rho(sort_idx2(m),:)))));
end

%%
x = [1 1; 1 2; 1 3; 1 4; 2 1; 2 2;2 3;2 4;3 1; 3 2; 3 3; 3 4; 4 1; 4 2; 4 3; 4 4];
data = R_m(:)/refHH;
mean(data)

%% Plot results
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YTickLabel',{'','1','2','3','4',''},...
    'YTick',[0 1 2 3 4 5],...
    'XTickLabel',{'1','2','3','4'},...
    'XTick',[1 2 3 4],...
    'PlotBoxAspectRatio',[2 2 1],...
    'FontSize',15,...
    'FontName','Times New Roman',...
    'DataAspectRatio',[1 1 1]);
xlim(axes1,[0.5 4.5]);
ylim(axes1,[0.5 4.5]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');

scatter(x(:,1),x(:,2),(data(:).^2)*4400,'MarkerFaceColor',[0 .5 .5])
ylabel('Transceiver array','Interpreter','none','FontSize',18,...
    'FontName','Times New Roman');
xlabel('Transceiver array','Interpreter','none','FontSize',18,...
    'FontName','Times New Roman');
%title('Bit-rate [normalized]','Interpreter','none','FontSize',18,...
%    'FontName','Times New Roman');
set(gcf, 'Color', 'w');

%%
hgsave exeptional_example
