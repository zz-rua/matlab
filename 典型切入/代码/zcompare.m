%距离1
d=d1+d2;
[~, clusterIndices] = min(d, [], 2);

%距离2
normalized_dtw_distances = (d1 - min(d1)) ./ (max(d1) - min(d1));
normalized_mahalanobis_distances = (d2 - min(d2)) ./ (max(d2) - min(d2));
d3=normalized_dtw_distances+normalized_mahalanobis_distances;
[~, min_index] = min(d3, [], 2);

%距离3
weight_dtw = 0.6;  % 调整权重
weight_mahalanobis = 0.4;

total_distances = weight_dtw * d1 + weight_mahalanobis * d3;
[~, tindex] = min(total_distances, [], 2);


different_positions = find(tindex ~= min_index);

diffdata = clusterData1(different_positions,1);
nclusterIndices = tindex(different_positions,1);

figure;
hold on;
numClusters = 5;
colors = lines(numClusters); % 颜色列表
numSubplots = numClusters+1;  % 设置子图数量
[numRows, numCols] = calculate_subplot_layout(numSubplots);  % 计算行数和列数

for i=1:numClusters
    subplot(numRows, numCols,i)
    centersi = cell2mat(clusterData2(i,1));
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    legend(['Cluster',num2str(i)],'AutoUpdate', 'off')
    hold on
    clusterData = diffdata(nclusterIndices == i);
    for j =1: length(clusterData)
        obv_clust = cell2mat(clusterData(j));
        plot((0:length(obv_clust)-1)/25,obv_clust(:),"Color",[0.75 0.75 0.75],LineWidth=0.5);
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
otherSeriesData = cell2mat(clusterData1(different_positions,2:end));
nclusterIndices = tindex(different_positions,1);
othercentroids = cell2mat(clusterData2(:,2:end));
figure
for i=1:numClusters
    subplot(numRows, numCols,i)
    otherclusterData = otherSeriesData(nclusterIndices == i, :);
    scatter3(otherclusterData(:, 2), otherclusterData(:, 1), otherclusterData(:, 3),20, colors(i,:));
    hold on
    scatter3(othercentroids(i,2), othercentroids(i,1), othercentroids(i,3), 200, 'k', 'filled', 'd');
    ylabel('初始车距');
    xlabel('初始相对车速');
    zlabel('切入时长');
    legend(['Cluster',num2str(i)], 'Centroids', 'Location', 'northeast');
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
legend(leg_str,'Location', 'northeast')
ylim([min(otherSeriesData(:,1)), max(otherSeriesData(:,1))]);
xlim([min(otherSeriesData(:,2)), max(otherSeriesData(:,2))]);
zlim([min(otherSeriesData(:,3)), max(otherSeriesData(:,3))]);
ylabel('初始车距');
xlabel('初始相对车速');
zlabel('切入时长');

set(gca,'Fontsize',10,'Linewidth',0.8);
set(legend,'Fontsize',10)
set(gcf, 'position', [400 200 250*numCols 200*numRows]);

