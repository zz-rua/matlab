function NEWcentroids = meancentroids(clusterData)

max_length = max(cellfun(@numel, clusterData)); %步骤1：计算最长时间序列的长度
aligned_series = zeros(length(clusterData), max_length); % 步骤2：将不等长时间序列插值为相同长度
for j = 1 : length(clusterData)
    current_series = clusterData{j};
    current_series(end+1:max_length) = current_series(end);
    aligned_series(j, :) = current_series;
end
centroid = round(mean(aligned_series,1), 4);
NEWcentroids = unique(centroid,'stable')';

end
