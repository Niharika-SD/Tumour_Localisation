function [finalAtlas, finalRef, initialCorrelations, finalCorrelations] = CombineEverything(rsData,tumor,atlas,GLM,conf,weightOld,weightNew,stop,x1,x2,y1,y2,z1,z2,thresh)

%rs = rs data (91x109x91xT)
%tumor = tumor data 0's at tumor location (91x109x91) 
%atlas = initial atlas of choice (91x109x91) 
%GLM = matrix of activation of specific task (91x109x91)
%conf = threshold to keep voxels for iteration (1-3)
%stop = percent membership to converge (0-1)
%x1,x2,y1,y2,z1,z2,thresh = GLM ROI depending on task

x = size(rsData,1);
y = size(rsData,2);
z = size(rsData,3);
t = size(rsData,4);

initialAtlas = applyTumorToAtlas(atlas,tumor);
reshapedAtlas = reshape(initialAtlas,[x*y*z 1]);
coordinates = find(reshapedAtlas ~=0);
voxels = length(coordinates);
firstMembership = zeros(voxels,2);
firstMembership(:,1) = coordinates;
firstMembership(:,2) = reshapedAtlas(coordinates);

GLMtimecourse = findTaskActivation(GLM,rsData,tumor,x1,x2,y1,y2,z1,z2,thresh);
[~, initialRef, ~] = ApplyAtlasToRestingState(initialAtlas,rsData);
initialCorrelations = correlateSeedWithCentroid(GLMtimecourse,initialRef);
[finalRun,finalRef] = VoxelWiseCorrelationWithReference(rsData,coordinates,initialRef,conf,firstMembership,weightOld,weightNew,stop);
finalCorrelations = correlateSeedWithCentroid(GLMtimecourse,finalRef);
%finalRun is a voxel x 4 matrix. Need to reshape first two columns and put
%back in MNI coordinates to get finalAtlas
finalAtlas = zeros(x*y*z,1);
for i = 1:voxels
    row = finalRun(i,:,:,:);
    finalAtlas(row(1)) = row(2);
end
finalAtlas = reshape(finalAtlas,[x y z]);

end
