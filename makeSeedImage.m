function seed = makeSeedImage(GLMmatrix,vectorvalues,percentile)

x = size(GLMmatrix,1);
y = size(GLMmatrix,2);
z = size(GLMmatrix,3);
seed = zeros(x,y,z);
threshNumber = prctile(vectorvalues, percentile);

for a = 1:x
    for b = 1:y
        for c = 1:z
            if GLMmatrix(a,b,c) >= threshNumber
                seed(a,b,c) = 1;
            end
        end
    end
end


end



