function [Value, OneValue, passValue, normalized_threshold] = evaluate(data, Ind, threshold, combined_weights)

data = [data; threshold];
[~,m] = size(data); % n个样本, m个指标
normalized_data = zeros(size(data));
for i = 1:m
    i_data = data(:, i);

    % 使用留一交叉验证选择最佳带宽
    bandwidths = linspace(0.1, 1, 100);  % 设定一组带宽
    log_likelihoods = zeros(size(bandwidths));

    for j = 1:length(bandwidths)
        f_hat = ksdensity(i_data, 'Bandwidth', bandwidths(j));  % KDE估计
        log_likelihoods(j) = sum(log(f_hat + 1e-10));  % 计算对数似然作为优度指标
    end
    [~, best_idx] = max(log_likelihoods);
    best_bandwidth = bandwidths(best_idx);  % 最佳带宽对应最大对数似然

    % 核密度估计 (Kernel Density Estimation)
    [f, xi] = ksdensity(i_data, 'Bandwidth', best_bandwidth);  % f是估计的概率密度, xi是对应的data值

    % 找到密度最大值的位置
    [~, max_idx] = max(f);  % max_idx是密度最大的索引
    max_val = xi(max_idx);  % 对应密度最大的值

    % 插值获得新数据点的密度
    density_normalized = interp1(xi, f'/max(f), i_data, 'linear', 'extrap');

    % 处理指标的正向和负向
    if Ind(i) == 1
        % 指标为正向，越大越好
        % 所有大于max_val的值归一化为1
        normalized_data(:, i) = density_normalized;
        normalized_data(i_data >= max_val, i) = 1;
    elseif Ind(i) == 2
        % 指标为负向，越小越好
        % 所有小于max_val的值归一化为1
        normalized_data(:, i) = density_normalized;
        normalized_data(i_data <= max_val, i) = 1;
    end

    %% 绘制核密度估计结果
    % 定义 xlabel 字符串数组
    %     xlabels = {
    %         'THW均值(s)', 'THW标准差(s)', 'DHW标准差(m)', '速度标准差(m/s)', ...
    %         '加速度标准差(m/s^2)', '车道中心线偏移量最大值(m)', ...
    %         'TLC最小值(s)', '横向左右车距最小值(m)', '横向位置标准差(m)', '风险率'};
    % 车道保持-自由流标签
%     xlabels = {
%         '速度标准差(m/s)', '加速度标准差(m/s^2)', '车道中心线偏移量最大值(m)', ...
%         'TLC最小值(s)', '横向左右车距最小值(m)', '横向位置标准差(m)'};
    % 换道标签
        xlabels = {
            '开始时刻目标车道后方车辆纵向距离(m)', '开始时刻与目标车道后方车辆时距(s)', '开始时刻与目标车道后车速度差(m/s)', ...
            '越线前与本车道前方车辆最小时距(s)', '越线时刻与目标车道后方车辆时距(s)', '越线后与目标车道前方车辆最小时距(s)', '变道完成后一定时间内横向最大偏差(m)'};

    subplot(2,4,i);hold on

    %     % 核密度估计验证
    %     histogram(i_data, 'Normalization', 'pdf');  % 绘制数据的直方图
    %     hold on;
    %     plot(xi, f, 'LineWidth', 2);  % KDE曲线

    plot(xi, f'/max(f), 'LineWidth', 2);
    plot(i_data, density_normalized, '^', 'LineWidth', 0.5);
    ylabel('核密度估计归一化');

    yyaxis right
    plot(i_data, normalized_data(:,i)*100,'o', 'LineWidth', 0.5);
    ylabel('原始数据归一化');
    xlabel(xlabels{i});

%     % 前四种情况使用
    if i == 5 || i == 2
        xlim([0 20]);  % 设定x轴的范围
    end

    % 在图中增加threshold的标注
    xline(threshold(i), '--b', ['Threshold = ', num2str(threshold(i))], 'LineWidth', 2, 'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'right', 'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Times New Roman');

    set(gca,'Fontsize',12,'Linewidth',0.8);
    set(gcf, 'position', [400 200 400 300]);
end
legend('核密度估计','原始数据分布','归一化后分布', '')
%% 求各驾驶人能力综合得分
Value = round(100* normalized_data(1:end-1, :)* combined_weights, 2);

% 各指标单项总分
OneValue = round(100* normalized_data(end,:)'.* combined_weights, 2);

% 归一化后的阈值
normalized_threshold = 100* normalized_data(end,:)';

% 求总及格分
passValue = sum(OneValue);
