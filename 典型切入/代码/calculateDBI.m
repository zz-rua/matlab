function dbi = calculateDBI(timeSeriesData, centroids, clusterIndices)
    numClusters = max(clusterIndices);
    dbi = 0;
    
    for i = 1:numClusters
        clusterData = timeSeriesData(clusterIndices == i, :);  % 获取属于当前簇的样本数据
        centroid = centroids(i, :);  % 当前簇的中心点

        intraClusterDistances = [];
        for j = 1:length(clusterData)
            intraClusterDistances(j) = dtw_distance(clusterData{j}, centroid);
            % intraClusterDistances = pdist2(clusterData, centroid, 'euclidean');  % 计算簇内样本与中心点的距离
        end
        meanIntraDist = mean(intraClusterDistances);  % 簇内平均距离
        
        RI = [];
        for j = 1:numClusters
            if j ~= i
                otherClusterData = timeSeriesData(clusterIndices == j, :);  % 获取属于其他簇的样本数据
                otherCentroid = centroids(j, :);  % 其他簇的中心点

                interClusterDist = [];
                for k = 1:length(otherClusterData)
                    interClusterDist(k) = dtw_distance(otherClusterData{j}, otherCentroid);
                    % interClusterDist = pdist2(otherClusterData, otherCentroid, 'euclidean');  % 计算簇间样本与中心点的距离
                end

                meanInterDist = mean(interClusterDist);  % 簇间平均距离
                
                CentroidDist = dtw_distance(centroid, otherCentroid); % 计算聚类中心之间的距离
                % CentroidDist = pdist2(centroid, otherCentroid, 'euclidean'); % 计算聚类中心之间的距离

                RI = [RI, (meanInterDist+meanIntraDist)/CentroidDist];
            end
        end
        
        dbi = dbi + max(RI);
    end
    
    dbi = dbi / numClusters;
end
