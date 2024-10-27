clc;clear
load('obx_velocity.mat') %加载切入车纵向速度序列 924
%% 聚类
timeSeriesData = obx_velocity(2:end,:);

% 定义聚类数和最大迭代次数
% numClusters = 4; %
for numClusters = 2:3
    rng(4)
    [centroids, clusterIndices] = cluster_kmedoids(timeSeriesData, numClusters);

    %% 评估聚类结果
    silhouetteCoeff(numClusters-1) = calculateSilhouette(timeSeriesData, clusterIndices);
    fprintf('SC: %.2f\n', silhouetteCoeff);
end
plot([2:6],silhouetteCoeff, 'o-','LineWidth',1.5)
xlabel('Cluster label');
ylabel('Silhouette Coefficient');

%% 绘制聚类结果
figure;
colors = lines(numClusters); % 颜色列表
for i=1:numClusters
    subplot(2,2,i)
    centersi = cell2mat(centroids(i,:));
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    legend(['Cluster',num2str(i)],'AutoUpdate', 'off')
    hold on
    clusterData = timeSeriesData(clusterIndices == i, :);
    for j =1: length(clusterData)
        obv_clust = cell2mat(clusterData(j));
        % plot((0:length(obv_clust)-1)/25,obv_clust(:),"Color",colors(i,:));
        plot((0:length(obv_clust)-1)/25,obv_clust(:),"Color",[0.75 0.75 0.75],LineWidth=0.5);
    end
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);hold on
%     leg_str{i} = ['Cluster',num2str(i)];
%     legend(leg_str,'AutoUpdate', 'off')

    ylim([0,55]);xlim([0,25]);
    xlabel('Cut-in duration(s)');
    ylabel('CV-velocity(m/s)');
    set(gca,'Fontsize',12,'Linewidth',0.8);
end
set(gca,'Fontsize',12,'Linewidth',0.8);
set(legend,'Fontsize',12)
set(gcf, 'position', [400 200 600 400]);
% sgtitle('The CV velocity-time series clustering result')