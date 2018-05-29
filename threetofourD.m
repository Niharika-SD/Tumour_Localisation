function a = threetofourD(threshold,d)

x = size(threshold,1);
y = size(threshold,2);
z = size(threshold,3);
a = zeros(x,y,z,d);

for A = 1:x
    for B = 1:y
        for C = 1:z
            for  D = 1:d
                a(A,B,C,D) = threshold(A,B,C);
            end
        end
    end
end
end
