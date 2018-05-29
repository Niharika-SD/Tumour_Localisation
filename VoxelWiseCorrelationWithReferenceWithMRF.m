
function [finalAtlas,finalRef] = VoxelWiseCorrelationWithReferenceWithMRF(atlas,rsData,refSignals,stopcriteria,beta,iterations,indexs)

%assume that firstMembership is a 902629x1 vector indexed in the way
%suggested by indexs

networks = size(refSignals,1);
x = size(rsData,1);
y = size(rsData,2);
z = size(rsData,3);
time = size(rsData,4);
reshapedRs = zeros(x*y*z,time);
reshapedAtlas = zeros(x*y*z,1);
assignment = zeros(x*y*z, iterations);

countInitial = 1;


for i = 1:x
    for j = 1:y
        for k = 1:z
            
            %reshapedAtlas is used for first membership calculation
            
            reshapedAtlas(countInitial) = atlas(i,j,k);
            reshapedRs(countInitial,:) = rsData(i,j,k,:);
            countInitial = countInitial+1;
            
        end
    end
end
assignment(:,1) = reshapedAtlas;

for iter = 1:iterations-1
    fprintf('Im alive! iter %d',iter)
    for i = 1:x*y*z
        if mod(i,2) == 1
            center = assignment(i,iter);
            if center ~= 0
                timeSeries = reshapedRs(i,:);               
                count = 1;
                neighbors = [];
                ne1 =assignment(i+1,iter);
                ne2 =assignment(i-1,iter);
                ne3 =assignment(i+91,iter);
                ne4 =assignment(i-91,iter);
                ne5 =assignment(i+9919,iter);
                ne6 =assignment(i-9919,iter);
                if ne1 ~= 0
                    neighbors(count) = ne1;
                    count = count+1;
                end
                if ne2 ~= 0
                    neighbors(count) = ne2;
                    count = count+1;
                end
                if ne3 ~= 0
                    neighbors(count) = ne3;
                    count = count+1;
                end
                if ne4 ~= 0
                    neighbors(count) = ne4;
                    count = count+1;
                end
                if ne5 ~= 0
                    neighbors(count) = ne5;
                    count = count+1;
                end
                if ne6 ~= 0
                    neighbors(count) = ne6;
                    count = count+1;
                end
                if count == 1
                    assignment(i,iter+1) = 0;
                else
                    
                    neighborNetworks = unique(neighbors);
                    prob = [];


                    for n = 1:length(neighborNetworks)
                        net = neighborNetworks(n);
                        if net > 0 && mod(net,1) == 0

                        power = length(find(neighbors == net));
                        prob(n,1) = net;
                        number = (1+exp(-(beta + power)))^(-1);
                        prob(n,2) = number;
                        refUse = refSignals(net,:);
                        correlation = corr2(timeSeries,refUse);
                        prob(n,3) = number*correlation;
                        end


                    end
                    if isempty(prob)
                        assignment(i,iter+1) = 0;
                    else
                    

                    [~,ind] = max(prob(:,3));
                    assignment(i,iter+1) = prob(ind,1);
                    end

                end
            end
        end
    end
    
    for i = 1:x*y*z
        if mod(i,2) == 0
            center = assignment(i,iter);
            if center ~= 0
                timeSeries = reshapedRs(i,:);
                count = 1;
                neighbors = [];
                ne1 =assignment(i+1,iter);
                ne2 =assignment(i-1,iter);
                ne3 =assignment(i+91,iter);
                ne4 =assignment(i-91,iter);
                ne5 =assignment(i+9919,iter);
                ne6 =assignment(i-9919,iter);
                if ne1 ~= 0
                    neighbors(count) = ne1;
                    count = count+1;
                end
                if ne2 ~= 0
                    neighbors(count) = ne2;
                    count = count+1;
                end
                if ne3 ~= 0
                    neighbors(count) = ne3;
                    count = count+1;
                end
                if ne4 ~= 0
                    neighbors(count) = ne4;
                    count = count+1;
                end
                if ne5 ~= 0
                    neighbors(count) = ne5;
                    count = count+1;
                end
                if ne6 ~= 0
                    neighbors(count) = ne6;
                    count = count+1;
                end
                if count == 1
                    assignment(i,iter+1) = 0;
                else
                      
                    
                    neighborNetworks = unique(neighbors);
                    prob = [];


                    for n = 1:length(neighborNetworks)
                        net = neighborNetworks(n);
                        if net > 0 && mod(net,1) == 0

                        power = length(find(neighbors == net));
                        prob(n,1) = net;
                        number = (1+exp(-(beta + power)))^(-1);
                        prob(n,2) = number;
                        refUse = refSignals(net,:);
                        correlation = corr2(timeSeries,refUse);
                        prob(n,3) = number*correlation;
                        end


                    end
                    if isempty(prob)
                        assignment(i,iter+1) = 0;
                    else
                    

                    [~,ind] = max(prob(:,3));
                    assignment(i,iter+1) = prob(ind,1);
                    end
                end
            end
        end
    end
end

%now last column of assignment = membership for that iteration, then use
%this to recalculate ref signals. Membership is a value between 0 and 1.
%Last columb of assignment = newest steady state membership

