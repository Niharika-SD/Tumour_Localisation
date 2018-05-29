function out = correlateSeedWithCentroid(seed,centroid)

seed = seed';
networks = size(centroid,1);
time = size(centroid,2);
out = zeros(networks,1);
for i = 1:networks
    out(i) = corr2(seed,centroid(i,:));
end
end