function d = frechetdist(trajectory1, trajectory2)
%比较序列长短，以长序列为基准插值，保证两序列长度一致
if size(trajectory1,1)<size(trajectory2,1)
    x1 = trajectory1(:,1);  y1 = trajectory1(:,2);
    x2 = trajectory2(:,1);  y2 = trajectory2(:,2);
else
    x1 = trajectory2(:,1);  y1 = trajectory2(:,2);
    x2 = trajectory1(:,1);  y2 = trajectory1(:,2);
end
% 执行线性插值
x1_interp = linspace(min(x1), max(x1), numel(x2));
y1_interp = interp1(x1, y1, x1_interp, 'linear');
%         plot(x1, y1, 'ro-', x2, y2, 'bo-', x1_interp, y1_interp, 'g.-');
%         legend('曲线1', '曲线2', '插值曲线1');
%         xlabel('车辆纵向行驶距离/m')
%         ylabel('车辆横向位置/m')
%         title('数据插值对比')
%         set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
%         set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高；
data1=[x1_interp', y1_interp'];
data2=[x2,y2];

% 计算距离矩阵
dmat = pdist2(data1, data2, 'euclidean');

% 初始化距离矩阵
F = ones(size(dmat)) * -1;
n = size(dmat, 1);

% 计算Frechet距离
F(1,1) = dmat(1,1);

for i = 2:n
    F(i,1) = max(F(i-1,1), dmat(i,1));
end

for j = 2:n
    F(1,j) = max(F(1,j-1), dmat(1,j));
end

for i = 2:n
    for j = 2:n
        F(i,j) = max(min([F(i-1,j); F(i,j-1); F(i-1,j-1)]), dmat(i,j));
    end
end

% 最终Frechet距离
d = F(n,n);

% 显示结果
%fprintf('The Frechet distance between the two curves is %f.\n', d);
