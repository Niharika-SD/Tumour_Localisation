function [out,newRef] = VoxelWiseCorrelationWithReference(rsData,coordinates,refSignals, confThreshold,firstMembership, weightOld,weightNew,stopcriteria)

%Need to both find correlations and max correlations and confidence values
%for correlations (max over second highest). Out has dimensions
%size(coordinates,1) x 3. Column 1 = new network assignment, column 2 = max
%correlation, column 3 = confidence value. weightOld = weighting for old
%ref signals, weightNew = weighting for new ref signals.

firstRef = refSignals;
voxels = size(coordinates,1);
firstRun = zeros(voxels,4);
networks = size(refSignals,1);
x = size(rsData,1);
y = size(rsData,2);
z = size(rsData,3);
time = size(rsData,4);
reshapedrs = reshape(rsData,[x*y*z time]);
signalsOfInterest = reshapedrs(coordinates,:);

for i = 1:voxels
    timeSeries = signalsOfInterest(i,:);
    s = zeros(networks,1);
    for j = 1:networks
        s(j) = corr2(timeSeries,firstRef(j,:));
    end
    
    %s is a networks x 1 correlation vector.
    
    firstRun(i,1) = coordinates(i);
    [firstRun(i,3),firstRun(i,2)] = max(s);
    s(firstRun(i,2)) = -10;
    firstRun(i,4) = abs(firstRun(i,3)/max(s));

end

%first run has reassignments, can take a confidence value and make new ref
%signals and then re organize etc. first column = coordinate, second = new
%network, third = correlation value, 4th = conf value. Here, compute some
%membership value (assign voxels to networks). Just take first two columns
%of first run

newRefSignalCoordinates = [];
count = 1;
for i = 1:voxels
    conf = firstRun(i,4);
    if conf >= confThreshold
        newRefSignalCoordinates(count,1) = firstRun(i,1);
        newRefSignalCoordinates(count,2) = firstRun(i,2);
        newRefSignalCoordinates(count,3) = firstRun(i,3);
        newRefSignalCoordinates(count,4) = firstRun(i,4);
        count = count +1;
    end
end

newRef = zeros(networks,time);
for i = 1:networks
    CoordinateForNetwork = newRefSignalCoordinates(find(newRefSignalCoordinates(:,2) == i),1);
    timeCourses = reshapedrs(CoordinateForNetwork,:);
    newRef(i,:) = mean(timeCourses,1);
end


newRef = newRef.*weightNew+ firstRef.*weightOld;
membership = CalculateMembership(firstMembership,firstRun);
countRuns = 0;
while membership < stopcriteria
    countRuns = countRuns+1;
    if countRuns > 1
        oldRun = Run;
    end
    Run = zeros(voxels,4);
    oldRef = newRef;
    for i = 1:voxels
        timeSeries = signalsOfInterest(i,:);
        s = zeros(networks,1);
        for j = 1:networks
            s(j) = corr2(timeSeries,oldRef(j,:));
        end
        Run(i,1) = coordinates(i);
        [Run(i,3),Run(i,2)] = max(s);
        s(Run(i,2)) = -10;
        Run(i,4) = abs(Run(i,3)/max(s));
    end
    
    %first run has reassignments, can take a confidence value and make new ref
    %signals and then re organize etc. first column = coordinate, second = new
    %network, third = correlation value, 4th = conf value. Here, compute some
    %membership value (assign voxels to networks). Just take first two columns
    %of first run
    
    newRefSignalCoordinates = [];
    count = 1;
    for i = 1:voxels
        conf = Run(i,4);
        if conf >= confThreshold
            newRefSignalCoordinates(count,1) = Run(i,1);
            newRefSignalCoordinates(count,2) = Run(i,2);
            newRefSignalCoordinates(count,3) = Run(i,3);
            newRefSignalCoordinates(count,4) = Run(i,4);
            count = count +1;
        end
    end
    
    newRef = zeros(networks,time);
    for i = 1:networks
        CoordinateForNetwork = newRefSignalCoordinates(find(newRefSignalCoordinates(:,2) == i),1);
        timeCourses = reshapedrs(CoordinateForNetwork,:);
        newRef(i,:) = mean(timeCourses,1);
    end
    
    %Take some weighted average of the two old and new reference signal as new
    %reference signal. Now, need to include some membership stopping criteria
    %I.E when 98% of the voxels are in the same network, then stop.
    newRef = newRef.*weightNew+oldRef.*weightOld;
    if countRuns < 2
        membership = CalculateMembership(firstRun,Run);
    else
        membership = CalculateMembership(oldRun,Run);
    end
    
    if countRuns > 10
        break;
    end
    
end

out = Run;
end