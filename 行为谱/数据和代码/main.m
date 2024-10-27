clear;clc
% 2024/03/20
% 驾驶能力评价模型
% 参数提取函数：para_extra
% 文件夹中的inputData为示例数据

%% 1.参数提取
% output = xlsread("车道保持参数.xlsx",'Truck');
output = xlsread("换道参数.xlsx",'Car');

% 数据处理（根据数据情况灵活处理)
output(output > 100) = NaN;
% 获取矩阵的大小
[rows, cols] = size(output);

% 遍历每一列
for col = 1:cols
    % 计算当前列非 NaN 值的均值
    col_mean = mean(output(~isnan(output(:, col)), col));
    
    % 用当前列的均值替换 NaN 值
    output(isnan(output(:, col)), col) = col_mean;
end
data = output;
% nanRows = any(isnan(output), 2);% 找到包含NaN值的行
% data= output(~nanRows, :);% 删除包含NaN值的行

% 指定各指标的正向or负向(1代表指标值越大越好，2代表指标值越小越好)
% Ind=[1 2 2 2 2 2 2 1 1 2]; % 车道保持
Ind=[1 1 2 1 2 2 2 2 1 1 2]; % 换道
%% 2.权重计算
% 熵权法计算客观权重
[value, weight_EWM] = EWM(data, Ind);
% weight_EWM = [0.23 0.07 0.04 0.04 0.07 0.05 0.12 0.29 0.04 0.04];

% 层次分析法获得主观权重
% weight_AHP = [0.14 0.26 0.06 0.01 0.02 0.02 0.06 0.21 0.13 0.10];
weight_AHP = [0.11 0.14 0.17 0.12 0.06 0.04 0.04 0.03 0.12 0.13 0.04];

% 主客观组合赋权
alpha = 0.5; % 可以根据实际情况调整熵权法的权重，这里取0.5作为示例
combined_weights = alpha * weight_EWM + (1 - alpha) * weight_AHP;

%% 3.能力评价模型
% 各指标阈值
% threshold = [1.27 0.08 0.99 5.79 2.07 0.61 0.90 1.35 2.00 0.23]; % 轿车车道保持
% threshold = [1.24 0.32 1.14 6.03 2.04 1.35 0.55 0.20 2.75 0.15]; % 客车车道保持
% threshold = [1.31 0.12 1.42 7.46 2.02 0.58 0.65 0.87 2.00 0.19]; % 货车车道保持

threshold = [13.35 6.37 2.79 1.13 0.26 0.90 -0.01 0.01 2.93 1.44 0.65]; % 轿车换道
% threshold = [9.07 1.85 3.14 0.57 0.8 15.15 -0.01 -0.1 1.74 0.6 1.48]; % 客车换道
% threshold = [8.75 2.17 4.28 0.7 0.55 1.91 -0.02 0.57 1.31 0.78 1.35]; % 货车换道

data = [data; threshold];
% 归一化处理
[n,m] = size(data); % n个样本, m个指标
normalized_data = zeros(size(data));
for i = 1:m
    if Ind(i) == 1 %正向指标归一化
        normalized_data(:,i) = (data(:,i) - min(data(:,i))) / (max(data(:,i)) - min(data(:,i)));
    else
        normalized_data(:,i) = (max(data(:,i)) - data(:,i)) / (max(data(:,i)) - min(data(:,i))); %负向指标归一化
    end
end

%求各驾驶人能力综合得分
Value = 100* normalized_data* combined_weights';

%各指标单项总分
OneValue = 100* normalized_data(end,:).* combined_weights;

%求总及格分
passValue = sum(OneValue);

% 将及格分映射为60后，各驾驶人得分
a = (100 - 60)/ (100 - passValue);
b = 60 - a* passValue;
Value_mapping = a* Value + b; % 其中最后一行为及格分60

% 作图展示
histogram(Value_mapping(1:end-1,:),'Normalization','probability')
xlabel('小轿车换道能力评价');
ylabel('概率');
hold on
xline(60,'--r','LineWidth',2)
xlim([0, 100]);
set(gcf, 'position', [400 200 800 400]); %设置图框位置及大小
set(gca,'Fontsize',16,'Linewidth',0.8); %横纵坐标范围、字体、线粗；
% 添加文字标签
text(57, 0.1, {'及','格','线'}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 16);

% 统计量值计算
passrate = sum(Value_mapping>60)/(length(Value_mapping)-1)*100; %及格率

% 添加“及格率”文字注释
% 确定文字注释的位置，这里选择图形的右上角
annotation_position = [80, 0.05]; % 修改为适合的图中位置
text(annotation_position(1), annotation_position(2), sprintf('及格率: %.2f%%', passrate), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'red', 'FontSize', 16);

% 放大图
figure
histogram(Value_mapping(1:end-1,:),'Normalization','probability')
hold on
xline(60,'--r','LineWidth',2)
set(gcf, 'position', [400 200 600 300]); %设置图框位置及大小
set(gca,'Fontsize',16,'Linewidth',0.8); %横纵坐标范围、字体、线粗；
% 添加文字标签
text(59, 0.08, {'及','格','线'}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 16);


