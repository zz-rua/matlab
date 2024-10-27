function DIScentroid = max_distance(NEWcentroids , centroids)
% 计算新旧聚类中心的最大距离
s = 0;
for i = 1:size(NEWcentroids,1)
    %     if size(NEWcentroids, 2) > 1
    %         % 计算欧几里德距离
    %         s1 = cell2mat(NEWcentroids(i,2:end));
    %         s2 = cell2mat(centroids(i,2:end));
    %         % s(i) = pdist([s1; s2],"euclidean");
    %
    %         s(i) = pdist([s1; s2],"mahalanobis"); %曼哈顿距离
    %     end
    % 计算dtw距离
    d(i) = dtw_distance(NEWcentroids(i,1), centroids(i,1));
end

if size(NEWcentroids, 2) > 1
    s = pdist2(cell2mat(NEWcentroids(:,2:end)),cell2mat(centroids(:,2:end)),"mahalanobis");
    s = diag(s)';
end

DIScentroid = max(s+d);

end