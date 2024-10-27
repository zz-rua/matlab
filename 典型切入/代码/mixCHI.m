function [wss, chiIndex] = mixCHI(mixclusterdata, centroids, clusterIndices)
    numSamples = size(mixclusterdata, 1);
    numClusters = max(clusterIndices);
    
    % Compute WSS (Within-cluster sum of squares)
    wss = 0;
    for i = 1:numClusters
        clusterData = mixclusterdata(clusterIndices == i, :);
        numsamples = size(clusterData, 1);
        if numsamples > 1
            % 计算样本与聚类中心点之间的距离
            pairwiseDistances = mixdistance_1(centroids(i,:), clusterData).^2;

            % 计算簇内平均距离
            %clusterWSS = sum(sum(pairwiseDistances)) / (numsamples * (numsamples - 1)/2);
            clusterWSS = sum(pairwiseDistances) ;
            sse(i) = clusterWSS;
            wss = wss + clusterWSS;
        end
    end
    
    % Compute BSS (Between-cluster sum of squares)
    withindis = mixdistance_1(mixclusterdata, mixclusterdata);
    [~, minIdx] = min(sum(withindis,2));

    globalCenter = mixclusterdata(minIdx,:);

    bss = 0;
    global_dis = mixdistance_1(globalCenter,centroids);

    for i = 1:numClusters
        bss = bss + global_dis(i).^2 * sum(clusterIndices == i);
    end
    
    % Compute CHI index
    chiIndex = (bss / (numClusters - 1)) / (wss / (numSamples - numClusters));
end
