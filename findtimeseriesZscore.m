function timeseries = findtimeseriesZscore(img,x,y,z)

d = size(img,4);

timeseries = zeros(1,d);

for a = 1:d
    timeseries(1,a) = img(x,y,z,a);
end

timeseries = zscore(timeseries);
timeseries = transpose(timeseries);
end

