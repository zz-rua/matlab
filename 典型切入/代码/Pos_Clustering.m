clc;clear
load('ob_trajectories.mat') %加载切入车轨迹
ob_trajectories = ob_trajectories(1:500,:);
similarityMatrix = zeros(size(ob_trajectories, 1));
for i = 1:length(ob_trajectories)
    for j = i+1:length(ob_trajectories)
        trajectory1 = cell2mat(ob_trajectories(i, :));
        trajectory2 = cell2mat(ob_trajectories(j,:));
    % 1.弗雷歇距离FrechetDistance
        %         FrechetDistance = frechetdist(trajectory1,trajectory2);
        %         similarityMatrix(i, j) = FrechetDistance;
        %         similarityMatrix(j, i) = FrechetDistance;
    % 2.DTW距离
        DTWDistance = dtw_distance(trajectory1,trajectory2);
        similarityMatrix(i, j) = DTWDistance;
        similarityMatrix(j, i) = DTWDistance;
    end
end

%% 聚类
%% 1.谱聚类
% a) 构建相似度图和拉普拉斯矩阵
affinityMatrix = similarityMatrix;  % 在这个简化示例中，相似度矩阵即为相似度图
D = diag(sum(affinityMatrix, 2));  % 度矩阵
L = D - affinityMatrix;  % 拉普拉斯矩阵
% b)特征值分解，得到特征向量矩阵和特征值矩阵
[eigVectors, eigValues] = eig(L);
eigenvalues = diag(eigValues);% 提取特征值
% % 绘制特征值的变化曲线
% plot(1:length(eigenvalues), eigenvalues, 'bo-');
% xlabel('Index');
% ylabel('Eigenvalue');
% title('Eigenvalue Spectrum');
% c) 根据特征值之间的变化选择 k 值
eigenvalueDiff = diff(eigenvalues);  % 计算特征值之间的差异
eigenvalueRatio = eigenvalueDiff(2:end) ./ eigenvalueDiff(1:end-1);  % 计算特征值之间的比值
figure;% 绘制特征值比值的变化曲线
x = 2:length(eigenvalueRatio)+1;  % x 坐标从2开始
plot(x, eigenvalueRatio, 'bo-');
xlabel('Index');
ylabel('Eigenvalue Ratio');
title('Eigenvalue Ratio');
% 根据特征值比值的变化选择 k 值,找到特征值比值大幅度变化的位置
threshold = 2;  % 阈值，根据实际情况进行调整
kIndex = find(eigenvalueRatio > threshold, 1, 'first');
k = kIndex + 1;  % 加1是因为索引从2开始
disp(['Selected k value: ' num2str(k)]);
eigenvectors = eigVectors(:, 2:k);  % 选择前 k 个特征向量
% d) 调用聚类算法（如 k-means）进行聚类
numClusters = kIndex;  % 聚类数
[idx, centroids] = kmeans(eigenvectors, numClusters);
% 聚类结果
for i = 1:kIndex
    s{i,1} = find(idx==i);
end
%% 2.层次聚类（Hierarchical Clustering）
% 计算样本之间的距离矩阵 similarityMatrix
% 使用不同的链接策略构建层次聚类,linkage为用于计算聚类之间距离的算法：
% 'average'：未加权平均距离；    'weighted':加权平均距离; 
% 'centroid'：质心距离，仅适用于欧几里得距离;    'median':加权质心距离，仅适用于欧氏距离;  
% 'single':最短距离（缺省）;    'complete'：最远距离；    'Ward'：离差平方和，仅适用于欧几里得距离
clc
tree = linkage(similarityMatrix, 'average');
% C = cluster(tree, 'cutoff', 2.5,'depth',4);% C = cluster(tree,'Cutoff',2.5,'Criterion','distance')
% leafNodes = length(unique(C)) %聚类的类数
% 创建树状图
cutoff = median([tree(end-2,3) tree(end-1,3)]); %聚三类查看
figure
leafNodes = 3;
[H,T,outperm] = dendrogram(tree,leafNodes,'ColorThreshold',cutoff);
% H = dendrogram(tree,0) %绘制整个树（500 个叶节点）的树状图 
% [H,T] = dendrogram(tree,30,'ColorThreshold','default'); %绘制25个叶节点的树状图,使用默认颜色阈值以垂直方向绘制树状图
set(H,'LineWidth',2) %更改树状图线条宽度
xlabel('样本索引');    ylabel('距离');    title('层次聚类树状图');
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高
s=[];
for i = 1:leafNodes
    s{i,1} = find(T==i);%列出树状图的叶节点中的原始数据点。
end
%
numClusters = leafNodes;
colors = lines(numClusters); % 使用不同颜色表示不同聚类
for i = 1:numClusters
    X = ob_trajectories(s{i,1},:); % 获取聚类i的样本索引
    color = colors(i, :);
%     figure
    for j = 1:length(X)
        ob_traj_clust = cell2mat(X(j));
        plot(ob_traj_clust(:,1),ob_traj_clust(:,2),"Color",color);
        hold on
    end   
    xlabel('车辆纵向行驶距离/m')
    ylabel('车辆横向位置/m')
%     title(['DTW + ward ：第',num2str(i),'类结果'])
%     set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
%     set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高；
%     hold off
end
% title('DTW + average ： 10类')
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高；

% 轮廓系数评估
silhouette_vals = silhouette(similarityMatrix, T);
avgSilhouette = mean(silhouette_vals); %计算平均轮廓系数
% Calinski-Harabasz指数评估
ch_index = evalclusters(similarityMatrix, T, 'CalinskiHarabasz');
ch_value = ch_index.CriterionValues;

% 显示评估结果
fprintf('SC: %.2f\n', avgSilhouette);
fprintf('CHI: %.4f\n', ch_value);


%% 3.Affinity Propagation聚类
% 计算相似度矩阵
% 设置初始参考度P值（相似度矩阵的中值/最小值）和迭代次数M
% 计算吸引度值rij
% 计算归属度值aij
% 更新吸引度和归属度
% 输出类中心及各类的样本点








