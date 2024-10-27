function dangerProcess = getDanger_003(dangerProcess,dataName,carData,objectData,dangerBackwardTime,dangerForwardTime,frameRate,frameLimit)
%%
%----------危险场景提取主函数
%根据主车和me数据提取危险场景，涉及纵向和横向，包括：横纵向加速度、横摆角速度、TTC和THW
%可配置向前和向后预留时间

%---------输入
% dangerProcess：危险场景初始化信息 ，cell,dangerProcess={'DataName','BeginFrame','DangerFrame','OverFrame','Type','Criterion'};
% dataName：数据名称，string，数据的根名称，通常以时间作为名称
% carData：主车原始数据，cell
% objectData：目标车原始数据，cell
% dangerBackwardTime：危险场景向后保留时间，double，用于确定起点
% dangerForwardTime：危险场景向前保留时间，double，用于确定终点
% frameRate：帧率，double
% frameLimit：数据的帧范围，double，即帧的最大值，作为每一段数据的时间上限

%------------输出
% dangerProcess：危险场景信息，cell


%frameRate是帧率，frameLimit是最大帧数

%%
%--------初始化
allDangerFrameID_1=[];
allDangerFrameID_2=[];
%---------识别
[allDangerFrameID_1]=AxAyPhiDangerFrameID(carData);%根据横纵向加速度和横摆角速度获取危险时刻

[allDangerFrameID_2]= TTCTHWDangerFrameID(carData,objectData);%根据TTC和THW获得危险时刻

allDangerFrameID=[allDangerFrameID_1;allDangerFrameID_2];%危险时刻组合
allDangerFrameID=sortrows(allDangerFrameID);
% allDangerFrameID=sort(unique([allDangerFrameID_1;allDangerFrameID_2]));%危险时刻组合，并排序
% Y=diff(allDangerFrameID);

% dangerProcess={};
%-----------合并
if ~isempty(allDangerFrameID)
    process=combineDanger(allDangerFrameID,frameRate);%危险时刻重新整理合并
    for iProcess=1:size(process,1)
        begin=process{iProcess,1}-dangerForwardTime*frameRate;%起点返回10s
        beginFrame=max(0,begin);%确定真实起始帧
        over=process{iProcess,3}+dangerBackwardTime*frameRate;%终点向前10s
        overFrame=min(frameLimit,over);%确定真实终止帧
        dangerProcess(end+1,:)={dataName,beginFrame,process{iProcess,2},overFrame,'Danger',process{iProcess,4}};%危险场景结果汇总，[名称，起始帧，终止帧,类型，原因]

    end

end

end

