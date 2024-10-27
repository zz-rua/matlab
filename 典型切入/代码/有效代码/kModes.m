function [clusters, centroids] = kModes(data, k, maxIterations)
    % data: 输入的离散型数据，每一行代表一个样本
    % k: 聚类的数量
    % maxIterations: 最大迭代次数

    % 获取数据集的大小和特征数
    % [numSamples, numFeatures] = size(data);

    % 随机初始化聚类中心
    centroids = datasample(data, k, 'Replace', false);

    for iter = 1:maxIterations
        % 分配每个样本到最近的聚类中心
        distances = pdist2(data, centroids, 'hamming'); % 使用 Hamming 距离
        [~, clusters] = min(distances, [], 2);

        % 更新聚类中心
        for i = 1:k
            mode_value = mode(data(clusters == i, :)); % 计算每个特征的众数
            centroids(i, :) = mode_value;
        end
    end
end
