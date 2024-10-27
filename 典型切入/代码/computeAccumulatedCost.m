function accumulatedCost = computeAccumulatedCost(distanceMatrix)
    [m, n] = size(distanceMatrix);
    accumulatedCost = zeros(m, n);
    accumulatedCost(1, 1) = distanceMatrix(1, 1);
    
    for i = 2:m
        accumulatedCost(i, 1) = distanceMatrix(i, 1) + accumulatedCost(i-1, 1);
    end
    
    for j = 2:n
        accumulatedCost(1, j) = distanceMatrix(1, j) + accumulatedCost(1, j-1);
    end
    
    for i = 2:m
        for j = 2:n
            accumulatedCost(i, j) = distanceMatrix(i, j) + min([accumulatedCost(i-1, j-1), accumulatedCost(i-1, j), accumulatedCost(i, j-1)]);
        end
    end
end
