function [outputData] = filterSema(inputData,inputTime,frameRate)

%%
%written by Chen Hua
%data: 31 July 2018
%function description: ʹ��symmetric exponential moving average filter�����ź��˲�

%-------------����
%filterSema: ʹ��symmetric exponential moving average filter�����ź��˲�����

%inputData: ���˲���ԭʼ����,n*1 matrix
%inputTime: ԭʼ���ݶ�Ӧ��ʱ������, n*1 matrix, ��λ: ms(Ҳ����ͬһ����s)
%inputWidth: �������,��λ:ms

%----------���
%outputData: �˲�������,n*1 matrix

%-----------�㷨
%algorithm:
%T=inputWidth;
%D=min{3*T,Ti-T1,Tn-Ti};����Ti��ʾ��ǰ���ݵ��Ӧʱ������ 
%Z=sum(exp(-abs(Ti-Tk)/T));����Ti-D<=Tk<=Ti+D
%X(Ti)=1/Z*sum(x(Tk)*exp(-abs(Ti-Tk)/T))
%calling example: 
%inputTime=[1:1:100]';
%inputPosition=1/2*0.1*inputTime.^2;    �ȼ����˶�
%inputWidth=5;  ����λ���ź����ٶ��źţ���ԭʼ���������ݵ�һ��΢�֣�����inputWidthΪ���Ʋ���ʱ���5��
%outputPosition=filterSema(inputPosition,inputTime,inputWidth)

%%
length=size(inputData,1);   %length�������źų���
inputTime=(inputTime-inputTime(1))/frameRate;
inputWidth=5/frameRate;
for i=1:length
    D=min(min(3*inputWidth,inputTime(i)-inputTime(1)),inputTime(end)-inputTime(i));     %ȷ���˲�����ʵ�ʿ��
    timeLimt=[inputTime(i)-D,inputTime(i)+D];       %ȷ�����ڱ߽�
    idxTk=find((inputTime>=timeLimt(1))&(inputTime<=timeLimt(2)));        %���ݴ��ڱ߽�ȷ��������
    if D==0
        Z=1;
        outputData(i)=inputData(i);     %�˵㴦��ֵ
    else
        Z=sum(exp(-abs(inputTime(i)-inputTime(idxTk))/inputWidth));
        outputData(i)=sum(inputData(idxTk).*exp(-(abs(inputTime(i)-inputTime(idxTk))/inputWidth)))/Z;
    end
end
outputData=outputData';     %��֤���������
end

