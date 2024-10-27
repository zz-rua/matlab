tic
clc;clear
load('clusterdata_v1.mat')
load('obx_velocity.mat')

mixclusterdata(:,1) = obx_velocity;
mixclusterdata(:,2:4) = clusterdata_v1;

otherSeriesData = cell2mat(clusterdata_v1);
% normotherSeriesData = normalize(otherSeriesData,'range');
% mixclusterdata(:,2:end) = num2cell(normotherSeriesData);

% 定义聚类数和最大迭代次数
for numClusters = 8: 8 %5:10
    [centroids, clusterIndices] = cluster_kmedoids(mixclusterdata, numClusters);
%     % numClusters = 8;
%     maxIterations = 50;
%     tolerance = 0.01;  % 聚类中心变化阈值
% 
%     % 随机初始化聚类中心
%     numTimeSeries = size(mixclusterdata, 1);
%     centroids = mixclusterdata(randperm(numTimeSeries, numClusters), :);
% 
%     %% 迭代更新聚类中心
%     for iter = 1:maxIterations
%         % 计算每个时间序列与聚类中心的距离
%         distances = mixdistance_1(mixclusterdata, centroids);
% 
%         % 分配样本到最近的聚类中心
%         [~, clusterIndices] = min(distances, [], 2);
% 
%         % 更新聚类中心
%         NEWcentroids = cell(size(centroids));
%         for k = 1:numClusters
%             clusterData = mixclusterdata(clusterIndices == k,:);
%             if ~isempty(clusterData)
%                 % 找出与聚类中其他点的总距离之和最小的数据点的索引
%                 withdis = mixdistance_1(clusterData, clusterData);
%                 [~, minIdx] = min(sum(withdis,2));
%                 NEWcentroids(k,:) = clusterData(minIdx,:);
%             end
%         end
% 
%         % 检查聚类中心的变化
%         if max_distance(NEWcentroids , centroids) < tolerance
%             break;  % 聚类中心不再变化，提前终止迭代
%         end
% 
%         centroids = NEWcentroids;
%     end

    %% 评估聚类结果
    % 计算轮廓系数
    silhouetteCoeff = mixSilhouette(mixclusterdata, clusterIndices);

    %% 计算误差平方和SSE和Calinski-Harabasz指数
    [sse, chiIndex] = mixCHI(mixclusterdata, centroids, clusterIndices);

    %% 计算Davies-Bouldin指数
    dbIndex = mixDBI(mixclusterdata, centroids, clusterIndices);

    fprintf('SC: %.2f\n', silhouetteCoeff);
    fprintf('SSE: %.f\n', sse);
    fprintf('CHI: %.f\n', chiIndex);
    fprintf('DBI: %.2f\n', dbIndex);

    %% 绘制聚类结果
    figure;
    hold on;
    colors = lines(numClusters); % 颜色列表
    numSubplots = numClusters+1;  % 设置子图数量
    [numRows, numCols] = calculate_subplot_layout(numSubplots);  % 计算行数和列数

    % othercentroids = cell2mat(centroids(:,2:end)).*(max(otherSeriesData)-min(otherSeriesData))+min(otherSeriesData);
    velocitycentroids = centroids(:,1);
    othercentroids = cell2mat(centroids(:,2:end));

    for i=1:numClusters
        subplot(numRows, numCols,i)
        centersi = cell2mat(velocitycentroids(i,:));
        plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
        legend(['Cluster',num2str(i)],'AutoUpdate', 'off')
        hold on
        clusterData = mixclusterdata(clusterIndices == i, 1);
        for j =1: length(clusterData)
            obv_clust = cell2mat(clusterData(j));
            plot((0:length(obv_clust)-1)/25,obv_clust(:),"Color",[0.75 0.75 0.75],LineWidth=0.1);
        end
        plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
        ylim([0,55]);xlim([0,25]);
        xlabel('Time/s');
        ylabel('Velocity/m*s^-^1');
        set(gca,'Fontsize',12,'Linewidth',0.8);
        set(legend,'Fontsize',10)

        subplot(numRows, numCols,numClusters+1)
        hold on
        plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
        leg_str{i} = ['Cluster',num2str(i)];
        legend(leg_str,'AutoUpdate', 'off')
        ylim([0,55]);xlim([0,25]);
        xlabel('Time/s');
        ylabel('Velocity/m*s^-^1');

    end
    sgtitle('切入车纵向速度序列聚类结果');
    set(gca,'Fontsize',12,'Linewidth',0.8);
    set(legend,'Fontsize',10)
    grid minor
    set(gcf, 'position', [400 200 250*numCols 200*numRows]);

    %%
    figure
    for i=1:numClusters
        subplot(numRows, numCols,i)
        otherclusterData = otherSeriesData(clusterIndices == i, :);
        scatter3(otherclusterData(:, 2), otherclusterData(:, 1), otherclusterData(:, 3),20, colors(i,:));
        hold on
        scatter3(othercentroids(i,2), othercentroids(i,1), othercentroids(i,3), 100, 'k', 'filled', 'd');
        ylabel('D_x_0');
        xlabel('V_r_0');
        zlabel('T');
        legend(['Cluster',num2str(i)], 'Centroids', 'Location', 'best');
        ylim([min(otherSeriesData(:,1)), max(otherSeriesData(:,1))]);
        xlim([min(otherSeriesData(:,2)), max(otherSeriesData(:,2))]);
        zlim([min(otherSeriesData(:,3)), max(otherSeriesData(:,3))]);
        set(gca,'Fontsize',10,'Linewidth',0.8);
        set(legend,'Fontsize',10)

        subplot(numRows, numCols,numClusters+1)
        scatter3(othercentroids(i,2), othercentroids(i,1), othercentroids(i,3), 100, colors(i,:), 'filled', 'd');
        hold on
        leg_str{i} = ['Cluster',num2str(i)];
    end
    legend(leg_str,'Location', 'best')
    ylim([min(otherSeriesData(:,1)), max(otherSeriesData(:,1))]);
    xlim([min(otherSeriesData(:,2)), max(otherSeriesData(:,2))]);
    zlim([min(otherSeriesData(:,3)), max(otherSeriesData(:,3))]);
    ylabel('D_x_0');
    xlabel('V_r_0');
    zlabel('T');

    set(gca,'Fontsize',10,'Linewidth',0.8);
    set(legend,'Fontsize',10)
    set(gcf, 'position', [400 200 250*numCols 200*numRows]);

end

toc