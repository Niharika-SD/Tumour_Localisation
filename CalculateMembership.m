function out = CalculateMembership(run1,run2)

%run1 and run2 will have voxelx4 dimensions where the first two columns of
%each run correspond to voxel and network assignment. 
count = 0;
for i = 1:size(run1,1)
    check1 = run1(i,2);
    check2 = run2(i,2);
    if check1 == check2
        count = count+1;
    end
end

out = count./size(run1,1);
end