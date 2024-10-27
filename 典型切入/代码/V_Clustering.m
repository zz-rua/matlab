clc;clear
load('obx_velocity.mat') %加载切入车纵向速度序列 924
obx_velocity(924, :) = [];

data=cell2mat(obx_velocity);
mean_v = mean(data); sigma_v = std(data);
min_v = min(data); max_min = max(data) - min(data);
%% 相似度矩阵计算
similarityMatrix = zeros(size(obx_velocity, 1));
for i = 1:length(obx_velocity)
    for j = i+1:length(obx_velocity)
        velocity1 = cell2mat(obx_velocity(i, :));
        velocity2 = cell2mat(obx_velocity(j,:));
    % 1.DTW距离
        % DTWDistance = dtw_distance(velocity1,velocity2);
        DTWDistance = dtw_distance((velocity1-mean_v)/sigma_v,(velocity2-mean_v)/sigma_v);
        similarityMatrix(i, j) = DTWDistance;
        similarityMatrix(j, i) = DTWDistance;
    % 2.欧式距离
%         EDistance = euclideandist(velocity1,velocity2);
%         similarityMatrix(i, j) = EDistance;
%         similarityMatrix(j, i) = EDistance;
    end
    i
end

%% 1.K-means聚类
max_length = max(cellfun(@numel, obx_velocity)); %步骤1：计算最长时间序列的长度
aligned_series = zeros(length(obx_velocity), max_length); % 步骤2：将不等长时间序列插值为相同长度
for i = 1 : length(obx_velocity)
    current_series = obx_velocity{i};
    current_series(end+1:max_length) = current_series(end);
    %aligned_series(i, :) = interp1(1:numel(current_series), current_series, linspace(1, numel(current_series), max_length));
    aligned_series(i, :) = current_series;
end

%similarityMatrix = aligned_series-aligned_series(:,1);
% 归一化
column_vector = aligned_series(:); %将矩阵转换为列向量
% normalized_column_vector = normalize(column_vector, 'range'); % 1.normalize
normalized_column_vector = zscore(column_vector); % 2.zscore
normalized_matrix = reshape(normalized_column_vector, size(aligned_series));% 将归一化后的列向量转换为原始矩阵
similarityMatrix = normalized_matrix;

%% 设置聚类数的范围
maxK = 15;
sse = zeros(1, maxK);% 存储每个聚类数对应的误差平方和
silhouette_values = zeros(1, maxK);
for k = 1:maxK
    [idx, ~, sumd] = kmeans(similarityMatrix, k,"Distance","cosine");    
    sse(k) = sum(sumd); % 计算每个样本与其所属聚类中心的距离平方和
    silhouette_values(k) = mean(silhouette(similarityMatrix, idx,"cosine"));% 轮廓系数法确定聚类数
end

% 绘制误差平方和与聚类数的关系图
subplot(1,2,1);
plot(1:maxK, sse, 'bo-','LineWidth',1.5);
xlabel('聚类数');
ylabel('误差平方和');
title('手肘法确定聚类数');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；

% 绘制轮廓系数与聚类数的曲线
subplot(1,2,2);
plot(1:maxK, silhouette_values, 'rx-','LineWidth',1.5);
xlabel('聚类数');
ylabel('轮廓系数');
title('轮廓系数法确定聚类数');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 800 300]);

% 通过观察图形选择最佳聚类数 手动确定最佳聚类数
bestK = input('请输入最佳聚类数：');
k = bestK; % 指定聚类数
[idx, centers] = kmeans(similarityMatrix, k,"Distance","cosine" );
for i=1:k
    clusterData = aligned_series(idx == i, :);
    v0 = mean(clusterData(:,1));
    centers(i,:) = centers(i,:)+v0;
end
% % centers = centers * std(column_vector) + mean(column_vector);
% centers = centers * (range(column_vector)) + min(column_vector);

