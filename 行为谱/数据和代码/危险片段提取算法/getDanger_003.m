function dangerProcess = getDanger_003(dangerProcess,dataName,carData,objectData,dangerBackwardTime,dangerForwardTime,frameRate,frameLimit)
%%
%----------Σ�ճ�����ȡ������
%����������me������ȡΣ�ճ������漰����ͺ��򣬰�������������ٶȡ���ڽ��ٶȡ�TTC��THW
%��������ǰ�����Ԥ��ʱ��

%---------����
% dangerProcess��Σ�ճ�����ʼ����Ϣ ��cell,dangerProcess={'DataName','BeginFrame','DangerFrame','OverFrame','Type','Criterion'};
% dataName���������ƣ�string�����ݵĸ����ƣ�ͨ����ʱ����Ϊ����
% carData������ԭʼ���ݣ�cell
% objectData��Ŀ�공ԭʼ���ݣ�cell
% dangerBackwardTime��Σ�ճ��������ʱ�䣬double������ȷ�����
% dangerForwardTime��Σ�ճ�����ǰ����ʱ�䣬double������ȷ���յ�
% frameRate��֡�ʣ�double
% frameLimit�����ݵ�֡��Χ��double����֡�����ֵ����Ϊÿһ�����ݵ�ʱ������

%------------���
% dangerProcess��Σ�ճ�����Ϣ��cell


%frameRate��֡�ʣ�frameLimit�����֡��

%%
%--------��ʼ��
allDangerFrameID_1=[];
allDangerFrameID_2=[];
%---------ʶ��
[allDangerFrameID_1]=AxAyPhiDangerFrameID(carData);%���ݺ�������ٶȺͺ�ڽ��ٶȻ�ȡΣ��ʱ��

[allDangerFrameID_2]= TTCTHWDangerFrameID(carData,objectData);%����TTC��THW���Σ��ʱ��

allDangerFrameID=[allDangerFrameID_1;allDangerFrameID_2];%Σ��ʱ�����
allDangerFrameID=sortrows(allDangerFrameID);
% allDangerFrameID=sort(unique([allDangerFrameID_1;allDangerFrameID_2]));%Σ��ʱ����ϣ�������
% Y=diff(allDangerFrameID);

% dangerProcess={};
%-----------�ϲ�
if ~isempty(allDangerFrameID)
    process=combineDanger(allDangerFrameID,frameRate);%Σ��ʱ����������ϲ�
    for iProcess=1:size(process,1)
        begin=process{iProcess,1}-dangerForwardTime*frameRate;%��㷵��10s
        beginFrame=max(0,begin);%ȷ����ʵ��ʼ֡
        over=process{iProcess,3}+dangerBackwardTime*frameRate;%�յ���ǰ10s
        overFrame=min(frameLimit,over);%ȷ����ʵ��ֹ֡
        dangerProcess(end+1,:)={dataName,beginFrame,process{iProcess,2},overFrame,'Danger',process{iProcess,4}};%Σ�ճ���������ܣ�[���ƣ���ʼ֡����ֹ֡,���ͣ�ԭ��]

    end

end

end

