function process=combineDanger(allDangerFrameID,frameRate)

allDangerFrameID=sortrows(allDangerFrameID,1);%allDangerFrameID按照第一列的危险时刻进行排序

process=[allDangerFrameID(:,1),allDangerFrameID(:,1),allDangerFrameID(:,1),allDangerFrameID(:,2)];%危险原始过程初始化，[起点，危险时刻，终点，原因]，起点与终点使用危险时刻
idxDelete=[];
for iProcess=size(process,1):-1:2%倒叙合并
    if process{iProcess,1}-process{iProcess-1,3}<5*frameRate%如果当前的危险过程起点与上一过程的终点间隔小于5s
        process{iProcess-1,3}=process{iProcess,3};%合并过程
        if isempty(strfind(process{iProcess,4},process{iProcess-1,4}))
            process{iProcess-1,4}=strcat(process{iProcess-1,4},'_',process{iProcess,4});
        end
        
        idxDelete(end+1,:)=iProcess;%记录被合并的过程
    end
    
    
    
end
process(idxDelete,:)=[];%被合并的过程删除

end