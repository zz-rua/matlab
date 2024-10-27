clc;% clear
% dataPro = vertcat(dataPPlus1, dataPPlus2(2:end,:));
frameRate = 25;
k = 1;
for i =2:length(dataPro)
    begin_frame = dataPro{i,2};     %切入起始帧
    over_frame = dataPro{i,3};      %切入结束帧
    time = dataPro{i,8};    %切入时间
    index = [begin_frame:1:over_frame];     %插值样本点

    fused_data = cell2mat(dataPro{i,34}(2:end,:));    %切入目标融合数据:FrameID、纵向距离、横向距离、纵向相对速度、横向相对速度

    % 主车纵向速度序列提取
    v_ego = cell2mat(dataPro{i,11});   v_ego(:,2) = v_ego(:,2)./3.6;   %主车纵向速度数组
    Vex = interp1(v_ego(:,1),v_ego(:,2),index,'linear','extrap');    %插值后的主车纵向速度序列
    Vex = fillmissing(Vex,'linear'); %处理nan值
    Vex = filterSema(Vex',index',frameRate); %滤波

    % 切入车纵向速度序列提取
    Re_Vcx = interp1(fused_data(:,1),fused_data(:,4),index,'linear','extrap');
    Re_Vcx = fillmissing(Re_Vcx,'linear'); %处理nan值
    Re_Vcx = filterSema(Re_Vcx',index',frameRate);
    Vcx = Re_Vcx + Vex;

    % 纵向相对距离序列提取
    Re_Disx = interp1(fused_data(:,1),fused_data(:,2),index,'linear','extrap');
    Re_Disx = fillmissing(Re_Disx,'linear'); %处理nan值
    Re_Disx = filterSema(Re_Disx',index',frameRate); %车距序列

    % 横向相对距离序列提取
    Re_Disy = interp1(fused_data(:,1),fused_data(:,3),index,'linear','extrap');
    Re_Disy = fillmissing(Re_Disy,'linear'); %处理nan值
    Re_Disy = filterSema(Re_Disy',index',frameRate);

    %% 8.24更新：提取切入车与前车车距
    Original_fused_data = cell2mat(dataPro{i,35}(2:end,:));    %原始跟随目标融合数据:FrameID、纵向距离、纵向相对速度
    if isempty(Original_fused_data) % 没有前车
        ORe_Disx = inf;
        ORe_Vcx = inf;
    else
        Original_disx = interp1(Original_fused_data(:,1),Original_fused_data(:,2),index,'linear','extrap');
        Original_disx = fillmissing(Original_disx,'linear');  %处理nan值
        Original_disx = filterSema(Original_disx',index',frameRate);  %原始跟随车距序列

        if strcmp(dataPro{i,27},'商用车') == 1 || strcmp(dataPro{i,27},'客车') == 1
            cutin_length = 10;
        else
            cutin_length = 5;
        end

        ORe_Disx = Original_disx - Re_Disx - cutin_length; % 再减车身长度

        % 前车与切入车纵向相对速度序列提取
        ORe_Vcx = interp1(Original_fused_data(:,1),Original_fused_data(:,3),index,'linear','extrap');
        ORe_Vcx = fillmissing(ORe_Vcx,'linear'); %处理nan值
        ORe_Vcx = filterSema(ORe_Vcx',index',frameRate);
    end
    % 参数提取
    % % 设置标签行
    % labels = {'so_THW', 'sfo_THW', 'so_Re_Vcx', 'sfo_Re_Vcx', 'cutin_time'};
    % paramArray(1, :) = labels;
    so_THW = Re_Disx(1)/Vex(1);         % 初始时刻切入车和自车的THW
    sfo_THW = ORe_Disx(1)/Vcx(1);       % 初始时刻切入车和前车的THW
    so_Re_Vcx = Re_Vcx(1);              % 初始时刻切入车与自车相对速度
    sfo_Re_Vcx = ORe_Vcx(1)- Re_Vcx(1); % 初始时刻切入车与前车的相对速度
    cutin_time = time;                  % 切入时长

    % 将参数写入数组
    paramArray(k, :) = [so_THW, sfo_THW, so_Re_Vcx, sfo_Re_Vcx, cutin_time];
    k=k+1;
end

%% 8.9更新
% 提取初始车距、初始相对车速、切入时长
clusterdata_v1{k, 1} = Re_Disx(1);
clusterdata_v1{k, 2} = Re_Vcx(1);
clusterdata_v1{k, 3} = time;
k=k+1;

