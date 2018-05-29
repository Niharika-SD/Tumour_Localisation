function [voxel, numberOfNonZeros] = matrixThreshold(img,threshold)

%img is a 3D matrix, this function
%returns a matrix of the same size with 1's where 
%the input matrix had a value that exceeded threshold, and 0 elsewhere

numberOfNonZeros = 0;
a = size(img,1);
b = size(img,2);
c = size(img,3);

voxel = zeros(a,b,c);
 for x = 1:a
     for y = 1:b
         for z = 1:c
             if img(x,y,z) > threshold
                 voxel(x,y,z) = 1;
                 numberOfNonZeros = numberOfNonZeros+1;
             end
         end
     end
 end
end

