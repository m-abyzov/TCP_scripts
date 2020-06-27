function [next,nextOrder] = findnext(currentS,newindx,currentO)
next = repmat(currentS,1,size(newindx,2));
nextOrder = [repmat(currentO,1,size(newindx,2)); zeros(1,size(newindx,2))];
for i=1:size(newindx,2)
    next(newindx(i),i) = 1;
    nextOrder(end,i) = newindx(i);
end
end