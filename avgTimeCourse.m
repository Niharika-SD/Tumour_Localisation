function avg = avgTimeCourse(newmatrix,numberOfNonZeros)

a = size(newmatrix,4);
avg = zeros(1,a);
total = sum(sum(sum(newmatrix(:,:,:,:)))); %makes total a 1x1x1xa matrix 

for n = 1:a
    avg(1,n) = total(1,1,1,n)/numberOfNonZeros;
end
avg = zscore(avg);
avg = transpose(avg);
end



