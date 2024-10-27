function [wss, chiIndex] = calculateCHI(timeSeriesData, centroids, clusterIndices)
    numSamples = size(timeSeriesData, 1);
    numClusters = max(clusterIndices);
    
    % Compute WSS (Within-cluster sum of squares)
    wss = 0;
    for i = 1:numClusters
        clusterData = timeSeriesData(clusterIndices == i, :);
        numsamples = size(clusterData, 1);
        if numsamples > 1
%             % 计算样本与聚类中心点之间的欧氏距离
%             pairwiseDistances = pdist2(clusterData, centroids(i, :), 'euclidean').^2;

            % 计算样本之间的距离
            pairwiseDistances = [];
            for j = 1:numsamples
                pairwiseDistances(j) = dtw_distance(clusterData(j), centroids(i, :));
            end

            % 计算簇内平均距离
            %clusterWSS = sum(sum(pairwiseDistances)) / (numsamples * (numsamples - 1)/2);
            clusterWSS = sum(sum(pairwiseDistances.^2)) ;
            wss = wss + clusterWSS;
        end
    end
    
    % Compute BSS (Between-cluster sum of squares)
    % globalCenter = meancentroids(timeSeriesData);
    % globalCenter = mean(timeSeriesData,1);
    withindis = zeros(length(timeSeriesData), length(timeSeriesData));
    for i = 1:length(timeSeriesData)
        for j = i+1:length(timeSeriesData)
            withindis(i,j) = dtw_distance(timeSeriesData{i},timeSeriesData{j});
            withindis(j,i) = withindis(i,j);
        end
    end
    [~, minIdx] = min(sum(withindis,2));
    globalCenter = timeSeriesData{minIdx};

    bss = 0;
    for i = 1:numClusters
        % bss = bss + pdist2(centroids(i, :), globalCenter, 'euclidean').^2 * sum(clusterIndices == i);

        bss = bss + dtw_distance(centroids{i},globalCenter).^2 * sum(clusterIndices == i);
    end
    
    % Compute CHI index
    chiIndex = (bss / (numClusters - 1)) / (wss / (numSamples - numClusters));
end
