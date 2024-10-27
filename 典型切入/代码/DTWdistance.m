% ���һ���������ƥ��
% ���룺��ƥ������matchSequence����׼����standardSequence
% �������ƥ���������׼���е�DTW ƽ������meanD

function meanD = DTWdistance(matchSequence,standardSequence)
[x1,y1] = size(matchSequence);
[x2,y2] = size(standardSequence); 
% % ��һ��
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
d = zeros(x1,x2);  % ƥ��������
for i = 1:x1
    for j = 1:x2
        d(i,j) = sqrt(sum((matchSequence(i,:)-standardSequence(j,:)).^2));
    end
end
% �ۼƾ��� D
D = zeros(x1,x2);
D(1,1) = d(1,1);
% ��̬�滮
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
% ��Сƽ���ۼƾ���
meanD = D(x1,x2)/max(x1,x2);


end