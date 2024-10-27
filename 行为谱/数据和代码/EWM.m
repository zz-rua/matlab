function [value, weights] = EWM(data, Ind)
% 熵权法（Entropy Weight Method）计算指标客观权重
% data：各指标数据矩阵，行对应数据片段，列对应指标
% Ind：指定各指标的正向or负向(1代表指标值越大越好，2代表指标值越小越好)
% weight：返回各指标权重
% value：返回各片段得分

% Step1：归一化处理
[n,m] = size(data); % n个样本, m个指标
normalized_data = zeros(size(data));

for i = 1:m
    if Ind(i) == 1 %正向指标归一化
        normalized_data(:,i) = (data(:,i) - min(data(:,i))) / (max(data(:,i)) - min(data(:,i)));
    else
        normalized_data(:,i) = (max(data(:,i)) - data(:,i)) / (max(data(:,i)) - min(data(:,i))); %负向指标归一化
    end
end

% Step2：计算信息熵
entropy_values = zeros(1, m);

for i = 1:m
    p = normalized_data(:,i) / sum(normalized_data(:,i)); % 计算每个指标的概率
    entropy_values(i) = -(1/log(n))* sum(p .* log(p + eps)); % 计算信息熵，加上eps以避免log2(0)的情况
end

% Step3: 计算权重
sum_entropy = ones(1,m)-entropy_values; %计算信息熵冗余度
weights = sum_entropy./sum(sum_entropy);

% Step4: 计算样本综合得分
value = 100* normalized_data* weights'; %求综合得分

end
