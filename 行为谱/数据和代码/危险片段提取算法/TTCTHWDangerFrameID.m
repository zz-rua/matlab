function [TTCTHWDangerFrameID]= TTCTHWDangerFrameID(carData,objectData)
%%
%----------第二类危险场景识别
% 基于前方目标物TTC和THW进行危险场景判断
%----------输入
% carData:主车原始数据，cell
% objectData：目标物原始数据，cell

%-----------输出
% allDangerFrameID_2：第二类危险场景的信息，cell，allDangerFrameID_1={'dangerTime','dangerType'},记录危险时刻和判断依据

%--------判断依据
% TTC：-1.75<TTC<0，且有制动
% THW：（1）0<THW<0.5，V>20，且有制动，（2）0<THW<0.35，10<V<=20，且有制动

%%
%------------初始化
%数据筛选
frameIDIndexOB = find(strcmp(objectData(1,:),'frame_id')==1);%目标物FrameID
ObjectIDIndex=find(strcmp(objectData(1,:),'object_id')==1);%ObjectID
breakSignalPlace=find(strcmp(carData(1,:),'brake_pedal_signal')==1);%制动
vehicleSpeedPlace=find(strcmp(carData(1,:),'velocity')==1);%主车速度
CarframeIDIndex=find(strcmp(carData(1,:),'frame_id')==1);%主车FrameID
relativeDistancePlace=find(strcmp(objectData(1,:),'relative_position_x')==1);%目标物纵向位置
relativeVehicleSpeedPlace=find(strcmp(objectData(1,:),'relative_velocity_x')==1);%目标物纵向相对速度
CIPVPlace=find(strcmp(objectData(1,:),'cipv')==1);%CIPV



%初始化公告牌
TTCTHWDangerFrameID={};
allDangerFrameID_thw={};
allDangerFrameID_ttc={};


%--------危险识别
%--如果存在数据
if size(objectData,1)>1&size(carData,1)>1
    objectData=cell2mat(objectData(2:end,[frameIDIndexOB,ObjectIDIndex,CIPVPlace,relativeDistancePlace,relativeVehicleSpeedPlace]));%目标物数据挑选
    carData=cell2mat(carData(2:end,[CarframeIDIndex,vehicleSpeedPlace,breakSignalPlace]));%主车数据挑选
    objectData(objectData(:,3)==0,:)=[];%去除CIPV不为1的数据，减少数据量
    objectData(isnan(objectData(:,4)),:)=[];%去除空数据
    
    %时间轴对齐
    idxTime=ismember(carData(:,1),objectData(:,1));%对比主车与目标车数据的时间轴
    carData(~idxTime,:)=[];%主车多余数据去除
    idxTime=ismember(objectData(:,1),carData(:,1));
    objectData(~idxTime,:)=[];%目标车多余数据去除
    if size(objectData,1)~=size(carData)
        objectData=unique(objectData,'rows');
    end
    
    %%
    %-----危险时刻判断
    if ~isempty(breakSignalPlace)
        
        if ~isempty(vehicleSpeedPlace)&~isempty(relativeDistancePlace)
            
            thw=carData;%主车速度和制动信号汇总
            thw(:,4)=objectData(:,4);%提取目标车相对位置
            thw(thw(:,2)==0,:)=[];%去除主车速度为零的数据
            thw(:,5)=3.6*thw(:,4)./thw(:,2);%计算THW，主车速度单位为km/h
            %--危险时刻查找
            idxDanger_1=find(thw(:,3)==1&thw(:,5)<0.35&thw(:,2)>10&thw(:,2)<=20);
            idxDanger_2=find(thw(:,3)==1&thw(:,5)<0.5&thw(:,2)>20);
            idxDanger=[idxDanger_1;idxDanger_2];%合并
            %----记录
            if ~isempty(idxDanger)
                idxDanger=sortrows(idxDanger);%按照时间排序
                allDangerFrameID_thw=num2cell(thw(idxDanger,1));
                allDangerFrameID_thw(:,2)={'THW'};
                
            end
        end
        
        if ~isempty(relativeVehicleSpeedPlace)&~isempty(relativeDistancePlace)
            
            ttc=carData(:,[1,3]);%主车制动信号汇总
            ttc=[ttc,objectData(:,[4,5])];%目标车相对位置和相对速度汇总
            ttc(ttc(:,4)==0,:)=[];%去除相对速度为零的数据
            ttc(:,5)=ttc(:,3)./ttc(:,4);%TTC计算，相对速度单位为m/s
            %--危险时刻查找
            idxDanger=find(ttc(:,2)==1&ttc(:,5)<0&ttc(:,5)>-1.75);
            
            
            %----记录
            if ~isempty(idxDanger)
                idxDanger=sortrows(idxDanger);
                allDangerFrameID_ttc=num2cell(ttc(idxDanger,1));
                allDangerFrameID_ttc(:,2)={'TTC'};
                
            end
        end
        
        
    end
    
    TTCTHWDangerFrameID=[allDangerFrameID_thw;allDangerFrameID_ttc];%合并
    
    TTCTHWDangerFrameID=sortrows(TTCTHWDangerFrameID);%排序
end
end