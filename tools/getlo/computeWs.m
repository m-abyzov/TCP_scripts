function W = computeWs(cov,N,OCC,CN)
%Computes the wieght vectors
nBlock = size(cov,2);
cov = cov(:,OCC.per);
 summingInds = zeros(nBlock,size(N,2)); % Vectorizing the code instead of summing
 N = [0 CN];
    for j=1:(length(N)-1)
        summingInds((N(j)+1):N(j+1),j) = 1; 
    end
    W = cov*summingInds;
end
