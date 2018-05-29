function out = CalculateMembershipMRF(atlas1,atlas2)

%these atlases should only be 902629x1 vectors, dont include zeros
voxel = size(atlas1,1);
denom = nnz(atlas1);
count = 0;
for i = 1:voxel
    check1 = atlas1(i);
    check2 = atlas2(i);
    if check1 == check2 && check1 ~=0 
        count = count + 1;
    end
end
out = count / denom;


end