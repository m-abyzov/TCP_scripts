function [N, CN] = computeNs(OCC)
%N: # of elements in each partition,
%CN: cumulative N

    temp = circshift(OCC.val',-1)';
    diff = OCC.val - temp;
    N = find(diff == -1);
    N = [N size(OCC.val,2)];
    CN = N;
    temp = N - circshift(N',1)';
    temp(1)=N(1);
    N = temp;
end