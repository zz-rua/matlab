function d = dtw_distance(series1, series2)
pflag = 0;

if isa(series1,"cell")
    series1 = cell2mat(series1);
end
if isa(series2,"cell")
    series2 = cell2mat(series2);
end

series1_standard = zscore(series1);
series2_standard = zscore(series2);

% 调用DTW函数计算规整距离
[d,warpPath1,warpPath2] = dtw(series1_standard, series2_standard);
% [d,warpPath1,warpPath2] = dtw(series1, series2);

m = length(series1);    n = length(series2);
d = d/max(m,n);

% 显示原始时间序列和规整后的时间序列
if pflag == 1
    % 构造规整后的时间序列
    alignedTimeSeries1 = series1_standard(warpPath1);
    alignedTimeSeries2 = series2_standard(warpPath2);
    subplot(1,3,1);
    set(gca,'Fontsize',12,'Linewidth',0.8);
    hold on;
    plot((0:length(series1)-1)/25,series1,'-bx');
    plot((0:length(series2)-1)/25,series2,':r.');
    hold off;
    grid;
    legend('时间序列1','时间序列2');
    title('原始时间序列');
    xlabel('时间(s)');
    ylabel('速度(m/s)');

    subplot(1,3,2);
    set(gca,'Fontsize',12,'Linewidth',0.8);
    hold on;
    plot((0:length(series1_standard)-1)/25,series1_standard,'-bx');
    plot((0:length(series2_standard)-1)/25,series2_standard,':r.');
    hold off;
    grid;
    legend('归一化时间序列1','归一化时间序列2');
    title('归一化时间序列');
    xlabel('时间');
    ylabel('归一化速度幅度');

    subplot(1,3,3);
    set(gca,'Fontsize',12,'Linewidth',0.8);
    hold on;
    plot((0:length(alignedTimeSeries1)-1)/25,alignedTimeSeries1,'-bx');
    plot((0:length(alignedTimeSeries2)-1)/25,alignedTimeSeries2,':r.');
    hold off;
    grid;
    legend('规整时间序列1','规整时间序列2');
    title('规整时间序列');
    xlabel('时间');
    ylabel('规整速度幅度');

    set(gcf, 'position', [400 200 800 400]);
end

%
% % 创建一个空的距离矩阵
% dtw_matrix = zeros(m+1, n+1);
%
% % 初始化第一行和第一列
% dtw_matrix(2:end, 1) = inf;
% dtw_matrix(1, 2:end) = inf;
% dtw_matrix(1, 1) = 0;
%
% % 计算距离矩阵
% for i = 2:m+1
%     for j = 2:n+1
%         cost = sqrt(sum((series1(i-1,:) - series2(j-1,:)).^2)); % 曲线之间的距离度量：欧式距离
%         dtw_matrix(i, j) = cost + min([dtw_matrix(i-1, j), dtw_matrix(i, j-1), dtw_matrix(i-1, j-1)]);
%     end
% end
%
% % 返回两个时间序列的DTW距离
% dtw_distance = dtw_matrix(m+1, n+1);
% % dtw_distance = dtw_matrix(m+1, n+1)/max(m,n);  %标准化后的DTW距离，可以使不同长度的序列有可比性
end


