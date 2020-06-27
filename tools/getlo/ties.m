function [selected,selectedorder] = ties(cov,selectedTests,depth)
%resolves ties according to the given depth parameter

nTests = size(selectedTests,1);
if(depth>(nTests -numel(find(selectedTests))))
    depth = numel(find(selectedTests));
end
OCC = computeOCC(cov,selectedTests);
[N, CN] = computeNs(OCC);
W = computeWs(cov,N,OCC,CN);
[~,~,indx]=maxLex(W,selectedTests);
if(sum(sum(selectedTests)) == size(selectedTests,1))
    return;
end

[allnext2, ~] = findnext(selectedTests,indx,[]); %allnext2 keeps tracks of all the candidates
allnextorder2 = indx;
while(size(allnext2,2)~=1 && depth > 0)
    maxim = zeros(1,size(cov,2));
    for i=1:size(allnext2,2)
        OCC = computeOCC(cov,allnext2(:,i));
        [N, CN] = computeNs(OCC);
        W = computeWs(cov,N,OCC,CN);
        [~,~,indx] = maxLex(W,allnext2(:,i));
        indx = findunique(cov,indx);
        if(compareLexi(OCC.val,maxim)==-1)
            continue;
        end
        if(compareLexi(OCC.val,maxim))
            maxim = OCC.val;
            allnext = [];
            allnextorder= [];
        end
        
        [partialnext, partialnextorder] = findnext(allnext2(:,i),indx,allnextorder2(:,i));
        allnext = [allnext partialnext];
        allnextorder = [allnextorder partialnextorder];
        
    end
    [allnext2,m1,~] = unique(allnext','rows');
    allnextorder2 = allnextorder(:,m1);
    allnext2 = allnext2';
    [allnextorder2, allnext2]=choosemaxs(allnextorder2,allnext2,cov);
    allnext = [];
    allnextorder = [];
    depth = depth-1;
end
selected = allnext2(:,1);
selectedorder  = allnextorder2(:,1);

end
