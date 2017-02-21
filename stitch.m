function [result] = stitch(leftI,rightI,overlap)

% 
% stitch together two grayscale images with a specified overlap
%
% leftI : the left image of size (H x W1)  
% rightI : the right image of size (H x W2)
% overlap : the width of the overlapping region.
%
% result : an image of size H x (W1+W2-overlap)
%
if (size(leftI,1)~=size(rightI,1)); % make sure the images have compatible heights
  error('left and right image heights are not compatible');
end

%Initialize height variable
h = size(leftI, 1);

%Compute cost array given by the absolute of left and right's difference
left = leftI(:, end-overlap+1:end);
right = rightI(:, 1:overlap);
cost = abs(left - right);

%Use shortest_path to find seam along which to stitch image
path = shortest_path(cost);

%Transform the path into an alpha mask for each image
image_1_alpha_stitch = ones(h,overlap);
for i = 1:h
    image_1_alpha_stitch(i, path(i)+1:end) = 0;
end
image_2_alpha_stitch = 1 - image_1_alpha_stitch;

%Compute strip with the standard equation for compositing
leftOutput = leftI(:, 1:end-overlap);
rightOutput = rightI(:, overlap+1:end);
strip = image_1_alpha_stitch.*left + image_2_alpha_stitch.*right;

%Generate output image
result = [leftOutput strip rightOutput];