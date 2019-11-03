%% Initialize variables.
MU = [2 0.2];
SIGMA_MATRIX = diag([0.01 0.01]);
EPSILON = 0.05;
SIGMA = 0.04;
NUMBER_OF_PARTITIONS = 2;

nPointsFirst = 1000;
nPointsSecond = 1000;
nPoints = nPointsFirst + nPointsSecond;

%% Generate points.
pointsNormal = mvnrnd(MU,SIGMA_MATRIX,nPointsFirst); 
pointsUniform = rand(nPointsSecond,2)*diag([6 -EPSILON]);

%% Display points.
subplot(1,2,1);
scatter(pointsNormal(:,1),pointsNormal(:,2),5,'filled','r');
hold on;
scatter(pointsUniform(:,1),pointsUniform(:,2),5,'filled','b');
hold off;
axis([0 6 -0.5 0.7]);

%% Permutate points to test randomness.
points = [pointsNormal; pointsUniform];
permutation = randperm(nPoints);
points = points(permutation,:);

%% Generate similarity matrix.
W = squareform(exp(-pdist(points,'squaredeuclidean')/(2*SIGMA^2)));

%% Generate partition matrix.
[~,X] = ncut(W,NUMBER_OF_PARTITIONS);

%% Sort points by partition.
[~,I] = sortrows(X,'descend');
points = points(I,:);

%% Display partitioned points.
nPointsFirst = sum(X(:,1));

subplot(1,2,2);
scatter(points(1:nPointsFirst,1),points(1:nPointsFirst,2),5,'filled','r');
hold on;
scatter(points(nPointsFirst+1:end,1), ...
        points(nPointsFirst+1:end,2),5,'filled','b');
hold off;
axis([0 6 -0.5 0.7]);
