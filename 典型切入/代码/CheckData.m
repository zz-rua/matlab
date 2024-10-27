% 需进一步校核数据片段提取
k = 1;
FO_check = [];
wx_check = [];
CO_check = [];
for i =2:length(dataPro)

    % 提取天气异常数据
    weather{k} = dataPro{i,32}; % 查找天气类型
    if strcmp(weather(k),'天气') == 1 || strcmp(weather(k),'无') == 1
        wx_check = [wx_check;i];
    end

    Surround_vehicle = dataPro{i,10}; % 周边车辆信息

    % 查找前车类型
    FO_ID = dataPro{i,5}; % 原始跟随目标物（前车）ID
    Original_fused_data = cell2mat(dataPro{i,35}(2:end,:));    %原始跟随目标融合数据:FrameID、纵向距离、纵向相对速度
    if strcmp(FO_ID,'无') == 1
        FO_TYPE{k} = '无';
    else
        columnIndex = find(strcmp(Surround_vehicle(1, :), 'FO MeID'));
        FO_TYPE(k) = Surround_vehicle(2,columnIndex+1);
    end
    % 提取前车类型缺失片段——有前车数据但是无前车类型
    if strcmp(FO_TYPE(k),'无') == 1 || strcmp(FO_TYPE(k),'车辆类型') == 1
        if isempty(Original_fused_data)==0 % 没有前车
            FO_check = [FO_check;i];
        end
    end

    % 查找切入车类型
    CO_ID = dataPro{i,6}; % 切入目标物（切入车）ID
    found = false;
    for index = 1:size(Surround_vehicle, 2) % 从第二行开始，跳过表头
        if isequal(Surround_vehicle{2, index}, CO_ID)
            CO_TYPE(k) = Surround_vehicle(2,index+1);
            found = true;
            break
        end
    end
    if ~found
        CO_TYPE{k} = dataPro{i,27};
    end
    % 查找切入车类型异常数据
    if strcmp(CO_TYPE(k),'无') == 1 || strcmp(CO_TYPE(k),'Front Object') == 1
        CO_check = [CO_check;i];
    end

    k = k+1;
end

% 创建一个新的Cell数组来存储异常数据
exceptionData = cell(length(FO_check) + length(wx_check) + length(CO_check)+1, 38);
exceptionData{1, 38} = '异常数据类型';
exceptionData(1, 1:37) = dataPro(1, :);
% 复制异常数据到新数组中
exceptionCount = 1;

for i = 1:length(wx_check)
    exceptionCount = exceptionCount + 1;
    exceptionData{exceptionCount, 38} = '天气数据异常';
    exceptionData(exceptionCount, 1:37) = dataPro(wx_check(i), :);
end

for i = 1:length(FO_check)
    exceptionCount = exceptionCount + 1;
    exceptionData{exceptionCount, 38} = '前车类型数据异常';
    exceptionData(exceptionCount, 1:37) = dataPro(FO_check(i), :);
end

for i = 1:length(CO_check)
    exceptionCount = exceptionCount + 1;
    exceptionData{exceptionCount, 38} = '切入车辆数据异常';
    exceptionData(exceptionCount, 1:37) = dataPro(CO_check(i), :);
end
