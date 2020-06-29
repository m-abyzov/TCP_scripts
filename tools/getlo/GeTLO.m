function [order,numties,numoptions] = GeTLO(coverage,dep,file_to_save)
% Finds the orderding using the GetLO algorirhtm
% 
%coverage = load('processed_sudoku_coverage.txt');
% run as "GeTLO(load('processed_sudoku_coverage.txt'), 1)" via command
% window.

% Inputes:
%       coverage: m*n dimensional binary coverage matrix - assuming each
%       test case at least covers one entity
%       dep: the depth parameter of the GeTLO algorithm
% Outputs:
%       order: 1*m vector of ordering
%       numties: # ties 
%       numoptions: # candidates when ties occur
    



depth =dep;
numties = 0;
numoptions = 0;
order= [];


%% Initialiaze Coverage Matrix (rows indicate test cases and column idicatest blocks)


nTest = size(coverage,1);
cov = coverage;

selectedTests = zeros(size(cov,1),1); %keeps track of the traversed (selected test cases



%% map the coverage matrix into a binary matrix
cov = cov>0;

%% First choose the test case with highest weight
w = sum(cov,2);
[~,~,indx] = maxLex(w,zeros(size(cov,1),1));
indx=findunique(cov, indx);
if(size(indx,2)>1)
    [selectedTests, neworder] = ties(cov,selectedTests,depth);
    order= [order neworder'];
    numoptions = numoptions + size(indx,2);
    numties = numties + 1;
else
    selectedTests(indx) = 1;
    order = [order indx];
end
OCC = computeOCC(cov,selectedTests);




%% Main loop
while(size(order,2)<nTest)
    
    [N,CN] = computeNs(OCC); 
    w = computeWs(cov,N,OCC,CN);
    [ma,~,indx] = maxLex(w,selectedTests);
    indx=findunique(cov, indx);
    if(sum(ma) ~= 0) 
        if(size(indx,2)>1)
            numoptions = numoptions + size(indx,2);
            numties = numties + 1;
            [selectedTests,neworder] = ties(cov,selectedTests,min(depth,nTest - size(order,2))); %resolving G-ties
            order = [order neworder'];
        else
            if(indx==0)
                break;
            end
            order = [order indx];
            selectedTests(indx) = 1;
        end
        OCC = computeOCC(cov, selectedTests);
    end
    if(sum(ma) == 0)
        break
    end
end
chosen_index = find(selectedTests==1);
resi = setdiff(1:size(chosen_index,2),order); % to add remaining test case which have zeros coverages
order = [order resi];
dlmwrite(file_to_save,order)
end
%%
