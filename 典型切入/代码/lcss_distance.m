function L = lcss_distance(series1, series2, epsilon)

% series1和series2分别是两个时间序列
% epsilon是阈值，表示两个数据点之间的最大允许距离。
% 函数返回的L是时间序列之间的LCSS相似度，取值范围为0到1，值越大表示两个时间序列越相似。

if isa(series1,"cell")
    series1 = cell2mat(series1);
end
if isa(series2,"cell")
    series2 = cell2mat(series2);
end

len1 = length(series1);
len2 = length(series2);

% Initialize the matrix with zeros
matrix = zeros(len1+1, len2+1);

for i = 1:len1
    for j = 1:len2
        % Calculate the distance between two data points
        dist = abs(series1(i) - series2(j));

        if dist <= epsilon
            matrix(i+1, j+1) = matrix(i, j) + 1;
        else
            matrix(i+1, j+1) = max(matrix(i+1, j), matrix(i, j+1));
        end
    end
end

% Calculate the LCSS similarity as the value in the bottom-right corner of the matrix
L = matrix(len1+1, len2+1) / min(len1, len2);
end
