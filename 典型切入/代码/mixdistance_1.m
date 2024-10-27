function dis = mixdistance_1(clusterData1, clusterData2)
%% 1：dis = 1/2*(1/2*d1+1/√12*d2); dtw∈[0, 2]  euclidean∈[0, √12]   dis∈[0, 1]

% w1 = 2;    w2 = sqrt(12);
% for i = 1:size(clusterData1,1)
%     for j = 1:size(clusterData2,1)
%         d1(i,j) = dtw_distance(clusterData1{i,1}, clusterData2{j,1});
%     end
%     d2(i,:) = pdist2(cell2mat(clusterData1(i,2:end)),cell2mat(clusterData2(:,2:end)),"euclidean");
% end
%
% dis = (d1./w1+d2./w2).*0.5;

%% 2：曼哈顿距离
% for i = 1:size(clusterData1,1)
%     for j = 1:size(clusterData2,1)
%         d1(i,j) = dtw_distance(clusterData1{i,1}, clusterData2{j,1});
%     end
%     d2(i,:) = pdist2(cell2mat(clusterData1(i,2:end)),cell2mat(clusterData2(:,2:end)),"cityblock");
% end
%
% dis = 0.5*d1+(1/6)*d2;

%% 3：马氏距离
dis = zeros(size(clusterData1,1),size(clusterData2,1));
for i = 1:size(clusterData1,1)
    for j = 1:size(clusterData2,1)
        dis(i,j) = dtw_distance(clusterData1{i,1}, clusterData2{j,1});
    end
end

% if size(clusterData1,1) == 1 || size(clusterData2,1) == 1
% 
%     totaldis = pdist([cell2mat(clusterData1(:,2:end)); cell2mat(clusterData2(:,2:end))],'mahalanobis');
%     d2 = totaldis(1:max(size(clusterData1,1),size(clusterData2,1)));
%     dis = d1 + d2;
% else
%     d2 = pdist2(cell2mat(clusterData1(:,2:end)),cell2mat(clusterData2(:,2:end)),"mahalanobis");
% 
%     normalized_dtw_distances = (d1 - min(d1)) ./ (max(d1) - min(d1));
%     normalized_mahalanobis_distances = (d2 - min(d2)) ./ (max(d2) - min(d2));
% 
%     dis = normalized_dtw_distances+normalized_mahalanobis_distances;
% end

end
