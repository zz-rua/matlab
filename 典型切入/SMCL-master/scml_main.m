clear;clc
data = readmatrix("SMCL-master\dataset\output_file.xlsx","Sheet","Sheet2");

% 提取数值型和类别型变量
numeric_data = data(:, 1:6);
categorical_data = data(:, 7:end);

% 获取每个类别型变量的类别数
num_categories = [4, 2, 2, 2];

% 初始化变量以保存独热编码后的数据
one_hot_encoded_data = [];

% 对每个类别型变量进行独热编码
for col = 1:size(categorical_data, 2)
    one_hot_encoded_col = dummyvar(categorical_data(:, col));    
    one_hot_encoded_data = [one_hot_encoded_data, one_hot_encoded_col];
end

% 将数值型变量和独热编码后的类别型变量合并
encoded_data = [numeric_data, one_hot_encoded_data];
%%
% data = encoded_data;
smcl(encoded_data)