function [outputData] = filterSema(inputData,inputTime,frameRate)

%%
%written by Chen Hua
%data: 31 July 2018
%function description: 使用symmetric exponential moving average filter进行信号滤波

%-------------输入
%filterSema: 使用symmetric exponential moving average filter进行信号滤波函数

%inputData: 待滤波的原始数据,n*1 matrix
%inputTime: 原始数据对应的时间序列, n*1 matrix, 单位: ms(也可以同一采用s)
%inputWidth: 窗宽参数,单位:ms

%----------输出
%outputData: 滤波后数据,n*1 matrix

%-----------算法
%algorithm:
%T=inputWidth;
%D=min{3*T,Ti-T1,Tn-Ti};其中Ti表示当前数据点对应时间坐标 
%Z=sum(exp(-abs(Ti-Tk)/T));其中Ti-D<=Tk<=Ti+D
%X(Ti)=1/Z*sum(x(Tk)*exp(-abs(Ti-Tk)/T))
%calling example: 
%inputTime=[1:1:100]';
%inputPosition=1/2*0.1*inputTime.^2;    匀加速运动
%inputWidth=5;  对于位置信号与速度信号，即原始数据与数据的一阶微分，建议inputWidth为近似采样时间的5倍
%outputPosition=filterSema(inputPosition,inputTime,inputWidth)

%%
length=size(inputData,1);   %length是输入信号长度
inputTime=(inputTime-inputTime(1))/frameRate;
inputWidth=5/frameRate;
for i=1:length
    D=min(min(3*inputWidth,inputTime(i)-inputTime(1)),inputTime(end)-inputTime(i));     %确定滤波窗口实际宽度
    timeLimt=[inputTime(i)-D,inputTime(i)+D];       %确定窗口边界
    idxTk=find((inputTime>=timeLimt(1))&(inputTime<=timeLimt(2)));        %根据窗口边界确定样本点
    if D==0
        Z=1;
        outputData(i)=inputData(i);     %端点处赋值
    else
        Z=sum(exp(-abs(inputTime(i)-inputTime(idxTk))/inputWidth));
        outputData(i)=sum(inputData(idxTk).*exp(-(abs(inputTime(i)-inputTime(idxTk))/inputWidth)))/Z;
    end
end
outputData=outputData';     %保证输出列向量
end

