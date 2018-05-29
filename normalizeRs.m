function normalizedRs = normalizeRs(rsmatrix)

a = size(rsmatrix,1);
b = size(rsmatrix,2);
c = size(rsmatrix,3);
d = size(rsmatrix,4);

normalizedRs = zeros(a,b,c,d);

for x = 1:a
    for y = 1:b
        for z = 1:c
            timeseries = findtimeseriesZscore(rsmatrix,x,y,z);
            timeseries = transpose(timeseries);
            normalizedRs(x,y,z,:) = timeseries;
        end
    end
end
end