%% 绘制聚类结果
% centers = centers * std(column_vector) + mean(column_vector);
centers = round(centers, 4);
figure;
hold on;
colors = lines(k); % 颜色列表
for i=1:k
    subplot(3,3,i)
    centersi = unique(centers(i,:),'stable');
    % centersi = cell2mat(centroids(i,:));
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    legend(['Cluster',num2str(i)],'AutoUpdate', 'off')
    hold on
    clusterData = obx_velocity(idx == i, :);
    % clusterData = timeSeriesData(clusterIndices == i, :);
    for j =1: length(clusterData)
        obv_clust = cell2mat(clusterData(j));
        plot((0:length(obv_clust)-1)/25,obv_clust(:),"Color",[0.75 0.75 0.75],LineWidth=1.5);
    end
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    ylim([0,55]);xlim([0,25]);
    xlabel('Time');
    ylabel('Velocity');
    set(gca,'Fontsize',12,'Linewidth',0.8);

    subplot(3,3,7)
    hold on
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    leg_str{i} = ['Cluster',num2str(i)]; 
    legend(leg_str,'AutoUpdate', 'off')
    xlabel('Time');
    ylabel('Velocity');

    subplot(3,3,8)
    hold on
    plot((0:length(centersi)-1)/25,centersi,"Color",colors(i,:),"LineWidth",2);
    leg_str{i} = ['Cluster',num2str(i)]; 
    legend(leg_str,'AutoUpdate', 'off')
    xlabel('Time');
    ylabel('Velocity');
    ylim([20,40]);xlim([0,25]);

end
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [400 200 800 400]);
grid on
grid minor

sc = mean(silhouette(similarityMatrix, idx,"cosine"));

% Calinski-Harabasz指数评估
ch_index = evalclusters(similarityMatrix, idx, 'CalinskiHarabasz');
ch_value = ch_index.CriterionValues;

% Davies Bouldin Index
db_index = evalclusters(similarityMatrix, idx, 'DaviesBouldin');
db_value = db_index.CriterionValues;

fprintf('SC: %.2f\n', sc);
fprintf('CHI: %.f\n', ch_value);
fprintf('DBI: %.2f\n', db_value);

%% 2.层次聚类（Hierarchical Clustering）
% 'average'：未加权平均距离；    'weighted':加权平均距离; 
% 'centroid'：质心距离，仅适用于欧式距离;    'median':加权质心距离，仅适用于欧氏距离;  
% 'single':最短距离（缺省）;    'complete'：最远距离；    'Ward'：离差平方和，仅适用于欧式距离
clc
tree = linkage(similarityMatrix, 'ward');
% 创建树状图
cutoff = median([tree(end-4,3) tree(end-3,3)]); %聚三类查看
figure; leafNodes = 5;
[H,T,outperm] = dendrogram(tree,leafNodes,'ColorThreshold',cutoff);     set(H,'LineWidth',2) 
% H = dendrogram(tree,0) %绘制整个树（500 个叶节点）的树状图 
% [H,T] = dendrogram(tree,30,'ColorThreshold','default'); %绘制25个叶节点的树状图,使用默认颜色阈值以垂直方向绘制树状图
xlabel('样本索引');    ylabel('距离');    title('层次聚类树状图');
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高
s=[];
for i = 1:leafNodes
    s{i,1} = find(T==i);%列出树状图的叶节点中的原始数据点。
end
subplot(2,3,6)
numClusters = leafNodes;
colors = lines(numClusters); % 使用不同颜色表示不同聚类
for i = 1:numClusters
    X = obx_velocity(s{i,1},:); % 获取聚类i的样本索引
    color = colors(i, :);
%     subplot(2,3,i)
    for j = 1:length(X)
        obv_clust = cell2mat(X(j));
        plot((0:length(obv_clust)-1)/25,obv_clust(:),"Color",color);
        hold on
    end   
    xlabel('时间/s')
    ylabel('切入车纵向速度/m*s^-^1')
    %title(['DTW+ward:第',num2str(i),'类'])
    set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
    %set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高；
    %hold off
end
% title('DTW + average ： 10类')
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 800 400]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高；
% 轮廓系数评估
silhouette_vals = silhouette(similarityMatrix, T);
avgSilhouette = mean(silhouette_vals); %计算平均轮廓系数
% Calinski-Harabasz指数评估
ch_index = evalclusters(similarityMatrix, T, 'CalinskiHarabasz');
ch_value = ch_index.CriterionValues;

% 显示评估结果
fprintf('SC: %.2f\n', avgSilhouette);
fprintf('CHI: %.4f\n', ch_value);
