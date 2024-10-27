clc;clear
load('obx_velocity.mat') %加载切入车纵向速度序列 924

timeSeriesData = obx_velocity;

% 定义聚类数和最大迭代次数
numClusters = 5;
maxIterations = 500;
tolerance = 1;  % 聚类中心变化阈值

% 随机初始化聚类中心
numTimeSeries = size(timeSeriesData, 1);
centroids = timeSeriesData(randperm(numTimeSeries, numClusters), :);

% 迭代更新聚类中心
for iter = 1:maxIterations
    % 计算每个时间序列与聚类中心的距离
    distances = zeros(numTimeSeries, numClusters);
    for i = 1:numTimeSeries
        for j = 1:numClusters
            distances(i,j) = dtw_distance(timeSeriesData{i},centroids{j});
        end
    end
    
    % 分配样本到最近的聚类中心
    [~, clusterIndices] = min(distances, [], 2);
    
    % 更新聚类中心
    NEWcentroids = cell(numClusters, 1);
    for i = 1:numClusters
        clusterData = timeSeriesData(clusterIndices == i);
        if ~isempty(clusterData)
            NEWcentroids{i} = meancentroids(clusterData);
        end
    end
    % 检查聚类中心的变化
    if max_distance(NEWcentroids , centroids) < tolerance
        break;  % 聚类中心不再变化，提前终止迭代
    end

    centroids = NEWcentroids;
end

%% 评估聚类结果
% 计算轮廓系数
silhouetteCoeff = calculateSilhouette(timeSeriesData, clusterIndices);

% 计算Calinski-Harabasz指数
chiIndex = calculateCHI(timeSeriesData, centroids, clusterIndices);

ch_index = evalclusters(timeSeriesData, clusterIndices, 'CalinskiHarabasz');
ch_value = ch_index.CriterionValues;

% 计算Davies-Bouldin指数
dbIndex = calculateDBI(timeSeriesData, centroids, clusterIndices);

db_index = evalclusters(timeSeriesData, clusterIndices, 'DaviesBouldin');
db_value = db_index.CriterionValues;


fprintf('SC: %.2f\n', silhouetteCoeff);
fprintf('CHI: %.f\n', chiIndex);
fprintf('DBI: %.2f\n', dbIndex);

%% 绘制聚类结果
% centroids = centroids * std(column_vector) + mean(column_vector);
centroids = round(centroids, 4);
figure;
hold on;
colors = lines(numClusters); % 颜色列表
for i=1:numClusters
    subplot(2,3,i)
    centersi = unique(centroids(i,:),'stable');
    % centersi = cell2mat(centroids(i,:));
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    legend(['Cluster',num2str(i)],'AutoUpdate', 'off')
    hold on
    clusterData = obx_velocity(clusterIndices == i, :);
    % clusterData = timeSeriesData(clusterIndices == i, :);
    for j =1: length(clusterData)
        obv_clust = cell2mat(clusterData(j));
        % plot((0:length(obv_clust)-1)/25,obv_clust(:),"Color",colors(i,:));
        plot((0:length(obv_clust)-1)/25,obv_clust(:),"Color",[0.75 0.75 0.75],LineWidth=1.5);
    end
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    ylim([0,55]);xlim([0,25]);
    xlabel('Time');
    ylabel('Velocity');
    set(gca,'Fontsize',12,'Linewidth',0.8);

    subplot(2,3,6)
    hold on
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    leg_str{i} = ['Cluster',num2str(i)]; 
    legend(leg_str,'AutoUpdate', 'off')
    xlabel('Time');
    ylabel('Velocity');

end
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [400 200 800 400]);