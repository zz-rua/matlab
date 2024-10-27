% 二维
label = {'THW_t_c(s)', 'THW_t_f(s)', 'RV_t_c(m/s)', 'RV_t_f(m/s)', 'T(s)', 'V_t_0(m/s)', 'VM_c', 'IL', 'W', 'Type_c'};
first = 1;
second = 5;
third = 7;
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

% figure
% for k = 1:size(m, 1)
%     num = rand(1)-0.5;
%     plot(data(pred == k, first), data(pred == k, second)+num, '.', 'Color', colors(k,:), 'MarkerSize', 10);
%     hold on;
%     plot(centroids(k, first), centroids(k, second)+num, '^', 'MarkerSize', 10, 'MarkerEdgeColor',colors(k,:),'MarkerFaceColor',colors(k,:));
% end
% xlabel(label(first))
% ylabel(label(second))
% %     zlabel('Weather')
% set(gca,'Fontsize',12,'Linewidth',0.8);
% set(gcf, 'position', [1200 200 400 300]);

%% 第一种作图
figure
l = [1;2;3;4;5;6];
% l = [7;8;9;10;11];
for i = 1:size(l,1)
    k = l(i);
    scatter3(data(pred == k, first), data(pred == k, second), data(pred == k, third),20,colors(k,:),'.');
    hold on;
    scatter3(centroids(k, first), centroids(k, second), centroids(k, third), 200, '^', 'filled','MarkerEdgeColor',colors(k,:),'MarkerFaceColor',colors(k,:));
end
xlim([-2,10])
zticks(1:4); zticklabels({'Acc', 'Uni', 'Dec', 'D2A'}); 
ztickangle(45);
xlabel(label(first))
ylabel(label(second))
zlabel(label(third))
legend('','C1', '','C2', '','C3', '','C4', '','C5', '','C6', 'Location', 'best','EdgeColor',[0.65,0.65,0.65]);
% legend('','C7', '','C8', '','C9', '','C10', '','C11', 'Location', 'best','EdgeColor',[0.65,0.65,0.65]);
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [1200 200 400 300]);

% 详细图1.3 1.4
first = 3;
second = 6;
third = 8;
% third = 10;
l = [1;4;6];
figure
for i = 1:size(l,1)
    k = l(i);
    scatter3(data(pred == k, first), data(pred == k, second), data(pred == k, third),50,colors(k,:),'.');
    hold on;
    scatter3(centroids(k, first), centroids(k, second), centroids(k, third), 300, '^', 'filled','MarkerEdgeColor',colors(k,:),'MarkerFaceColor',colors(k,:));
end
zticks(1:2); zticklabels({'Day', 'Night'}); 
zticklabels({'PSV', 'CMV'}); 
ylim([0,38])
xlabel(label(first))
ylabel(label(second))
zlabel(label(third))
legend('','C1', '','C4','','C6', 'Location', 'best','EdgeColor',[0.65,0.65,0.65]);
set(gca,'Fontsize',16,'Linewidth',0.8);
set(gcf, 'position', [1200 200 420 300]);

% 详细图1.5 1.6
first = 3;
second = 6;
% third = 9;
third = 8;
% l = [7;10];
l = [8;9];
for i = 1:size(l,1)
    k = l(i);
    scatter3(data(pred == k, first), data(pred == k, second), data(pred == k, third),60,colors(k,:),'.');
    hold on;
    scatter3(centroids(k, first), centroids(k, second), centroids(k, third), 300, '^', 'filled','MarkerEdgeColor',colors(k,:),'MarkerFaceColor',colors(k,:));
end
zticks(1:2); zticklabels({'Clear', 'Non-clear'});
zticklabels({'Day', 'Night'}); 
ztickangle(45);
ylim([0,38])
xlabel(label(first))
ylabel(label(second))
zlabel(label(third))
% legend('','C7', '','C10', 'Location', 'best','EdgeColor',[0.65,0.65,0.65]);
legend('','C8', '','C9', 'Location', 'best','EdgeColor',[0.65,0.65,0.65]);
set(gca,'Fontsize',16,'Linewidth',0.8);
set(gcf, 'position', [1200 200 450 300]);

%% 第二种作图
markers = {'o', 'v', 's', 'd', '^', 'p', 'h', '+', '*', '<', '>'};
figure
% l = [1;2;3;4;5;10];
l = [6;7;8;9;11];
for i = 1:size(l,1)
    k = l(i);
    scatter3(data(pred == k, first), data(pred == k, second), data(pred == k, third),20,colors(k,:),markers{k});
    hold on;
    scatter3(centroids(k, first), centroids(k, second), centroids(k, third), 200,  [markers{k} 'k'],'filled');
end
xlabel(label(first))
ylabel(label(second))
zlabel(label(third))
% legend('C1', '','C2', '','C3', '','C4', '','C5', '', 'C6', '','Location', 'best');
legend('C7', '','C8', '','C9', '','C10', '','C11', '','Location', 'best','EdgeColor',[0.65,0.65,0.65]);
set(gca,'Fontsize',12,'Linewidth',0.8);
set(gcf, 'position', [1200 200 400 300]);

