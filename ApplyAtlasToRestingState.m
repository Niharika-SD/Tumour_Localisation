function [out, centroidMatrix, rawdata] = ApplyAtlasToRestingState(initialAtlas,rsData)


%out is the 91x109x91xtime matrix that is a visual representation of
%CentroidMatrix (reference signals). rawdata is the parcellated rsData by
%voxel (should have same amount of non zero entries as initialAtlas does)

maxParcel = max(max(max(initialAtlas)));
x = size(initialAtlas,1);
y = size(initialAtlas,2);
z = size(initialAtlas,3);
time = size(rsData,4);
out = zeros(x*y*z,time);

reshapedAtlas = reshape(initialAtlas,[91*109*91 1]);
reshapedRsData = reshape(rsData,[91*109*91 time]);
centroidMatrix = zeros(max(max(max(initialAtlas))),time);
rawdata = zeros(x*y*z,time);

for i = 1:maxParcel
    timeCourses = [];
    meanTimeCourse = [];
    if ~isempty(find(initialAtlas == i))
        coordinate = find(reshapedAtlas == i);
        rawdata(coordinate,:) = reshapedRsData(coordinate,:);
        timeCourses = reshapedRsData(coordinate,:);
        meanTimeCourse = mean(timeCourses,1);
        centroidMatrix(i,:) = meanTimeCourse;
        for j = 1:length(coordinate)
            Index = coordinate(j);
            out(Index,:) = meanTimeCourse;
        end
    end
end 
rawdata = reshape(rawdata,[x y z time]);
out = reshape(out,[x y z time]);
end


