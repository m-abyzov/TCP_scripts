function [cmp] = compareLexi(a1,a2)
% Compares two vectors lexicographically

sub = a1-a2;
[~,~,v] = find(sub);
if (isempty(v))
    cmp = 0;
elseif(v(1)>0)
    cmp = 1;
elseif(v(1)<0)
    cmp = -1;
end
end