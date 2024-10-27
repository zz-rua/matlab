function [numRows, numCols] = calculate_subplot_layout(numSubplots)
% 计算子图的行数和列数
% 输入参数：
% numSubplots: 子图的数量
% 输出参数：
% numRows: 子图的行数
% numCols: 子图的列数

% 最大行数和列数，你可以根据需要进行调整
maxRows = 3;
maxCols = 3;

% 初始化行数和列数
numRows = 1;
numCols = 1;

while numRows * numCols < numSubplots
    if numRows == maxRows
        numCols = numCols + 1;
    elseif numCols == maxCols
        numRows = numRows + 1;
    else
        % 优先增加列数，直到达到最大列数
        if numCols < maxCols
            numCols = numCols + 1;
        else
            numRows = numRows + 1;
        end
    end
end
end
