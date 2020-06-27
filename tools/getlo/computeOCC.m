function [ OCC ] = computeOCC(cov, selectedTests)
%Computes the occ vectors
if(numel(find(selectedTests))==1)
    temp = cov(logical(selectedTests),:);
else
    temp = sum(cov(logical(selectedTests),:));
end
    [OCC.val, OCC.per] = sort(temp);
end

