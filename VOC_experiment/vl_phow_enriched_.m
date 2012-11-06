function [frames, esift] = vl_phow_enriched_(varargin)

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
imlab = RGB2Lab(im) ;
imlab(:, :, 1) = imlab(:, :, 1) ./ 100 ;
imlab(:, :, 2) = (imlab(:, :, 2) + 110) ./ (110 + 110) ;
imlab(:, :, 3) = (imlab(:, :, 3) + 110) ./ (110 + 110) ;
imlab = single(imlab * 255) ;

%% NORMAL SIFT
% imgray = rgb2gray(im) ;
varargin{1} = single(rgb2gray(im)) ;
[frames, sift] = vl_phow(varargin{:}) ;


%% CONCATENATE EVERYTHING
ix1 = sub2ind(size(imrgb), frames(2, :), frames(1, :), 1 * ones(1, size(frames, 2))) ;
ix2 = sub2ind(size(imrgb), frames(2, :), frames(1, :), 2 * ones(1, size(frames, 2))) ;
ix3 = sub2ind(size(imrgb), frames(2, :), frames(1, :), 3 * ones(1, size(frames, 2))) ;

rgbval1 = imrgb(ix1) ; rgbval2 = imrgb(ix2) ; rgbval3 = imrgb(ix3) ;
hsvval1 = imhsv(ix1) ; hsvval2 = imhsv(ix2) ; hsvval3 = imhsv(ix3) ;
labval1 = imlab(ix1) ; labval2 = imlab(ix2) ; labval3 = imlab(ix3) ;

esift = [single(sift); ...
    rgbval1; rgbval2; rgbval3; ...
    hsvval1; hsvval2; hsvval3; ...
    labval1; labval2; labval3] ;


