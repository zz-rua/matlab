% 统计聚类结果，得到典型场景各类数据
% 聚类中心：centroids
% 聚类标签：clusterIndices
k = 24; % 指定聚类数
[clusterIndices2, centroids2] = kmedoids(oneHotEncodings, k, "Distance", "hamming" );

% 1.统计各簇数场景总数及占比;
numClusters = k;
clusterStaistical = zeros(numClusters,2);
for i = 1:numClusters
    clusterData = oneHotEncodings(clusterIndices2 == i, :); % 提取属于当前簇的数据
    clusterStaistical(i, 1) = size(clusterData, 1); % 每一类的总数
    clusterStaistical(i, 2) = size(clusterData, 1) /size(clusterIndices2, 1); % 计算每一类的占比
    % 计算每一类最小ttc均值，风险度、风险率均值
    % clusterStaistical(i, 3) = mean(min_ttc(clusterIndices == i, :)); % 最小ttc均值
end

% 2.统计各聚类标签下各变量占比
% 获取每个分类变量的类别数
numCategories = zeros(1, size(cell2mat(variables),2));
for i = 1:size(cell2mat(variables),2)
    uniqueValues = unique(variables{i});
    numCategories(i) = numel(uniqueValues);
end

% 初始化用于存储原始标签的数组
for i = 1:numClusters
    clusterData = oneHotEncodings(clusterIndices2 == i, :); % 提取属于当前簇的数据
    startIndex = 1;
    originalLabels = zeros(size(clusterData, 1), length(numCategories));
    % proportion = zeros(sum(numCategories),2);
    for j = 1:numel(numCategories)
        endIndex = startIndex - 1 + numCategories(j);
        for k = 1:size(clusterData,1)
            [~, maxIndex] = max(clusterData(k, startIndex:endIndex));
            originalLabels(k, j) = maxIndex;
        end
        % 第i个聚类簇中各变量占比
        for num = startIndex:endIndex
            proportion(num,2*i-1) = sum(originalLabels(:,j) == num-startIndex+1);
            proportion(num,2*i) = sum(originalLabels(:,j) == num-startIndex+1)/size(clusterData,1);
        end
        startIndex = endIndex + 1;
    end
end

%%
k=23;
[clusters, centroids] = kModes(variables, k, maxIterations);
silhouette_scores = mean(silhouette(variables, clusters, 'hamming'))

% 1.统计各簇数场景总数及占比;
numClusters = k;
clusterStaistical = zeros(numClusters,2);
for i = 1:numClusters
    clusterData = variables(clusters == i, :); % 提取属于当前簇的数据
    clusterStaistical(1, 2*i-1) = size(clusterData, 1); % 每一类的总数
    clusterStaistical(1, 2*i) = size(clusterData, 1) /size(clusters, 1); % 计算每一类的占比
    % 计算每一类最小ttc均值，风险度、风险率均值
    % clusterStaistical(i, 3) = mean(min_ttc(clusterIndices == i, :)); % 最小ttc均值
end

% 2.统计各聚类标签下各变量占比
% 获取每个分类变量的类别数
numCategories = zeros(1, size(variables,2));
for i = 1:size(variables,2)
    uniqueValues = unique(variables(:,i));
    numCategories(i) = numel(uniqueValues);
end

% 初始化用于存储原始标签的数组
proportion = zeros(sum(numCategories),2*numClusters);
for i = 1:numClusters
    clusterData = variables(clusters == i, :); % 提取属于当前簇的数据
    startIndex = 1;
    for j = 1:numel(numCategories)
        endIndex = startIndex - 1 + numCategories(j);
        % 第i个聚类簇中各变量占比
        for num = startIndex:endIndex
            proportion(num,2*i-1) = sum(clusterData(:,j) == num-startIndex+1);
            proportion(num,2*i) = sum(clusterData(:,j) == num-startIndex+1)/size(clusterData,1);
        end
        startIndex = endIndex + 1;
    end
end
