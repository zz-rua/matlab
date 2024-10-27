clc;% clear
%% 导入数据
load('dataPPlus1.mat')
load('dataPPlus2.mat')
dataPro = vertcat(dataPPlus1, dataPPlus2(2:end,:));

%% 提取变量
frameRate = 25;
obx_velocity = cell(size(dataPro,1),1);
obx_velocity{1,1} = 'Longitudinal velocity series';
paramArray = zeros(size(dataPro,1)-1,6);
% labels = {'so_THW', 'sfo_THW', 'so_Re_Vcx', 'sfo_Re_Vcx', 'duration'};
% paramArray(1, :) = labels;
%%
for i =8:length(dataPro)
    begin_frame = dataPro{i,2};     %切入起始帧
    over_frame = dataPro{i,3};      %切入结束帧
    time = dataPro{i,8};    %切入时间
    index = [begin_frame:1:over_frame];     %插值样本点

    fused_data = cell2mat(dataPro{i,34}(2:end,:));    %切入目标融合数据:FrameID、纵向距离、横向距离、纵向相对速度、横向相对速度

    % 主车纵向速度序列提取
    v_ego = cell2mat(dataPro{i,11});   v_ego(:,2) = v_ego(:,2);   %主车纵向速度数组 km/h
    Vex = interp1(v_ego(:,1),v_ego(:,2),index,'linear','extrap');    %插值后的主车纵向速度序列
    Vex = fillmissing(Vex,'linear'); %处理nan值
    Vex = filterSema(Vex',index',frameRate); %滤波

    % 切入车纵向速度序列提取
    Re_Vcx = interp1(fused_data(:,1),fused_data(:,4),index,'linear','extrap').*3.6;
    Re_Vcx = fillmissing(Re_Vcx,'linear'); %处理nan值
    Re_Vcx = filterSema(Re_Vcx',index',frameRate);
    Vcx = Re_Vcx + Vex;

    % 纵向相对距离序列提取
    Re_Disx = interp1(fused_data(:,1),fused_data(:,2),index,'linear','extrap');
    Re_Disx1 = fillmissing(Re_Disx,'linear'); %处理nan值
    Re_Disx1 = filterSema(Re_Disx',index',frameRate); %车距序列

    % 切入车纵向加速度序列提取
    Ac_ego = cell2mat(dataPro{i,12});% 提取自车纵向加速度
    ReAc = cell2mat(dataPro{i,23});
    if isempty(ReAc)
        continue
    else
        Ac_ego = interp1(Ac_ego(:,1), Ac_ego(:,2),index,'linear','extrap');
        Ac_ego = fillmissing(Ac_ego,'linear'); %处理nan值
        [~, u] = unique(ReAc(:,1));
        ReAc = interp1(ReAc(u,1), ReAc(u,2),index,'linear','extrap');
        ReAc = fillmissing(ReAc,'linear'); %处理nan值
        Acx = Ac_ego + ReAc;
        Acx = filterSema(Acx',index',frameRate);
        obx_Acx{i-1,1} = Acx;
    end

% % *****************************************
figure
x = (index-index(1))/frameRate;
plot(x,Re_Disx,x,Re_Disx1,'LineWidth',2);
hold on
x = 125:2:175;
plot(x/25,Re_Disx1(x),'LineWidth',2)
xlabel('Time/s')
ylabel('车距/m') %ylabel('Distance/m')
legend('原始数据','滤波后数据') %legend('Original Data','Filtered Data')
title('局部放大图')
% 设置刻度和标签
yticks('auto');
set(gca,'Fontsize',14,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
set(gcf, 'position', [400 200 400 300])
% % % *****************************************
%     % 横向相对距离序列提取
%     Re_Disy = interp1(fused_data(:,1),fused_data(:,3),index,'linear','extrap');
%     Re_Disy = fillmissing(Re_Disy,'linear'); %处理nan值
%     Re_Disy = filterSema(Re_Disy',index',frameRate);
% 
% %     %% 1.切入车速度序列提取
% %     obx_velocity{i,1} = Vcx;
% 
%     %% 2.提取切入车与前车车距
%     Original_fused_data = cell2mat(dataPro{i,35}(2:end,:));    %原始跟随目标融合数据:FrameID、纵向距离、纵向相对速度
%     if isempty(Original_fused_data) % 没有前车
%         % ORe_Disx = inf;
%         ORe_Vcx = inf;
%         Original_disx =inf;
%     else
%         Original_disx = interp1(Original_fused_data(:,1),Original_fused_data(:,2),index,'linear','extrap');
%         Original_disx = fillmissing(Original_disx,'linear');  %处理nan值
%         Original_disx = filterSema(Original_disx',index',frameRate);  %原始跟随车距序列
% 
% %         if strcmp(dataPro{i,27},'商用车') == 1 || strcmp(dataPro{i,27},'客车') == 1
% %             cutin_length = 10;
% %         else
% %             cutin_length = 5;
% %         end
% 
% %         ORe_Disx = Original_disx - Re_Disx - cutin_length; % 再减车身长度
% 
%         % 前车与切入车纵向相对速度序列提取
%         ORe_Vcx = interp1(Original_fused_data(:,1),Original_fused_data(:,3),index,'linear','extrap');
%         ORe_Vcx = fillmissing(ORe_Vcx,'linear'); %处理nan值
%         ORe_Vcx = filterSema(ORe_Vcx',index',frameRate);
%     end
%     % 参数提取
%     so_THW = Re_Disx(1)/Vex(1);         % 初始时刻切入车和自车的THW
%     % sfo_THW = ORe_Disx(1)/Vcx(1);       % 初始时刻切入车和前车的THW
%     fo_THW = Original_disx(1)/Vex(1);   % 初始时刻前车和自车的THW
% 
%     so_Re_Vcx = Re_Vcx(1);              % 初始时刻切入车与自车相对速度
%     % sfo_Re_Vcx = ORe_Vcx(1)- Re_Vcx(1); % 初始时刻切入车与前车的相对速度
%     fo_Re_Vcx = ORe_Vcx(1);             % 初始时刻前车与自车的相对速度
% 
%     % 将参数写入数组
%     paramArray(i-1, :) = [so_THW, fo_THW, so_Re_Vcx, fo_Re_Vcx, time, Vex(1)];
end
