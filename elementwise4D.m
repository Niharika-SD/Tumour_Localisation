function newmatrix = elementwise4D(rawmatrix,threshold)

%input and outout matrix are 4D while threshold is a 3D matrix
% of 1's and 0's. The first three dimensions of all matrices are
% the same. The newmatrix is the same dimensions as the input matrix,
%and retains values when threshold = 1, and makes values 0 for else

a = size(rawmatrix,1);
b = size(rawmatrix,2);
c = size(rawmatrix,3);
d = size(rawmatrix,4);

newmatrix = zeros(a,b,c,d);
newthreshold = threetofourD(threshold, d);
newmatrix = newthreshold.*rawmatrix;

end
