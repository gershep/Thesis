%% Calculates the partition matrix.
% s ... eigenvalues
% Xstar ... partition matrix
function [s,Xstar] = ncut(W, k) 

%% Degree matrix D initialization.
D = sqrt(sum(W,2)); 
if (~all(D))
    error('Similarity matrix W has a zero row!')
end

%% Partial eigendecomposition.
W = W./(D*D');
[V,S,flag] = eigs(W,k,'LA');
s = diag(S);
if flag
    error('Not all eigenvalues converged!')
end

%% Row normalization.
Xtilde= normr(V);

%% Orthogonal matrix Q initialization.
mRows = size(Xtilde,1);
unusedRows = true(mRows,1);
c = zeros(mRows,1);
Q = zeros(k,k);

for jColumn = 1:k 
    if jColumn == 1
        rowIndex = randsample(mRows,1);
    else
        c = c + abs(Xtilde*Q(:,jColumn-1)); 
        rowIndex = find(c==min(c(unusedRows)), 1);
    end
    Q(:,jColumn) = Xtilde(rowIndex,:)';
    unusedRows(rowIndex) = false;
end 

%% Convergence parameters initialization.
eOld = 0; 
eNew = 1;

%% Discretization.
while abs(eNew-eOld) > eps
    Xstar = zeros(mRows,k);
    Xtemp = Xtilde*Q;
    [~,indices] = max(Xtemp, [], 2); 
    Xstar(sub2ind(size(Xstar),(1:mRows)',indices)) = 1;
    [U,Sigma,V] = svd(Xstar'*Xtilde); 
    eOld = eNew;
    eNew = trace(Sigma); 
    Q = V * U'; 
end

%% If Xstar is singular, make a correction.
alpha = 0.001;
while rank(Xstar) ~= k
    zeroColumns = find(all(Xstar==0));
    for jColumn = zeroColumns
        rows = abs(Xtemp(:,jColumn) - ...
                   Xtemp(sub2ind(size(Xtemp),(1:mRows)',indices))) < alpha;
        indices(rows) = jColumn;
    end
    alpha = alpha + 0.001;
    Xstar = zeros(mRows,k);
    Xstar(sub2ind(size(Xstar),(1:mRows)',indices)) = 1;
end
