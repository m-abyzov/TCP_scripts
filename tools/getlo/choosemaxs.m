function [allnextorder2, allnext2] = choosemaxs(allnextorder, allnext,cov)
%finds the coverage vector with the highest lexicographical rank among  the
%candidates
allnextorder2 = allnextorder(:,1);
allnext2 = allnext(:,1);
OCC = computeOCC(cov,allnext(:,1));
max = OCC.val;
for i=2:size(allnextorder,2)
    OCC = computeOCC(cov,allnext(:,i));
    if(compareLexi(OCC.val,max))
        allnext2 = allnext(:,i);
        allnextorder2 = allnextorder(:,i);
        max = OCC.val;
    elseif(compareLexi(OCC.val,max)==0)
        allnext2 = [allnext2 allnext(:,i)];
        allnextorder2 = [allnextorder2 allnextorder(:,i)];
    end
end
end