%% Initialize variables.
SIGMA = 0.02;
COLORS = ['r', 'g', 'b','y', 'm','c','k'];
MAX_PARTITIONS = 7;
SPECIAL_NUMBER_OF_PARTITIONS = 6;

%% Load points.
load points.mat points;

%% Display points.
scatter(points(:,1),points(:,2),10,'filled');
axis([0 1 0 1]);

%% Permutate points to test randomness.
nPoints = size(points,1);
permutation = randperm(nPoints);
points = points(permutation,:);

%% Generate similarity matrix.
W = squareform(exp(-pdist(points,'squaredeuclidean')/(2*SIGMA^2)));

%% Partition points for various number of partitions.
f = figure;
for nPartitions = 2:MAX_PARTITIONS
    %% Generate partition matrix.
    [~,X] = ncut(W,nPartitions);
    
    %% Sort points by partition.
    [~,I] = sortrows(X,'descend');
    pointsPartitioned = points(I,:);
    
    %% Display W and sortedW as images.
    if nPartitions == SPECIAL_NUMBER_OF_PARTITIONS
        sortedW = W(:,I);
        sortedW = sortedW(I,:);
        
        figure;
        
        leftSubplot = subplot(1,2,1);
        imagesc(W);
        axis(leftSubplot,'square');

        rightSubplot = subplot(1,2,2);
        imagesc(sortedW);
        axis(rightSubplot,'square');
        colorbar;

        leftPosition = get(leftSubplot,'position');
        leftPosition(1) = leftPosition(1) - 0.03;
        set(leftSubplot,'position',leftPosition);

        rightPosition = get(rightSubplot,'position');
        rightPosition(1) = rightPosition(1) - 0.04;
        set(rightSubplot,'position',rightPosition);

        colorbarPosition = get(colorbar, 'position');
        colorbarPosition(1) = colorbarPosition(1) + 0.01;
        colorbarPosition(3) = colorbarPosition(3) + 0.02;
        set(colorbar,'position',colorbarPosition);
        
        figure(f);
    end
    
    %% Generate splitters for pointsPartitioned.
    splitters = [0 cumsum(sum(X))];
    
    subplot(2,3,nPartitions-1);
    title(strcat('k','=',num2str(nPartitions)));
    axis([0 1 0 1]);
    hold on;
    
    %% Display partitioned points.
    for j = 1:nPartitions
        start = splitters(j)+1;
        finish = splitters(j+1);
        scatter(pointsPartitioned(start:finish,1), ...
                pointsPartitioned(start:finish,2),10,'filled',COLORS(j));
    end
end

 %% Display eigenvalues.
[s,~] = ncut(W,nPoints);

figure;
scatter((1:nPoints),s,10,'filled');
ylim([-0.5 1])
hold on;
line([0,600],[0,0],'Color','red','LineStyle','--');
hold off;