%% step1:切入车纵向速度序列
obx_velocity{k,1} = Vcx;
k=k+1;
%% step2：切入车的横向偏移量
%主车每一时刻轨迹：纵向位置对速度积分计算，横向位置根据车道线偏移量计算
offset = cell2mat(dataPro{i,15});%主车横向偏移量
ob_Disy = [];
if strcmp(dataPro{i,26},'左') == 1 || Re_Disy(1) > 0
    [~, I] = unique(offset(:,1), 'first');
else
    [~, I] = unique(offset(:,1), 'last');
end
ego_Disy = offset(I,:); %主车与车道线的距离
ego_Disy = interp1(ego_Disy(:,1),ego_Disy(:,2),index,'linear','extrap');
ego_Disy = fillmissing(ego_Disy,'linear');
ego_Disy = filterSema(ego_Disy',index',frameRate);
ob_Disy = ego_Disy+Re_Disy;%切入车横向位置=主车与车道线距离+横向相对距离

%% step3：对切入车纵向位置
t = (index-begin_frame)/frameRate;           %切入时间序列
ob_Disx = []; ego_Disx = [];
ego_Disx(1,1) = 0;
ob_Disx(1,1) = Re_Disx(1);
for j = 2:length(t)
    Q = trapz(t(1:j),Vex(1:j));
    ob_Disx(j,1) = Q+Re_Disx(j);
    ego_Disx(j,1) = Q;
end
ob_trajectories{k,1} = [ob_Disx,ob_Disy]; %切入车轨迹序列
k=k+1;
%     %画图
%     plot(ego_Disx,ego_Disy,ob_Disx,ob_Disy,'LineWidth',2)
%     yline(-3.5,'--k','车道线','LineWidth',1.5);yline(0,'--k','车道线','LineWidth',1.5);yline(3.5,'--k','LineWidth',1.5);
%     legend('自车轨迹','切入车轨迹')
%     xlabel('车辆纵向行驶距离/m')
%     ylabel('车辆横向位置/m')
%     title(['切入时长:',num2str(time),'s'])
%     set(gca,'Fontsize',12,'Linewidth',0.8);%横纵坐标范围、字体、线粗；
%     set(gcf, 'position', [400 200 400 300]);%设置图框位置及大小，其中400、200为左下角位置，400、300为宽高；
%     saveas(gcf,['D:\桌面\实验室相关\科研学习\典型切入场景聚类\切入车轨迹作图2\',num2str(i-1),'.png'])
%     close
%end

%% 2024/03/25更新
% 提取压线到切入结束过程中的最小TTC、THW、Safety Margin、风险度与风险率
% 找到压线时刻和压线点：与车道线的横向距离最小点


% 主车纵向加速度序列提取
Accx_ego = cell2mat(dataPro{i,12});      %主车纵向加速度数组
Accx = interp1(Accx_ego(:,1),Accx_ego(:,2),index,'linear','extrap');    %插值后的主车纵向加速度序列
Accx = fillmissing(Accx,'linear'); %处理nan值
Accx = filterSema(Accx',index',frameRate); %滤波

t=1;  %反应时间
g=9.8;  %重力加速度
a_max=0.5*g;   %主车和前车的最大减速度
dmin= Vex*t+ 0.5*Accx*t^2 + ((Vex+t*Accx)^2)/(2*a_max) - (Vcx^2)/(2*a_max);  %最小安全距离
if dmin<0 %最小安全距离取正值
    dmin=0;
end

            for frame = 1: numofFrame(1)
                VH=carData(frame,2);%主车速度
                VL=carData(frame,2)+objectData(frame,5); %前车速度
                acc=carData(frame,3);%主车实时纵向加速度
                t=1;%反应时间
                g=9.8;%重力加速度
                a_max=0.5*g; %主车和前车的最大减速度
                dmin= VH*t+ 0.5*acc*t^2 + ((VH+t*acc)^2)/(2*a_max) - (VL^2)/(2*a_max); %最小安全距离
                if dmin<0 %最小安全距离取正值
                    dmin=0;         
                end
                
                d=objectData(frame,4); %前后车实际距离
                if d < dmin 
                    dangerframe = dangerframe+1;
                    dangerLevel = dangerLevel+(dmin-d)/dmin; %风险度  
                end
            end


