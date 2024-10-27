function allDangerFrameID_1=AxAyPhiDangerFrameID(carData)
%%
%----------第一类危险场景识别
% 基于主车纵向加速度、横向加速度和横摆角的异常判断危险场景

%-------输入
% carData：主车原始数据，cell

%---------输出
% allDangerFrameID_1：第一类危险场景的信息，cell，allDangerFrameID_1={'dangerTime','dangerType'},记录危险时刻和判断依据

%------判断依据
% 纵向加速度：（1）ax<=-5，V<=50，（2）ax <=-3，V>90，（3）ax <=V/20-7.5，50 <V<=90
% 横向加速度：（1）|ay|>=(9*V/80)+2.5，V<=40，（2）|ay|>=7，40<V<=50，（3）|ay|>=(-3*V/50)+10，50 <V<=100，（4）|ay|>=4，100 <V
% 横摆角速度：（1）|φ|>=50，V<40，（2）|φ|>=-2.5*V+150，40<V<=50，（3）|φ|>=2*(50-V)/7+25，50<V<=85，（4）|φ|>=15，85<V

%%
%---------初始化
%数据筛选
CarframeIDIndex=find(strcmp(carData(1,:),'frame_id')==1);%主车FrameID
vehicleSpeedPlace=find(strcmp(carData(1,:),'velocity')==1);%速度
% longAccPlace=find(strcmp(carData(1,:),'LongitudinalAcceleration')==1);%纵向加速度
% lateralAccPlace=find(strcmp(carData(1,:),'LateralAcceleration')==1);%横向加速度
longAccPlace=find(strcmp(carData(1,:),'longitudinal_acceleration')==1);%纵向加速度
lateralAccPlace=find(strcmp(carData(1,:),'lateral_acceleration')==1);%横向加速度
phiPlace=find(strcmp(carData(1,:),'yaw_rate')==1);%横摆角速度
% phiPlace=find(strcmp(carData(1,:),'YawRate')==1);

%初始化公告牌
allDangerFrameID_1={};
allDangerFrameID_long={};
allDangerFrameID_lat={};
allDangerFrameID_phi={};

%----------危险识别
%---如果存在主车数据
if size(carData,1)>1
    carData=cell2mat(carData(2:end,[CarframeIDIndex,vehicleSpeedPlace,longAccPlace,lateralAccPlace,phiPlace]));%挑选相关数据
    
    
    %--------纵向加速度判断
    
    if ~isempty(vehicleSpeedPlace)&~isempty(longAccPlace)
        idxDanger_01=find(carData(:,2)<=50&carData(:,3)<=-5);
        idxDanger_02=find(carData(:,2)>=90&carData(:,3)<=-3);
        idxDanger_03=find(carData(:,2)<90&carData(:,2)>50&carData(:,3)<=carData(:,2)/20-7.5);
        idxDanger=[idxDanger_01;idxDanger_02;idxDanger_03];
        if ~isempty(idxDanger)
            idxDanger=sortrows(idxDanger);
            allDangerFrameID_long=num2cell(carData(idxDanger,1));
            allDangerFrameID_long(:,2)={'LongitudinalAccelaration'};
            
            
        end
        
        
        
    end
    
    %---------横向加速度判断
    if ~isempty(vehicleSpeedPlace)&~isempty(lateralAccPlace)
        idxDanger_01=find(carData(:,2)<=40&abs(carData(:,4))>=carData(:,2)*9/80+2.5);
        idxDanger_02=find(carData(:,2)>=100&abs(carData(:,4))>=4);
        idxDanger_03=find(carData(:,2)>40&carData(:,2)<=50&abs(carData(:,4))>=7);
        idxDanger_04=find(carData(:,2)>50&carData(:,2)<=100&abs(carData(:,4))>=-3*carData(:,2)/50+10);
        
        idxDanger=[idxDanger_01;idxDanger_02;idxDanger_03;idxDanger_04];
        if ~isempty(idxDanger)
            idxDanger=sortrows(idxDanger);
            allDangerFrameID_lat=num2cell(carData(idxDanger,1));
            allDangerFrameID_lat(:,2)={'LateralAccelaration'};
            
            
        end
        
    end
    
    %------------横摆角速度判断
    if ~isempty(vehicleSpeedPlace)&~isempty(phiPlace)
        idxDanger_01=find(carData(:,2)<=40&abs(carData(:,5))>=50);
        idxDanger_02=find(carData(:,2)>85&abs(carData(:,5))>=15);
        idxDanger_03=find(carData(:,2)>40&carData(:,2)<=50&abs(carData(:,5))>=-2.5*carData(:,2)+150);
        idxDanger_04=find(carData(:,2)>50&carData(:,2)<=85&abs(carData(:,5))>=2*(50-carData(:,2))/7+25);
        
        idxDanger=[idxDanger_01;idxDanger_02;idxDanger_03;idxDanger_04];
        if ~isempty(idxDanger)
            idxDanger=sortrows(idxDanger);
            allDangerFrameID_phi=num2cell(carData(idxDanger,1));
            allDangerFrameID_phi(:,2)={'YawRate'};
            
            
        end
      
    end
    
    allDangerFrameID_1=[allDangerFrameID_long;allDangerFrameID_lat;allDangerFrameID_phi];
    
    allDangerFrameID_1=sortrows(allDangerFrameID_1);%排序
end
end