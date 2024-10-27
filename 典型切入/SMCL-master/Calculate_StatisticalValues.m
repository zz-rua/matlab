function Calculate_StatisticalValues(data, m)
% 统计聚类结果，得到典型场景各类数据
% 聚类中心：m
% 聚类标签：pred

% 将第十行插入到第五行后面
mm = [m(1:5,:); m(10,:); m(6:9,:); m(11,:)];

numClusters = size(mm,1);
d = pdist2(mm, data);
[~,min_idx] = min(d);
pred = min_idx';

data = readmatrix("SMCL-master\dataset\output_file.xlsx","Sheet","Sheet2");

% 1.统计各簇数场景总数及占比;
clusterStaistical = zeros(numClusters,2);
for i = 1:numClusters
    clusterData = data(pred == i, :); % 提取属于当前簇的数据
    clusterStaistical(i, 1) = size(clusterData, 1); % 每一类的总数
    clusterStaistical(i, 2) = size(clusterData, 1) /size(pred, 1); % 计算每一类的占比
    % 计算每一类最小ttc均值，风险度、风险率均值
    % clusterStaistical(i, 3) = mean(min_ttc(clusterIndices == i, :)); % 最小ttc均值
end

% 2.计算聚类中心
% 提取数值型和类别型变量
numeric_data = data(:, 1:6);
categorical_data = data(:, 7:end);

% 初始化变量以保存聚类中心
centroids = zeros(numClusters, size(data, 2));

% 计算数值型变量的均值
for cluster = 1:numClusters
    centroids(cluster, 1:6) = mean(numeric_data(pred == cluster, :));
    % centroids(cluster, :) = mean(data(pred == cluster, :));
end

% 计算类别型变量的众数
for cluster = 1:numClusters
    for col = 1:size(categorical_data, 2)
        centroids(cluster, col + 6) = mode(categorical_data(pred == cluster, col));
    end
end
% s = mean(silhouette (data, pred)); 

% 3.计算切入模式每个类别中的各标签占比
for i = 1:numClusters
    velocity = categorical_data(pred == i,1);
    for k = 1:4
        proportion(k,2*i-1) = sum(velocity == k);
        proportion(k,2*i) = sum(velocity == k)/size(velocity,1);
    end
end

% 获取每个分类变量的类别数
numCategories = zeros(1, size(categorical_data,2));
for i = 1:size(categorical_data,2)
    uniqueValues = unique(categorical_data(:,i));
    numCategories(i) = numel(uniqueValues);
end

% 4.计算每一类的聚类中心加速度
load("obx_Acx.mat");
Acc_mode = [1,4,6,7,10]; % 加速
Acc_mode = [3,11]; % 匀速
Acc_mode = [2,8,9]; % 减速
Acc_mode = 5; % 先减速后加速
Acc_mode = [1,4,6,7,10,3,11,2,8,9,5];
%for i = 1:numClusters
%%
for num = 1:size(Acc_mode,2)
    subplot(3,4,num)
    i = Acc_mode(num);
    clusterData = data(pred == i, :); % 提取属于当前簇的数据
    % 思路一：找到与聚类中心相距最近的片段，求其平均加速度
    distances = pdist2(centroids(i,:), clusterData);
    [~, sortedIndices] = sort(distances);
    for j = 1:3
        index = sortedIndices(j); % 选择第二小的距离对应的索引
        Acc_all = obx_Acx(pred == i, :);
        Acc = Acc_all{index};
        Acc_mean(num,j) = mean(Acc); % 平均值

        % 计算先减速后加速片段的两段加减速度
        positive_index = find(Acc > 0, 1); % 找到从负到正的转折点
        avg_before_positive = mean(Acc(1:positive_index-1)); % 计算第一个平均值
        negative_index = find(Acc(positive_index:end) < 0, 1) + positive_index - 1; % 找到从正到负的转折点
        avg_between_positive_negative = mean(Acc(positive_index:negative_index-1)); % 计算第二个平均值

        plot((1:size(Acc))/25, Acc, LineWidth=1.5);
        ylim([-2, 1]); xlim([0, 10])
        hold on
    end
    % ylim([-2,1])
    legend('d1','d2', 'd3','d4', 'd5', 'Location', 'best','EdgeColor',[0.65,0.65,0.65]);
    title(['C' num2str(i)]); 
    set(gca,'Fontsize',12,'Linewidth',0.8);
end
% set(gcf, 'position', [1200 200 400 300]);

