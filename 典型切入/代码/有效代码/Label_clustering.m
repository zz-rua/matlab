% load('TBL.mat')
variables = {TBL{:,3}, TBL{:,5}, TBL{:,7}, TBL{:,9}, TBL{:,11}, TBL{:,12}, TBL{:,14}, TBL{:,16}, TBL{:,18}, TBL{:,20}, TBL{:,22}};

% 初始化一个存储独热编码结果的单元数组
oneHotEncodings = [];

% 对每个分类变量进行独热编码
for i = 1:numel(variables)
    uniqueValues = unique(variables{i}); % 获取当前变量的不重复值
    oneHotEncoding = zeros(length(variables{i}), numel(uniqueValues)); % 初始化独热编码矩阵

    % 使用循环将当前变量编码成独热编码
    for j = 1:length(variables{i})
        oneHotEncoding(j, variables{i}(j) == uniqueValues) = 1;
    end

    % 存储结果到单元数组中
    oneHotEncodings = [oneHotEncodings,oneHotEncoding];
end

%% 层次聚类（Hierarchical Clustering）
Z = linkage(oneHotEncodings, 'average' ,'hamming');
% SC确定最佳聚类数 -- 七类 与CHI结果一致
maxleafNodes = 30;
silhouetteValues = zeros(1, maxleafNodes);
ch_value = zeros(1, maxleafNodes);
for leafNodes = 2:maxleafNodes
    T = cluster(Z, 'maxclust', leafNodes);
    % 轮廓系数评估
    silhouetteValues(leafNodes) = mean(silhouette(oneHotEncodings, T));
    % Calinski-Harabasz指数评估
    ch_index = evalclusters(oneHotEncodings, T, 'CalinskiHarabasz');
    ch_value(leafNodes) = ch_index.CriterionValues;
end
% 显示评估结果
figure
plot(1:maxleafNodes, silhouetteValues, 'rx-','LineWidth',1.5);
xlabel('聚类数');  ylabel('轮廓系数');
title('轮廓系数法确定聚类数');    grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [400 200 400 300]);

%% 可视化分层聚类的树状图
cutoff = median([Z(end-6,3) Z(end-5,3)]);
[H,~,outperm] = dendrogram(Z,'ColorThreshold',cutoff);
set(H,'LineWidth',1.5) %更改树状图线条宽度
title('Hierarchical Clustering Dendrogram');
xlabel('数据点');
ylabel('链接距离');
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 600 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高

%% 计算聚类中心
numClusters = 12;
T = cluster(Z, 'maxclust', numClusters);

clusterCenters = zeros(numClusters, size(oneHotEncodings, 2)); % 初始化中心点矩阵

for i = 1:numClusters
    clusterData = oneHotEncodings(T == i, :); % 提取属于当前簇的数据
    %     clusterCenter = sum(clusterData,1) / size(clusterData, 1);
    %     clusterCenters(i, :) = clusterCenter; % 计算每个特征中1的比例作为聚类中心的值
    clusterProportions(i, :) = size(clusterData, 1) /size(T, 1); % 计算每一类的占比
end

% 获取每个分类变量的类别数
numCategories = zeros(1, size(cell2mat(variables),2));
for i = 1:size(cell2mat(variables),2)
    uniqueValues = unique(variables{i});
    numCategories(i) = numel(uniqueValues);
end

% 初始化用于存储原始标签的数组
originalLabels = zeros(size(clusterCenters, 1), length(numCategories));
for i = 1:size(clusterCenters, 1)
    % 根据每个分类变量的类别数，将聚类中心的每个部分映射回原始标签
    startIndex = 1;
    for j = 1:numel(numCategories)
        endIndex = startIndex - 1 + numCategories(j);
        [~, maxIndex] = max(clusterCenters(i, startIndex:endIndex));
        originalLabels(i, j) = maxIndex;
        startIndex = endIndex + 1;
    end
end


% 创建数字标签到文字标签的映射
% labelMap = containers.Map([1, 2, 3, 4], {'低', '中', '高', '无'});
% labelMap = containers.Map([1, 2, 3], {'较短', '适中', '较长'});
% labelMap = containers.Map([1, 2, 3, 4], {'匀速', '加速', '减速', '加减'});
% labelMap = containers.Map([1, 2], {'晴朗', '雨雪'});
labelMap = containers.Map([1, 2, 3], {'乘用车', '非乘用车', '无前车'});

% 将数字标签映射为文字标签
textLabels = cell(size(originalLabels));
for col = 9:10%1:4%size(numLabels, 2)
    for row = 1:size(originalLabels, 1)
        numLabel = originalLabels(row, col);
        textLabels{row, col} = labelMap(numLabel);
    end
end

infCount = sum(isinf(paramArray(:, 4)));
rowIndices2 = find(isinf(paramArray(:, 4))); % Inf 标签位置
countNoValue = sum(strcmp(TBL.FO_TYPE, '无')); % 无前车 标签数量
rowIndices = find(strcmp(TBL.FO_TYPE, '无')); % 无前车 标签位置

%% k-medoids聚类
maxK = 30;
sse = zeros(1, maxK);% 存储每个聚类数对应的误差平方和
silhouette_values = zeros(1, maxK);
for k = 1:maxK
    [idx, ~, sumd] = kmedoids(oneHotEncodings, k,"Distance","hamming");
    sse(k) = sum(sumd); % 计算每个样本与其所属聚类中心的距离平方和
    silhouette_values(k) = mean(silhouette(oneHotEncodings, idx,"Hamming"));% 轮廓系数法确定聚类数
end

% 绘制误差平方和与聚类数的关系图
figure
subplot(1,2,1);
plot(1:maxK, sse, 'bo-','LineWidth',1.5);
xlabel('聚类数');
ylabel('误差平方和');
title('手肘法确定聚类数');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；

% 绘制轮廓系数与聚类数的曲线
subplot(1,2,2);
plot(1:maxK, silhouette_values, 'rx-','LineWidth',1.5);
xlabel('聚类数');
ylabel('轮廓系数');
title('轮廓系数法确定聚类数');
gri                                                                                                                                                                                                                                                                                                                                                                     d on;
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 800 300]);

% 通过观察图形选择最佳聚类数 手动确定最佳聚类数
bestK = input('请输入最佳聚类数：');
k = bestK; % 指定聚类数
[idx, centers] = kmedoids(oneHotEncodings, k, "Distance", "hamming" );

%% k-modes聚类
variables = [TBL{:,3}, TBL{:,5}, TBL{:,7}, TBL{:,9}, TBL{:,11}, TBL{:,12}, TBL{:,14}, TBL{:,16}, TBL{:,18}, TBL{:,20}, TBL{:,22}];
% 设置聚类数量和最大迭代次数
maxIterations = 10;
maxClusters = 30;
silhouette_scores = zeros(1, maxClusters);
for k = 2:maxClusters
    % 运行 K-Modes 算法
    [clusters, centroids] = kModes(variables, k, maxIterations);
    silhouette_scores(k) = mean(silhouette(variables, clusters, 'hamming'));
end

% 绘制轮廓系数法图表
plot(2:maxClusters, silhouette_scores(2:end), 'o-','LineWidth',1.5);
xlabel('Number of Clusters');
ylabel('Silhouette Score');
title('Silhouette Method for Optimal Clusters');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；

