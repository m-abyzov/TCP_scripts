function newIndx = findunique(cov,indx,columns)
if (nargin == 2)
    newcov = cov(indx,:);
else
    newcov = cov(indx,columns);
end
[ucov,uindx,~] = unique(newcov,'rows');
if(size(ucov,1)==1)
    newIndx = indx(1);
    return;
else
    newIndx = indx(uindx);
end


end