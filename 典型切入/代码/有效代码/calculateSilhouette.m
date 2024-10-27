function silhouetteCoeff = calculateSilhouette(timeSeriesData, clusterIndices)
    numSamples = size(timeSeriesData, 1);
    silhouetteCoeff = zeros(numSamples, 1);
    
    for i = 1:numSamples
        sample = timeSeriesData(i, :);
        cluster = clusterIndices(i);
        
        % Calculate a: average distance to samples in the same cluster
        [a,~] = calculateAverageDistance(sample, timeSeriesData(clusterIndices == cluster, :));
        
        % Calculate b: average distance to samples in different clusters
        b = inf;
        for j = 1:max(clusterIndices)
            if j ~= cluster
                [~,bi] = calculateAverageDistance(sample, timeSeriesData(clusterIndices == j, :));
                b = min(b, bi);
            end
        end
        
        % Calculate silhouette coefficient
        silhouetteCoeff(i) = (b - a) / max(a, b);
        i
    end
    
    % Calculate average silhouette coefficient
    silhouetteCoeff = mean(silhouetteCoeff);
end

function [avgDistance1,avgDistance2] = calculateAverageDistance(sample, samples)
    numSamples = size(samples, 1);
    % distances = pdist2(sample,samples);

    distances = zeros(numSamples, 1);
    for i = 1:numSamples
        distances(i) = dtw_distance(sample, samples(i, :));
    end

    avgDistance1 = sum(distances)/(numSamples-1);
    avgDistance2 = mean(distances);
end
