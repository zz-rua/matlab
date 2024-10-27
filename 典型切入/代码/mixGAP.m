%% Gap Statistic:通过比较聚类结果与随机数据集之间的差异，来评估聚类的效果。

function [sse, chiIndex] = mixGAP(mixclusterdata, centroids, clusterIndices)
    numSamples = size(mixclusterdata, 1);
    numClusters = max(clusterIndices);

    % 计算原始数据集的SSE
    sse = zeros(numClusters, 1);
    for k = 1:numClusters
        clusterData = mixclusterdata(clusterIndices == k, :);
        numsamples = size(clusterData, 1);
        if numsamples > 1
            % 计算样本与聚类中心点之间的距离
            pairwiseDistances = mixdistance_1(centroids(k,:), clusterData).^2;

            % 计算簇内平均距离
            %clusterWSS = sum(sum(pairwiseDistances)) / (numsamples * (numsamples - 1)/2);
            clusterWSS = sum(pairwiseDistances) ;
            sse(k) = clusterWSS;
        end
    end

% 生成随机数据集，可以根据实际情况生成
numRandomDatasets = 5; % 随机数据集的数量
randomSSE = zeros(numClusters, numRandomDatasets);

for r = 1:numRandomDatasets
    randomData = rand(size(mixclusterdata)); % 生成随机数据，注意数据范围和分布

% 生成随机长度和元素的cell数据集
obx_velocity = mixclusterdata(:,1);
randomCellData = cell(size(obx_velocity));

for i = 1:size(obx_velocity,1)
    min_length = min(cellfun(@numel, obx_velocity));
    max_length = max(cellfun(@numel, obx_velocity));
    vectorLength = randi([min_length, max_length]);  % 随机生成列向量的长度

    min_value = min(cell2mat(obx_velocity));
    max_value = max(cell2mat(obx_velocity));
    randomVector = randi([round(min_value), round(max_value)], vectorLength, 1);  % 随机生成元素在1-49之间的列向量

    randomCellData{i, 1} = randomVector;
end

% 生成随机元素
clusterdata_v1 = mixclusterdata(:,2:4);




    for k = 1:maxClusters
        [~, ~, ~, ~, totalDist] = kmeans(randomData, k);
        randomSSE(k, r) = totalDist;
    end
end

% 计算Gap统计量
gap = zeros(maxClusters, 1);
for k = 1:maxClusters
    gap(k) = mean(log(randomSSE(k, :))) - log(sse(k));
end

% 绘制Gap统计量图
figure
plot(1:maxClusters, gap, '-o')
xlabel('聚类数')
ylabel('Gap统计量')
title('Gap统计量图')
