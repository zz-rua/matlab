% 左右换道相似性匹配
% 输入：待匹配序列matchSequence，标准序列standardSequence
% 输出：待匹配序列与标准序列的DTW 平均距离meanD

function meanD = DTWdistance(matchSequence,standardSequence)
[x1,y1] = size(matchSequence);
[x2,y2] = size(standardSequence); 
% % 归一化
% ms = zeros(x1,y1);
% for i = 1:x1
%     ma = max(matchSequence);
%     mi = min(matchSequence);
%     ms(i,:) = (matchSequence(i,1)-mi)/(ma-mi);
% end
% ss = zeros(x2,y2);
% for i = 1:x2
%     ma = max(standardSequence);
%     mi = min(standardSequence);
%     ss(i,:) = (standardSequence(i,1)-mi)/(ma-mi);
% end
d = zeros(x1,x2);  % 匹配距离矩阵
for i = 1:x1
    for j = 1:x2
        d(i,j) = sqrt(sum((matchSequence(i,:)-standardSequence(j,:)).^2));
    end
end
% 累计矩阵 D
D = zeros(x1,x2);
D(1,1) = d(1,1);
% 动态规划
for i = 2:x1
    D(i,1) = d(i,1)+D(i-1,1);
end
for j = 2:x2
    D(1,j) = d(1,j)+D(1,j-1);
end
for i = 2:x1
    for j = 2:x2
        D(i,j) = d(i,j)+min(D(i-1,j),min(D(i,j-1),D(i-1,j-1)));
    end
end
% 最小平均累计距离
meanD = D(x1,x2)/max(x1,x2);


end