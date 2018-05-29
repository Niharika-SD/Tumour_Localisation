function [newInitialAtlas, listOfParcels] = applyTumorToAtlas(atlas,tumor)

%tumor has 1's at tumorous location 0's elsewhere
x = size(atlas,1);
y = size(atlas,2);
z = size(atlas,3);

atlas = double(atlas);
tumor = double(tumor);

excludedParcels = atlas.*tumor;
newInitialAtlas = atlas - excludedParcels;
count = 0;
parcelList = [];

for i = 1:x
    for j = 1:y
        for k = 1:z
            if excludedParcels(i,j,k) ~= 0 && isempty(intersect(parcelList,excludedParcels(i,j,k)))
                count = count +1;
                parcelList(count) = excludedParcels(i,j,k);
            end
        end
    end
end

percentRemoved = [];
for i = 1:length(parcelList)
    denominator = length(find(atlas == parcelList(i)));
    numerator = length(find(excludedParcels == parcelList(i)));
    percentRemoved(i) = 100*(numerator/denominator) ;
end
listOfParcels = zeros(length(parcelList),2);
listOfParcels(:,1) = parcelList;
listOfParcels(:,2) = percentRemoved;


end

