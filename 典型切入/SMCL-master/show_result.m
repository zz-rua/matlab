function show_result( data, label, pred_all, cluster_num, measure_sep, measure_com, sep_com )
%SHOW_RESULT Show the numerical results and plot figures
%   data: input data
%   label: ground truth
%   pred_all: all prediction of intermediate clustering result
%   cluster_num: number of clusters
%   measure_sep: global separability
%   measure_com: global compactness
%   sep_com: global separability + global compactness

[~,ia] = unique(cluster_num);

figure;hold on;
plot(cluster_num(ia), sep_com, '-*', 'MarkerSize', 10, 'LineWidth',2);
plot(cluster_num(ia), measure_sep, '-x', 'MarkerSize', 10, 'LineWidth',2);
plot(cluster_num(ia), measure_com, '-+', 'MarkerSize', 10, 'LineWidth',2);
legend('sep+com', 'sep', 'com');
xlabel('k')
ylabel('Global measures')
set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高；
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
axis tight;grid on
% label = label_correction(label, label, 2);
% u_pred = unique(label);
% figure;hold on;
% for i=1:length(u_pred)
%     plot(data(label==u_pred(i),1),data(label==u_pred(i),2), '.', 'MarkerSize', 10);
% end
% xlabel('Ground truth')

sep_com(1) = inf;
[~,median_pos] = min(sep_com);
pred = pred_all(median_pos, :);
pred = pred';
% pred = label_correction(label, pred', 1);
u_pred = unique(pred);
%%
figure;hold on;
for i=1:length(u_pred)
    scatter3(data(pred==u_pred(i),1), data(pred==u_pred(i),2), data(pred==u_pred(i),8),'.');
end
title('SMCL clustering result')

% smcl_result = clustering_evaluate(label, pred)

end

