function dbi = mixDBI(mixclusterdata, centroids, clusterIndices)
    numClusters = max(clusterIndices);
    dbi = 0;


    for i = 1:numClusters
        clusterData = mixclusterdata(clusterIndices == i, :);  % 获取属于当前簇的样本数据
        centroid = centroids(i, :);  % 当前簇的中心点

        intraClusterDistances = mixdistance_1(centroid,clusterData);
        meanIntraDist = mean(intraClusterDistances);  % 簇内平均距离
        
        RI = [];
        CentroidDist = mixdistance_1(centroid,centroids);

        for j = 1:numClusters
            if j ~= i
                otherClusterData = mixclusterdata(clusterIndices == j, :);  % 获取属于其他簇的样本数据
                otherCentroid = centroids(j, :);  % 其他簇的中心点

                interClusterDist = mixdistance_1(otherCentroid,otherClusterData);
                meanInterDist = mean(interClusterDist);  % 簇间平均距离

                %CentroidDist = mixdistance_1(centroid,otherCentroid); % 计算聚类中心之间的距离

                RI = [RI, (meanInterDist+meanIntraDist)/CentroidDist(j)];
            end
        end
        
        dbi = dbi + max(RI);
    end
    
    dbi = dbi / numClusters;
end
