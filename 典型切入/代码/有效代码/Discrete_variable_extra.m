% dataPro = vertcat(dataPPlus1, dataPPlus2(2:end,:));

%% 创建光照条件和映射数值的映射字典
illumination = dataPro(2:end,31); % 查找时间类型
% uniqueValues = unique(illumination);
map = containers.Map({'白天', '黄昏', '夜晚'}, {1, 2, 2});
for i = 1:size(illumination, 1)
    keyword = illumination{i, 1};
    if isKey(map, keyword)
        illumination{i, 2} = map(keyword);
    end
end
TBL.IL = illumination(:,1);
TBL.IL_Label = cell2mat(illumination(:,2));
sum(cell2mat(illumination(:,2))==1)/2415*100;

%% 创建天气条件和映射数值的映射字典
weather = dataPro(2:end,32);
% uniqueValues = unique(weather);
weatherMap = containers.Map({'晴朗', '雨天', '雪天', '雾霾'}, {1, 2, 2, 2});
for i = 1:size(weather, 1)
    weatherCondition = weather{i, 1};
    if isKey(weatherMap, weatherCondition)
        weather{i, 2} = weatherMap(weatherCondition);
    end
end
TBL.Wx = weather(:,1);
TBL.Wx_Label = cell2mat(weather(:,2));
sum(cell2mat(weather(:,2))==1)/2415*100

%% 切入车类型
CO_TYPE = dataPro(2:end,27);
% uniqueValues = unique(CO_TYPE);
index1 = find(strcmp(CO_TYPE, 'Front Object'));
index2 = find(strcmp(CO_TYPE, '无'));
index = [index1;index2];
for i = 1:size(index,1)
    CO_ID = dataPro{index(i),6}; % 切入目标物（切入车）ID
    Surround_vehicle = dataPro{index(i),10}; % 周边车辆信息    
    found = false;
    for j = 1:size(Surround_vehicle, 2) % 从第二行开始，跳过列名
        if isequal(Surround_vehicle{2, j}, CO_ID)
            CO_TYPE(index(i)) = Surround_vehicle(2,j+1);
            found = true;
            break
        end
    end
end
% 创建切入车辆类型及其映射
vehicleMap = containers.Map({'乘用车', '商用车', '客车'}, {1, 2, 2});
for i = 1:size(CO_TYPE, 1)
    vehicleType = CO_TYPE{i, 1};
    if isKey(vehicleMap, vehicleType)
        CO_TYPE{i, 2} = vehicleMap(vehicleType);
    end
end
TBL.CO_TYPE = CO_TYPE(:,1);
TBL.CO_Label = cell2mat(CO_TYPE(:,2));
sum(cell2mat(CO_TYPE(:,2))==1)/2415*100


%% 前车类型
FO_TYPE = cell(size(dataPro,1)-1,1);
for i =2:length(dataPro)
    FO_ID = dataPro{i,5}; % 原始跟随目标物（前车）ID
    Surround_vehicle = dataPro{i,10}; % 周边车辆信息
    % 查找前车类型
    if strcmp(FO_ID,'无') == 1
        FO_TYPE{i-1} = '无';
    else
        columnIndex = find(strcmp(Surround_vehicle(1, :), 'FO MeID'));
        FO_TYPE(i-1) = Surround_vehicle(2,columnIndex+1);
    end
end
% uniqueValues = unique(FO_TYPE);
% 创建前车车辆类型及其映射
vehicleMap = containers.Map({'乘用车', '商用车', '客车', '无'}, {1, 2, 2, 3});
for i = 1:size(FO_TYPE, 1)
    vehicleType = FO_TYPE{i, 1};
    if isKey(vehicleMap, vehicleType)
        FO_TYPE{i, 2} = vehicleMap(vehicleType);
    end
end
TBL.FO_TYPE = FO_TYPE(:, 1);
TBL.FO_Label = cell2mat(FO_TYPE(:, 2));
sum(cell2mat(FO_TYPE(:,2))==1)/2415*100