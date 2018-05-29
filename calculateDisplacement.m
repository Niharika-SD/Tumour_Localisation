function retainDisplace = calculateDisplacement(IA,FA,T)

%IA = initial atlas, FA = final atlas, T = tumor. First apply tumor then
%calculate membership of each one. Look at voxels entering a network
%separate from voxels leaving a network. Tumor = 1's at tumor locations.
%First column of out is network number, second column is percent displaced.

%Displacement calculation - 

afterTumor = IA - (IA.*T);
networks = max(afterTumor(:));
out = zeros(networks,2);

retainDisplace = zeros(networks,2);

for i = 1:networks
    check = find(afterTumor == i);
    check2 = find(FA == i);
    
    checkLength = length(check);
    retainDisplace(i,1) = length(intersect(check,check2))./checkLength;
    retainDisplace(i,2) = 1 - retainDisplace(i,1);
    
end




end