%% 初始化用于存储原始标签的数组
for i = 1:numClusters
    startIndex = 1;
    clusterData = categorical_data(pred == i,:); % 提取属于当前簇的数据
    % proportion = zeros(sum(numCategories),2);
    for j = 1:numel(numCategories)
        endIndex = startIndex - 1 + numCategories(j);
        % 第i个聚类簇中各变量占比
        for num = startIndex:endIndex
            proportion(num,2*i-1) = sum(clusterData(:,j)==num-startIndex+1);
            proportion(num,2*i) = sum(clusterData(:,j)==num-startIndex+1)/size(categorical_data,1);
        end
        startIndex = endIndex + 1;
    end
end

%% k-prototype算法
pred = readmatrix("D:\桌面\典型切入场景聚类\代码\clusteringProject\label.xlsx","Sheet","Sheet1");
label = {'THW_t_c(s)', 'THW_t_f(s)', 'RV_t_c(m/s)', 'RV_t_f(m/s)', 'T(s)', 'V_t_0(m/s)', 'VM_c', 'IL', 'W', 'Type_c'};
%%
first = 3;
second = 6;
third = 8;
colors = [0.00,0.45,0.74;
          0.85,0.33,0.10;
          0.93,0.69,0.13;
          0.49,0.18,0.56;
          0.30,0.75,0.93;
          1.00,0.55,0.00;
          0.07,0.75,0.73;
          0.64,0.08,0.18;
          0.47,0.67,0.19;
          0.24,0.15,0.66;
          1.00,0.67,0.00]; % 颜色列表
figure
for k = 1:11
    scatter3(data(pred == k, first), data(pred == k, second), data(pred == k, third),50,colors(k,:),'.');
    hold on;
    scatter3(centroids(k, first), centroids(k, second), centroids(k, third), 200, '^', 'filled','MarkerEdgeColor',colors(k,:),'MarkerFaceColor',colors(k,:));
end
xlabel(label(first))
ylabel(label(second))
zlabel(label(third))
legend('','C1', '','C2', '','C3', '','C4', '','C5', '','C6', '','C7', '','C8', '','C9', '','C10', '','C11', 'Location', 'best','EdgeColor',[0.65,0.65,0.65]);
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [1200 200 400 300]);

%%
a = [2	3	4	5	6	7	8	9	10	11
0.16	0.18	0.22	0.23	0.28	0.29	0.32	0.27	0.35	0.38
0.30 	0.22 	0.27 	0.29 	0.30 	0.34 	0.39 	0.50 	0.57 	0.64 ];
plot(a(1,:),a(2,:), 'o-', LineWidth=1.5);
hold on
plot(a(1,:),a(3,:), '*-', LineWidth=1.5);
legend('K-prototypes','TSMCL', 'Location', 'best','EdgeColor',[0.65,0.65,0.65])
xlabel('Label'); ylabel('Silhouette Coefficient')
axis tight
set(gca, 'XTick', 2:11);
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [1200 200 400 300]);
%% 评估指标对比
% 读取数据
data = readtable("D:\桌面\评估指标.xlsx", 'Sheet', 'Sheet1');
tsmcl_data = data(strcmp(data.ALGO, 'TSMCL'), :);
kprototype_data = data(strcmp(data.ALGO, 'K-prototype'), :);

figure;
hold on;
% 左轴（SC和DBI）
yyaxis left;
plot(tsmcl_data.CLUST, tsmcl_data.SC, 'o-', 'DisplayName', 'SC TSMCL', 'LineWidth', 1.5);
plot(kprototype_data.CLUST, kprototype_data.SC, 's--', 'DisplayName', 'SC K-prototypes', 'LineWidth', 1.5);
ylabel('Silhouette Coefficient');
ylim([0, 0.65]); % 设置左轴Y范围
legend('show');

% 右轴（CHI）
yyaxis right;
plot(tsmcl_data.CLUST, tsmcl_data.DBI, 'o-', 'DisplayName', 'DBI TSMCL', 'LineWidth', 1.5);
plot(kprototype_data.CLUST, kprototype_data.DBI, 's--', 'DisplayName', 'DBI K-prototypes', 'LineWidth', 1.5);
ylabel('Davies-Bouldin index');
ylim([0.9, 3]); % 设置左轴Y范围

% plot(tsmcl_data.CLUST, tsmcl_data.CHI, 's-', 'DisplayName', 'CHI TSMCL', 'LineWidth', 1.5);
% plot(kprototype_data.CLUST, kprototype_data.CHI, 's--', 'DisplayName', 'CHI K-prototype', 'LineWidth', 1.5);
% ylabel('Calinski-Harabasz index');

xlabel('Cluster');
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [1200 200 400 300]);
hold off;