newAtlas = assignment(:,iterations);
for i = 1:networks
    networkCoordinate = find(newAtlas == i);
    timeCourses = reshapedRs(networkCoordinate,:);
    refSignals(i,:) = mean(timeCourses,1);
end

membership = CalculateMembershipMRF(newAtlas,reshapedAtlas);


runCounts = 0;
while membership < stopcriteria && runCounts < 40
    runCounts = runCounts+1;
    fprintf('Run Counts: %d \n ',runCounts)
    oldAtlas = newAtlas;
    assignment = zeros(x*y*z, iterations);
    assignment(:,1) = oldAtlas;
    
    for iter = 1:iterations-1
        fprintf('Im alive, still! iter %d',iter)
        for i = 1:x*y*z
            if mod(i,2) == 1
                center = assignment(i,iter);
                if center ~= 0
                    timeSeries = reshapedRs(i,:);
                    count = 1;
                    neighbors = [];
                    ne1 =assignment(i+1,iter);
                    ne2 =assignment(i-1,iter);
                    ne3 =assignment(i+91,iter);
                    ne4 =assignment(i-91,iter);
                    ne5 =assignment(i+9919,iter);
                    ne6 =assignment(i-9919,iter);
                    if ne1 ~= 0
                        neighbors(count) = ne1;
                        count = count+1;
                    end
                    if ne2 ~= 0
                        neighbors(count) = ne2;
                        count = count+1;
                    end
                    if ne3 ~= 0
                        neighbors(count) = ne3;
                        count = count+1;
                    end
                    if ne4 ~= 0
                        neighbors(count) = ne4;
                        count = count+1;
                    end
                    if ne5 ~= 0
                        neighbors(count) = ne5;
                        count = count+1;
                    end
                    if ne6 ~= 0
                        neighbors(count) = ne6;
                        count = count+1;
                    end
                    if count == 1
                        assignment(i,iter+1) = 0;
                    else
                        
                        neighborNetworks = unique(neighbors);
                    prob = [];

                    for n = 1:length(neighborNetworks)
                        net = neighborNetworks(n);
                        if net > 0 && mod(net,1) == 0

                        power = length(find(neighbors == net));
                        prob(n,1) = net;
                        number = (1+exp(-(beta + power)))^(-1);
                        prob(n,2) = number;
                        refUse = refSignals(net,:);
                        correlation = corr2(timeSeries,refUse);
                        prob(n,3) = number*correlation;
                        end


                    end
                    if isempty(prob)
                        assignment(i,iter+1) = 0;
                    else
                    

                    [~,ind] = max(prob(:,3));
                    assignment(i,iter+1) = prob(ind,1);
                    end
                    end
                end
            end
        end
        
        for i = 1:x*y*z
            if mod(i,2) == 0
                center = assignment(i,iter);
                if center ~= 0
                    timeSeries = reshapedRs(i,:);
                    count = 1;
                    neighbors = [];
                    ne1 =assignment(i+1,iter);
                    ne2 =assignment(i-1,iter);
                    ne3 =assignment(i+91,iter);
                    ne4 =assignment(i-91,iter);
                    ne5 =assignment(i+9919,iter);
                    ne6 =assignment(i-9919,iter);
                    if ne1 ~= 0
                        neighbors(count) = ne1;
                        count = count+1;
                    end
                    if ne2 ~= 0
                        neighbors(count) = ne2;
                        count = count+1;
                    end
                    if ne3 ~= 0
                        neighbors(count) = ne3;
                        count = count+1;
                    end
                    if ne4 ~= 0
                        neighbors(count) = ne4;
                        count = count+1;
                    end
                    if ne5 ~= 0
                        neighbors(count) = ne5;
                        count = count+1;
                    end
                    if ne6 ~= 0
                        neighbors(count) = ne6;
                        count = count+1;
                    end
                    if count == 1
                        assignment(i,iter+1) = 0;
                    else
                        
                    neighborNetworks = unique(neighbors);
                    prob = [];


                   for n = 1:length(neighborNetworks)
                        net = neighborNetworks(n);
                        if net > 0 && mod(net,1) == 0

                        power = length(find(neighbors == net));
                        prob(n,1) = net;
                        number = (1+exp(-(beta + power)))^(-1);
                        prob(n,2) = number;
                        refUse = refSignals(net,:);
                        correlation = corr2(timeSeries,refUse);
                        prob(n,3) = number*correlation;
                        end


                    end
                    if isempty(prob)
                        assignment(i,iter+1) = 0;
                    else
                    

                    [~,ind] = max(prob(:,3));
                    assignment(i,iter+1) = prob(ind,1);
                    end
                    end
                end
            end
        end
    end
    
    newAtlas = assignment(:,iterations);
    for i = 1:networks
        networkCoordinate = find(newAtlas == i);
        timeCourses = reshapedRs(networkCoordinate,:);
        refSignals(i,:) = mean(timeCourses,1);
    end
    membership = CalculateMembershipMRF(oldAtlas,newAtlas);
    
end

finalRef = refSignals;
finalAtlas = zeros(x, y, z);

for i = 1:x*y*z
    coordinates = indexs(i,:,:,:);
    X = coordinates(1);
    Y = coordinates(2);
    Z = coordinates(3);
    finalAtlas(X,Y,Z) = newAtlas(i);
end

end