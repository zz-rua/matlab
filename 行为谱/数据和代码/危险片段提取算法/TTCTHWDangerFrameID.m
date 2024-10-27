function [TTCTHWDangerFrameID]= TTCTHWDangerFrameID(carData,objectData)
%%
%----------�ڶ���Σ�ճ���ʶ��
% ����ǰ��Ŀ����TTC��THW����Σ�ճ����ж�
%----------����
% carData:����ԭʼ���ݣ�cell
% objectData��Ŀ����ԭʼ���ݣ�cell

%-----------���
% allDangerFrameID_2���ڶ���Σ�ճ�������Ϣ��cell��allDangerFrameID_1={'dangerTime','dangerType'},��¼Σ��ʱ�̺��ж�����

%--------�ж�����
% TTC��-1.75<TTC<0�������ƶ�
% THW����1��0<THW<0.5��V>20�������ƶ�����2��0<THW<0.35��10<V<=20�������ƶ�

%%
%------------��ʼ��
%����ɸѡ
frameIDIndexOB = find(strcmp(objectData(1,:),'frame_id')==1);%Ŀ����FrameID
ObjectIDIndex=find(strcmp(objectData(1,:),'object_id')==1);%ObjectID
breakSignalPlace=find(strcmp(carData(1,:),'brake_pedal_signal')==1);%�ƶ�
vehicleSpeedPlace=find(strcmp(carData(1,:),'velocity')==1);%�����ٶ�
CarframeIDIndex=find(strcmp(carData(1,:),'frame_id')==1);%����FrameID
relativeDistancePlace=find(strcmp(objectData(1,:),'relative_position_x')==1);%Ŀ��������λ��
relativeVehicleSpeedPlace=find(strcmp(objectData(1,:),'relative_velocity_x')==1);%Ŀ������������ٶ�
CIPVPlace=find(strcmp(objectData(1,:),'cipv')==1);%CIPV



%��ʼ��������
TTCTHWDangerFrameID={};
allDangerFrameID_thw={};
allDangerFrameID_ttc={};


%--------Σ��ʶ��
%--�����������
if size(objectData,1)>1&size(carData,1)>1
    objectData=cell2mat(objectData(2:end,[frameIDIndexOB,ObjectIDIndex,CIPVPlace,relativeDistancePlace,relativeVehicleSpeedPlace]));%Ŀ����������ѡ
    carData=cell2mat(carData(2:end,[CarframeIDIndex,vehicleSpeedPlace,breakSignalPlace]));%����������ѡ
    objectData(objectData(:,3)==0,:)=[];%ȥ��CIPV��Ϊ1�����ݣ�����������
    objectData(isnan(objectData(:,4)),:)=[];%ȥ��������
    
    %ʱ�������
    idxTime=ismember(carData(:,1),objectData(:,1));%�Ա�������Ŀ�공���ݵ�ʱ����
    carData(~idxTime,:)=[];%������������ȥ��
    idxTime=ismember(objectData(:,1),carData(:,1));
    objectData(~idxTime,:)=[];%Ŀ�공��������ȥ��
    if size(objectData,1)~=size(carData)
        objectData=unique(objectData,'rows');
    end
    
    %%
    %-----Σ��ʱ���ж�
    if ~isempty(breakSignalPlace)
        
        if ~isempty(vehicleSpeedPlace)&~isempty(relativeDistancePlace)
            
            thw=carData;%�����ٶȺ��ƶ��źŻ���
            thw(:,4)=objectData(:,4);%��ȡĿ�공���λ��
            thw(thw(:,2)==0,:)=[];%ȥ�������ٶ�Ϊ�������
            thw(:,5)=3.6*thw(:,4)./thw(:,2);%����THW�������ٶȵ�λΪkm/h
            %--Σ��ʱ�̲���
            idxDanger_1=find(thw(:,3)==1&thw(:,5)<0.35&thw(:,2)>10&thw(:,2)<=20);
            idxDanger_2=find(thw(:,3)==1&thw(:,5)<0.5&thw(:,2)>20);
            idxDanger=[idxDanger_1;idxDanger_2];%�ϲ�
            %----��¼
            if ~isempty(idxDanger)
                idxDanger=sortrows(idxDanger);%����ʱ������
                allDangerFrameID_thw=num2cell(thw(idxDanger,1));
                allDangerFrameID_thw(:,2)={'THW'};
                
            end
        end
        
        if ~isempty(relativeVehicleSpeedPlace)&~isempty(relativeDistancePlace)
            
            ttc=carData(:,[1,3]);%�����ƶ��źŻ���
            ttc=[ttc,objectData(:,[4,5])];%Ŀ�공���λ�ú�����ٶȻ���
            ttc(ttc(:,4)==0,:)=[];%ȥ������ٶ�Ϊ�������
            ttc(:,5)=ttc(:,3)./ttc(:,4);%TTC���㣬����ٶȵ�λΪm/s
            %--Σ��ʱ�̲���
            idxDanger=find(ttc(:,2)==1&ttc(:,5)<0&ttc(:,5)>-1.75);
            
            
            %----��¼
            if ~isempty(idxDanger)
                idxDanger=sortrows(idxDanger);
                allDangerFrameID_ttc=num2cell(ttc(idxDanger,1));
                allDangerFrameID_ttc(:,2)={'TTC'};
                
            end
        end
        
        
    end
    
    TTCTHWDangerFrameID=[allDangerFrameID_thw;allDangerFrameID_ttc];%�ϲ�
    
    TTCTHWDangerFrameID=sortrows(TTCTHWDangerFrameID);%����
end
end