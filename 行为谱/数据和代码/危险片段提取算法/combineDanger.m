function process=combineDanger(allDangerFrameID,frameRate)

allDangerFrameID=sortrows(allDangerFrameID,1);%allDangerFrameID���յ�һ�е�Σ��ʱ�̽�������

process=[allDangerFrameID(:,1),allDangerFrameID(:,1),allDangerFrameID(:,1),allDangerFrameID(:,2)];%Σ��ԭʼ���̳�ʼ����[��㣬Σ��ʱ�̣��յ㣬ԭ��]��������յ�ʹ��Σ��ʱ��
idxDelete=[];
for iProcess=size(process,1):-1:2%����ϲ�
    if process{iProcess,1}-process{iProcess-1,3}<5*frameRate%�����ǰ��Σ�չ����������һ���̵��յ���С��5s
        process{iProcess-1,3}=process{iProcess,3};%�ϲ�����
        if isempty(strfind(process{iProcess,4},process{iProcess-1,4}))
            process{iProcess-1,4}=strcat(process{iProcess-1,4},'_',process{iProcess,4});
        end
        
        idxDelete(end+1,:)=iProcess;%��¼���ϲ��Ĺ���
    end
    
    
    
end
process(idxDelete,:)=[];%���ϲ��Ĺ���ɾ��

end