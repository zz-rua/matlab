function d = euclideandist(velocity1, velocity2)
%比较序列长短，以长序列为基准插值，保证两序列长度一致
if size(velocity1,1)<size(velocity2,1)
    x1 = velocity1;     x2 = velocity2;
else
    x1 = velocity2;     x2 = velocity1;
end
% 执行线性插值
x1_interp = linspace(min(x1), max(x1), numel(x2));
d = pdist([x1_interp;x2'], 'euclidean');
end