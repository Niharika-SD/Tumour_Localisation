function [finalAtlas, finalRef, initialCorrelations, finalCorrelations] = CombineEverythingWithMRF(rsData,tumor,atlas,GLM,stop,x1,x2,y1,y2,z1,z2,thresh,beta,iterations,indexs)


initialAtlas = applyTumorToAtlas(atlas,tumor);
GLMtimecourse = findTaskActivation(GLM,rsData,tumor,x1,x2,y1,y2,z1,z2,thresh);

[~, initialRef, ~] = ApplyAtlasToRestingState(initialAtlas,rsData);
initialCorrelations = correlateSeedWithCentroid(GLMtimecourse,initialRef);

[finalAtlas,finalRef] = VoxelWiseCorrelationWithReferenceWithMRF(initialAtlas,rsData,initialRef,stop,beta,iterations,indexs);
finalCorrelations = correlateSeedWithCentroid(GLMtimecourse,finalRef);


end