%% Display images in a m x n grid.
function showImages(folder,mRows,nColumns)

nImages = mRows * nColumns;
I = imread(strcat(folder,int2str(1)));
M = zeros(size(I,1),size(I,2),size(I,3),nImages,'uint8');
M(:,:,:,1) = I;

for iImage = 2:nImages
    M(:,:,:,iImage) = imread(strcat(folder,int2str(iImage)));
end

axes('Position',[0.05 -0.1 0.9 1.2]);
montage(M,'Size',[mRows nColumns]);