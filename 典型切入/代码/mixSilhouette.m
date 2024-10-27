function silhouetteCoeff =mixSilhouette(mixclusterdata, clusterIndices)
    numSamples = size(mixclusterdata, 1);
    silhouetteCoeff = zeros(numSamples, 1);
    
    for i = 1:numSamples
        sample = mixclusterdata(i, :);
        cluster = clusterIndices(i);
        
        % Calculate a: average distance to samples in the same cluster
        [a,~] = calculateAverageDistance(sample, mixclusterdata(clusterIndices == cluster, :));
 
        % Calculate b: average distance to samples in different clusters
        b = inf;
        for j = 1:max(clusterIndices)
            if j ~= cluster
                [~,bi] = calculateAverageDistance(sample, mixclusterdata(clusterIndices == j, :));
                b = min(b, bi);
            end
        end
        
        % Calculate silhouette coefficient
        silhouetteCoeff(i) = (b - a) / max(a, b);
    end
    
    % Calculate average silhouette coefficient
    silhouetteCoeff = mean(silhouetteCoeff);
end

function [avgDistance1,avgDistance2] = calculateAverageDistance(sample, samples)
    numSamples = size(samples, 1);    
    distances = mixdistance_1(sample, samples)';

    avgDistance1 = sum(distances)/(numSamples-1);
    avgDistance2 = mean(distances);
end

% % 绘制轮廓图
% figure
% bar(avgClusterSilhouette)
% xlabel('聚类簇数')
% ylabel('轮廓系数')
% title('轮廓图')
% set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
% 
% % 如果需要显示不同簇的平均轮廓系数，可以加入下面的代码
% hold on
% for i = 1:max(clusterIndices)
%     clusterSilhouette = silhouetteCoeff(clusterIndices == i, :);
%     avgClusterSilhouette(i) = mean(clusterSilhouette);
%     % text(i, avgClusterSilhouette, sprintf('%.2f', avgClusterSilhouette), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
% end
% hold off
% 
% % 设置X轴标签为簇的编号
% xticks(1:max(clusterIndices))
% xticklabels(1:max(clusterIndices))