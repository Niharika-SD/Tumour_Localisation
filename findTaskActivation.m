function [FingerMotorSeed, seedmatrix] = findTaskActivation(GLM,rsData,tumor,x1,x2,y1,y2,z1,z2,percentile)

%first make sure tumor areas are removed from GLM before extracting seed.
%All inputs should be 91x109x91 and rsData has time. Right now, tumor has
%1s at tumorous locations

GLMexclude = GLM.*tumor;
GLMuse = GLM - GLMexclude;

count = 1;
for X = x1:x2
    for Y = y1:y2
        for Z = z1:z2
            if GLMuse(X,Y,Z) ~= 0
                vectorvalues(count) = GLM(X,Y,Z);
                count = count+1;
            end
        end
    end
end

seedmatrix = makeSeedImage(GLMuse,vectorvalues, percentile);
threshNumber = prctile(vectorvalues, percentile);
[thresh,numberOfNonZeros] = matrixThreshold(GLM,threshNumber);
newmatrix = elementwise4D(rsData,thresh);
FingerMotorSeed = avgTimeCourse(newmatrix,numberOfNonZeros);

end