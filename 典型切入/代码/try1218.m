% load('TBL.mat')

%% 对连续变量做kmeans聚类
% 1.数据预处理
data_num = [TBL{:,2}, TBL{:,4}, TBL{:,6}, TBL{:,8}, TBL{:,10}, TBL{:,21}];
data_num(isinf(data_num)) = NaN;  % 将Inf值替换为NaN
mean_values = mean(data_num,'omitnan');  % 计算均值和标准差时忽略NaN值
std_values = std(data_num,'omitnan');
standardized_data = (data_num - mean_values) ./ std_values;  % 标准化数据（忽略NaN值）
variables = fillmissing(standardized_data,"constant",5);

% 2.kmeans聚类
k = 5;
[idx, centers] = kmeans(variables, k);
centers = centers .* std_values + mean_values;
% 设置聚类数的范围
maxK = 10;
sse = zeros(1, maxK-1);% 存储每个聚类数对应的误差平方和
silhouette_values = zeros(1, maxK-1);
DBIndex = zeros(1, maxK-1);
for k = 2:maxK
%     [idx, ~, sumd] = kmeans(variables, k);
%     sse(k-1) = sum(sumd); % 计算每个样本与其所属聚类中心的距离平方和
%     silhouette_values(k-1) = mean(silhouette(variables, idx));% 轮廓系数法确定聚类数

    [clusters, centroids] = kModes(data_cat, k, maxIterations);
    silhouette_values(k-1) = mean(silhouette(data_cat, clusters, 'Hamming'));
    daviesBouldinIndex = evalclusters(data_cat, clusters,"DaviesBouldin");
    DBIndex(k-1) = daviesBouldinIndex.CriterionValues;
end

% 绘制误差平方和与聚类数的关系图
yyaxis left;
plot(2:maxK, sse, 'bo-','LineWidth',1.5);
xlabel('聚类数');
ylabel('误差平方和');
grid on;
yyaxis right;
plot(2:maxK, silhouette_values, 'rx-','LineWidth',1.5);
ylabel('轮廓系数');
grid on;
yticks('auto');

% 调整图像布局
yyaxis left;
ax = gca;
ax.YColor = 'b';

yyaxis right;
ax.YColor = 'r';

set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 400 300]);

%% 对离散变量采用kmodes聚类
data_cat = [TBL{:,12}, TBL{:,14}, TBL{:,16}, TBL{:,18}, TBL{:,20}];
maxIterations = 10;
maxK = 64;
yyaxis left;
plot(2:maxK, silhouette_values,'LineWidth',1.5);
xlabel('聚类数');
ylabel('轮廓系数');
yyaxis right;
plot(2:maxK, DBIndex,'LineWidth',1.5);
ylabel('Davies-Bouldin Index');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 400 300]);

