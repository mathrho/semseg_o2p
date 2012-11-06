function [frames, esift] = vl_phow_enriched(varargin)

im = varargin{1} ;
if ndims(im) ~= 3
    error('Image should be in color.') ;
end

%% SINCE SIFT IS in [0, 255], we retain the [0, 255] scale of the color space
imrgb = single(varargin{1}) ;
% imrgb = imrgb ./ 255 ; 

%% HSV values
%% SINCE SIFT IS in [0, 255], we retain the [0, 255] scale of the color space
imhsv = rgb2hsv(im) ;
imhsv = single(imhsv) * 255 ;

%% LAB values
%% SINCE SIFT IS in [0, 255], we scale to [0, 255]
imlab = rgb2lab(im) ;
imlab(:, :, 1) = imlab(:, :, 1) ./ 100 ;
imlab(:, :, 2) = (imlab(:, :, 2) + 110) ./ (110 + 110) ;
imlab(:, :, 3) = (imlab(:, :, 3) + 110) ./ (110 + 110) ;
imlab = single(imlab * 255) ;

%% NORMAL SIFT
% imgray = rgb2gray(im) ;
varargin{1} = single(rgb2gray(im)) ;
[frames, sift] = vl_phow(varargin{:}) ;


%% CONCATENATE EVERYTHING
rgbval = mean_nb_I(imrgb, frames(2,:), frames(1,:), 0);
hsvval = mean_nb_I(imhsv, frames(2,:), frames(1,:), 0); 
labval = mean_nb_I(imlab, frames(2,:), frames(1,:), 0);

esift = [single(sift); rgbval; hsvval; labval] ;
