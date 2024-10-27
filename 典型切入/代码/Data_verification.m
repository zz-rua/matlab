clc
% load('dataPPlus1.mat')
dataPro = dataPPlus2;
%%
frameRate=25;
for i =2:length(dataPro)
    if strcmp(dataPro{i,4},'切入')==1
        fused_data = cell2mat(dataPro{i,34}(2:end,:));    %切入目标融合数据
        t=(fused_data(:,1)-fused_data(1,1))/25;
        subplot(2,1,1)
        plot(t,fused_data(:,4),'LineWidth',1.5)
        xlabel('时间/s');
        ylabel('相对速度/m*s^-^1')
        set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；

        subplot(2,1,2)
        plot(t,fused_data(:,2),'LineWidth',1.5)
        xlabel('时间/s');
        ylabel('相对距离/m')
        set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；

        set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高；
        str=dataPro{i,1};
        saveas(gcf,['D:\桌面\实验室相关\科研学习\典型切入场景聚类\数据校核作图\',str,'.png'])
        close
    end
end