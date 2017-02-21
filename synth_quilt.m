function output = synth_quilt(tindex,tile_vec,tilesize,overlap)
%
% synthesize an output image given a set of tile indices
% where the tiles overlap, stitch the images together
% by finding an optimal seam between them
%
%  tindex : array containing the tile indices to use
%  tile_vec : array containing the tiles
%  tilesize : the size of the tiles  (should be sqrt of the size of the tile vectors)
%  overlap : overlap amount between tiles
%
%  output : the output image

if (tilesize ~= sqrt(size(tile_vec,1)))
  error('tilesize does not match the size of vectors in tile_vec');
end

% each tile contributes this much to the final output image width 
% except for the last tile in a row/column which isn't overlapped 
% by additional tiles
tilewidth = tilesize-overlap;  

% compute size of output image based on the size of the tile map
outputsize = size(tindex)*tilewidth+overlap;

% 
% stitch each row into a separate image by repeatedly calling your stitch function
% 
preOutput = zeros(size(tindex,1)*tilesize, outputsize(2));

for i = 1:size(tindex,1)
    for j = 1:(size(tindex,2)-1)
        ioffset = (i-1)*tilesize;
        rowArea = (1:tilesize)+ioffset;
        
        if (j == 1)
            left_tile = tile_vec(:,tindex(i,j));
            left_tile = reshape(left_tile, tilesize, tilesize);
        else
            totalOverlap = (j-1)*(overlap);
            left_tile = preOutput(rowArea, 1:(tilesize*j - totalOverlap));
        end
        
        right_tile = tile_vec(:,tindex(i,j+1));
        
        right_tile = reshape(right_tile, tilesize, tilesize);
        
        tile_image = stitch(left_tile, right_tile, overlap);
        
        tile_image_X = size(tile_image, 1);
        tile_image_Y = size(tile_image, 2);
        
        preOutput(rowArea, 1:tile_image_Y) = tile_image;
    end
end

%
% now stitch the rows together into the final result 
% (I suggest calling your stitch function on transposed row 
% images and then transpose the result back)
%

preOutput = preOutput';
output = zeros(outputsize(2),outputsize(1));

for i = 1:(size(tindex,1)-1)
    currentTile = tilesize*i;
    if (i == 1)
        left_tile = preOutput(:,1:tilesize);
    else
        totalOverlap = (i-1)*overlap;
        left_tile = output(:,1:(currentTile - totalOverlap));
    end
        
    right_tile = preOutput(:,(currentTile)+1:(currentTile)+tilesize);
        
    tile_image = stitch(left_tile, right_tile, overlap);
    
    tile_image_X = size(tile_image, 1);
    tile_image_Y = size(tile_image, 2);
    
    output(1:tile_image_X, 1:tile_image_Y) = tile_image;
end


output = output';
