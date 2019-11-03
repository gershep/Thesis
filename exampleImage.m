%% Initialize variables.
INPUT_FOLDER = 'images/original/';
OUTPUT_FOLDER = 'images/partitioned/';
NUMBER_OF_IMAGES = 9;
NUMBER_OF_PARTITIONS = [6 8 10 22 16 41 30 17 40];
SIGMA_1 = 0.07;
SIGMA_2 = 2.4;
MAX_DISTANCE = 10;

%% Partition images.
for iImage = 1:NUMBER_OF_IMAGES
    fprintf('    %d / %d\n',iImage,NUMBER_OF_IMAGES);
    
    %% Load image.
    I = imread(strcat(INPUT_FOLDER,int2str(iImage)));
    J = reshape(rgb2hsv(I),[],3);

    %% Initialize variables.
    mRows = size(I,1);
    nColumns = size(I,2);
    nPixels = mRows*nColumns;

    %% Generate similarity matrix.
    columnCoordinates = repmat(1:nColumns,mRows,1);
    rowCoordinates = repmat((1:mRows)',nColumns,1);
    pixelCoordinates = [rowCoordinates columnCoordinates(:)];
    pairwiseDistance = pdist(pixelCoordinates,'squaredeuclidean');
    indicesOfTooBigDistances = find(pairwiseDistance >= MAX_DISTANCE^2);
        
    pixelColorProperty = J(:,3) .* ...
        [ones(nPixels,1) J(:,2).*sin(J(:,1)) J(:,2).*cos(J(:,1))];
    pairwiseColorSimilarity = pdist(pixelColorProperty,'squaredeuclidean');

    pairwiseSimilarity = exp(-pairwiseDistance/(2*SIGMA_2^2) - ...
                              pairwiseColorSimilarity/(2*SIGMA_1^2));

    clearvars pairwiseDistance pairwiseColorSimilarity

    pairwiseSimilarity(indicesOfTooBigDistances) = 0;
    W = sparse(squareform(pairwiseSimilarity));

    clearvars indicesOfTooBigDistances pairwiseSimilarity

    %% Generate partition matrix.
    [~,X] = ncut(W,NUMBER_OF_PARTITIONS(iImage));

    %% Generate boundaries.
    [pixelPartition,~] = find(X');
    Y = reshape(pixelPartition,[mRows,nColumns]);
    partitionComparison = (Y == [Y(:,2:nColumns) Y(:,nColumns)]) .* ...
                          (Y == [Y(:,1) Y(:,1:nColumns-1)]) .* ...
                          (Y == [Y(2:mRows,:); Y(mRows,:)]) .* ...
                          (Y == [Y(1,:); Y(1:mRows-1,:)]);

    boundaries = find(~partitionComparison(:));
    
    %% Save partitioned image.
    I = reshape(I,[],3);
    I(boundaries,:) = repmat([255 0 0],numel(boundaries),1);
    I = reshape(I,mRows,nColumns,3);
    imwrite(I,strcat(OUTPUT_FOLDER,int2str(iImage)),'png');
end

%% Display images before and after partitioning.
showImages(INPUT_FOLDER,3,3);
figure;
showImages(OUTPUT_FOLDER,3,3);
