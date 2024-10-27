clear;clc
% 2024/10/11
% 驾驶能力评价模型
% 参数提取函数：para_extra
% 文件夹中的inputData为示例数据

%% 1.参数提取
% 弹出窗口选择一个Excel文件
[filename, filepath] = uigetfile('*.xlsx', 'Select an Excel File');
full_file_path = fullfile(filepath, filename);

% data = xlsread(full_file_path,'Car');
data = xlsread(full_file_path,'Bus_Truck');

for i = 1:size(data, 2)
    data(isnan(data(:, i)), :) = [];
    data(data(:, i) == 65535, :) = [];
    data(data(:, i) == 9999, :) = [];
end
% 指定各指标的正向or负向(1代表指标值越大越好，2代表指标值越小越好)
% Ind=[1 2 2 2 2 2 1 1 2 2]; % 车道保持
% Ind=[2 2 2 1 1 2]; % 车道保持-自由流
Ind=[1 1 1 1 1 1 2]; % 换道
%% 2.权重计算
% 熵权法计算客观权重
[~, weight_EWM] = EWM(data, Ind);

% 层次分析法获得主观权重
% weight_AHP = [0.14 0.06 0.01 0.02 0.02 0.06 0.21 0.13 0.10 0.26]; % 车道保持
% weight_AHP = [0.10 0.09 0.14 0.28 0.21 0.18]; % 车道保持-自由流
weight_AHP = [0.14 0.16 0.19 0.15 0.14 0.15 0.07]; % 换道

% 主客观组合赋权
alpha = 0.5; 
combined_weights = alpha * weight_EWM + (1 - alpha) * weight_AHP;

combined_weights = round(combined_weights', 2); % 保留两位小数
% 调整权重和为1
difference = 1 - sum(combined_weights);
[~, max_idx] = max(combined_weights);  % 找到当前最大的权重
combined_weights(max_idx) = combined_weights(max_idx) + difference;

%% 3.能力评价模型
[filename, filepath] = uigetfile('*.xlsx', 'Select an Excel File'); % 选择阈值文件
full_file_path = fullfile(filepath, filename);

data_threshold = xlsread(full_file_path);

% 各指标阈值
threshold = data_threshold(:,8)';
threshold(isnan(threshold)) = [];
%% 求各驾驶人能力综合得分
[Value, OneValue, passValue, normalized_threshold] = evaluate(data, Ind, threshold, combined_weights);
% OneValue：单指标量化得分
% passValue：总计
% normalized_threshold：归一化后阈值
re = [normalized_threshold, OneValue;0,passValue];
% 将及格分映射为60后，各驾驶人得分
a = (100 - 60)/ (100 - passValue);
b = 60 - a* passValue;
Value_mapping = a* Value + b;

OneValue_mapping = OneValue*60/passValue; % 指标得分线性变换


%% 作图展示
figure
histogram(Value_mapping,'Normalization','probability');
% xlabel('客货车车道保持（跟驰）能力评价');
ylabel('概率');
hold on
xline(60,'--r','LineWidth',2)
xlim([0, 100]);
set(gcf, 'position', [400 200 800 400]); %设置图框位置及大小
set(gca,'Fontsize',14,'Linewidth',0.8); %横纵坐标范围、字体、线粗；
% 添加文字标签
text(57, 0.06, {'及','格','线'}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 14);

% 统计量值计算
passrate = sum(Value_mapping>60)/length(Value_mapping)*100; %及格率

% 添加“及格率”文字注释
% 确定文字注释的位置，这里选择图形的右上角
annotation_position = [80, 0.06]; % 修改为适合的图中位置
text(annotation_position(1), annotation_position(2), sprintf('及格率: %.2f%%', passrate), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'red', 'FontSize', 16);

set(gcf, 'position', [400 200 600 300]); %设置图框位置及大小
set(gca,'Fontsize',14,'Linewidth',0.8); %横纵坐标范围、字体、线粗；


% 创建一个新的小坐标轴，用于放大图
axes('Position',[0.2, 0.3, 0.30, 0.40]); % 在第一张图的左上方创建小图，调整位置和大小
box on; % 添加边框
hold on;
% 第二张图：放大图
histogram(Value_mapping,'Normalization','probability');
xline(60,'--r','LineWidth',2)
set(gca,'Fontsize',12,'Linewidth',0.6); %横纵坐标范围、字体、线粗；
% 添加文字标签
text(56, 0.08, {'及','格','线'}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 12);

% 其他指标
sum(Value_mapping==100)
length(Value_mapping)-sum(Value_mapping>60)
min(Value_mapping)