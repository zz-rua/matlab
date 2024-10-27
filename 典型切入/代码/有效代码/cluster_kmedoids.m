function [centroids, clusterIndices] = cluster_kmedoids(mixclusterdata, numClusters)
% k-mediods方法实现时间序列聚类
% 输入：mixclusterdata 时间序列数据 cell
% 输入：numClusters聚类数
% 输出：centroids 聚类中心
% 输出：clusterIndices 聚类标签
% 函数：mixdistance_1 计算距离（可舍弃）；dtw_distance 计算DTW距离；max_distance 计算新旧聚类中心间的距离

maxIterations = 50;
tolerance = 0.001;  % 聚类中心变化阈值

% 随机初始化聚类中心
numTimeSeries = size(mixclusterdata, 1);
centroids = mixclusterdata(randperm(numTimeSeries, numClusters), :);

% 迭代更新聚类中心
for iter = 1:maxIterations
    % 计算每个时间序列与聚类中心的距离
    distances = mixdistance_1(mixclusterdata, centroids);

    % 分配样本到最近的聚类中心
    [~, clusterIndices] = min(distances, [], 2);

    % 更新聚类中心
    NEWcentroids = cell(numClusters, 1);
    for k = 1:numClusters
        clusterData = mixclusterdata(clusterIndices == k,:);
        if ~isempty(clusterData)
            % 找出与聚类中其他点的总距离之和最小的数据点的索引
            withdis = mixdistance_1(clusterData, clusterData);
            [~, minIdx] = min(sum(withdis,2));
            NEWcentroids{k} = clusterData{minIdx};
        end
    end

    % 检查聚类中心的变化
    if max_distance(NEWcentroids , centroids) < tolerance
        break;  % 聚类中心不再变化，提前终止迭代
    end

    centroids = NEWcentroids;
end
end