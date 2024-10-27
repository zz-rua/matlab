% 导入参数
% load('other_para.mat')
%% 设置聚类数的范围
maxK = 6;
sse = zeros(1, maxK);% 存储每个聚类数对应的误差平方和
for k = 1:maxK
    [~, ~, sumd] = kmeans(paramArray(:,end), k,"Distance","sqeuclidean");    
    sse(k) = sum(sumd); % 计算每个样本与其所属聚类中心的距离平方和
end
% 绘制误差平方和与聚类数的关系图
plot(1:maxK, sse, 'o-','LineWidth',1.5);
xlabel('聚类数');
ylabel('误差平方和');
title('手肘法确定聚类数');
legend('V_e_0');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [400 200 400 300]);

%% 聚类
num = size(paramArray,1);
%idk = [3; 4; 3; 4; 3; 3]; % 指定各参数聚类数
idk = [2; 3; 2; 3; 2; 2]; % 指定各参数聚类数
idx = zeros(num,6);
new_idx = zeros(num,6);
for idthw = 1:6
    paramMatrix = paramArray(:,idthw);
    k = idk(idthw);  % 指定聚类数
    [idx(:,idthw), centers] = kmeans(paramMatrix, k);

    % 根据中心坐标的第一列进行排序
    [sorted_centers, sorted_order] = sort(centers(:, 1));

    % 根据排序后的聚类中心重新分配簇标签
    for i = 1:k
        new_idx(idx(:,idthw) == sorted_order(i),idthw) = i;
    end
end
%% 绘制箱线图和均值曲线
% 1.THW箱线图
figure;
type(1:num,1) = {'SO\_THW'}; type(num+1:num*2,1) = {'SFO\_THW'};
b = boxchart([new_idx(:,1);new_idx(:,2)], [paramArray(:,1);paramArray(:,2)],'GroupByColor',type);
legend;     xticks(1:idk(2));
xlabel('聚类标签');     ylabel('THW/s');
title('THW聚类结果的箱线图');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [400 200 400 300]);
% 绘制矩形框
x = 3.8;    y = -1;  width = 0.2;    height = 4;
rectangle('Position', [x, y, width, height], 'EdgeColor', [0, 0.4470, 0.7410], 'LineWidth', 1);
% 添加文字标签
text(x + width/2, y + height/2, {'无','前','车'}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 8);

% 2.相对速度箱线图
figure;
type(1:num,1) = {'SO\_ReVcx'}; type(num+1:num*2,1) = {'SFO\_ReVcx'};
b = boxchart([new_idx(:,3);new_idx(:,4)], [paramArray(:,3);paramArray(:,4)],'GroupByColor',type);
legend;     xticks(1:idk(4));
xlabel('聚类标签');     ylabel('ReVcx/m·s^-^1');
title('相对速度聚类结果的箱线图');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [400 200 400 300]);
% 绘制矩形框
x = 3.8;    y = -10;  width = 0.2;    height = 10;
rectangle('Position', [x, y, width, height], 'EdgeColor', [0, 0.4470, 0.7410], 'LineWidth', 1);
% 添加文字标签
text(x + width/2, y + height/2, {'无','前','车'}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'black', 'FontSize', 8);

% 3.切入时长箱线图和均值曲线
% 计算每个聚类的均值
cluster_means = zeros(1, idk(5));
for i = 1:idk(5)
    cluster_data = paramArray(new_idx(:,5) == i,5);
    cluster_means(i) = mean(cluster_data);
end
b = boxchart(new_idx(:,5), paramArray(:,5));
hold on;
plot(1:idk(5), cluster_means, '-o', 'LineWidth', 1);
legend('Duration','Mean',Location='best');  xticks(1:idk(5));
xlabel('聚类标签'); ylabel('Duration/s');
title('切入时长聚类结果的箱线图');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [400 200 400 300]);

% 4.初始时刻主车速度箱线图和均值曲线
cluster_means = zeros(1, idk(6));
for i = 1:idk(6)
    cluster_data = paramArray(new_idx(:,6) == i,6);
    cluster_means(i) = mean(cluster_data);
end
b = boxchart(new_idx(:,6), paramArray(:,6));
hold on;
plot(1:idk(6), cluster_means, '-o', 'LineWidth', 1);
legend('Ve0','Mean',Location='best');  xticks(1:idk(6));
xlabel('聚类标签'); ylabel('Velocity/m·s^-^1');
title('初始时刻自车速度聚类结果的箱线图');
grid on;
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [400 200 400 300]);

%% 创建聚类结果总表table
num_segment = size(paramArray,1);
s(1:num_segment) = 1:size(paramArray,1);
SO_THW(1:num_segment) = paramArray(:,1);
SO_Label(1:num_segment) = new_idx(:,1);
SFO_THW(1:num_segment) = paramArray(:,2);
SFO_Label(1:num_segment) = new_idx(:,2);
TBL = table(s', SO_THW', SO_Label', SFO_THW', SFO_Label', 'VariableNames', {'Segment', 'SO_THW', 'SO_Label', 'SFO_THW', 'SFO_Label'});

TBL.SO_THW = paramArray(:,1);
TBL.SO_Label = new_idx(:,1);
TBL.SFO_THW =  paramArray(:,2);
TBL.SFO_Label = new_idx(:,2);

TBL.SO_ReVcx = paramArray(:,3);
TBL.SO_ReLabel = new_idx(:,3);
TBL.SFO_ReVcx = paramArray(:,4);
TBL.SFO_ReLabel = new_idx(:,4);

TBL.Duration = paramArray(:,5);
TBL.Dura_Label = new_idx(:,5);

TBL.V_Label = clusterIndices; %切入车速度序列标签
TBL.Ve0 = paramArray(:,6);
TBL.Ve0_Label = new_idx(:,6); %自车速度
% writetable(TBL, 'output_file.xlsx');

%% 计算统计量值
% 提取类别和数值列
categories = TBL.Ve0_Label;
values = TBL.Ve0;

% 获取唯一的类别
unique_categories = unique(categories);

% 针对每个类别计算统计量
for i = 1:length(unique_categories)
    category = unique_categories(i);
    subset_values = values(categories == category);
    rate = size(subset_values,1)/size(values,1)*100;
    max_value = max(subset_values);
    min_value = min(subset_values);
    mean_value = mean(subset_values);
    quartiles = quantile(subset_values, [0.25, 0.75]);% 计算四分位数
    std_deviation = std(subset_values);% 计算标准差
    
    fprintf('%.0f%%    [%.2f,%.2f]    [%.2f,%.2f]     %.2f    %.2f\n', rate,min_value,max_value,quartiles(1),quartiles(2),mean_value,std_deviation);
end