function FeatsMatrix = repmatWithDivision(FeatsMatrix, vc)

% nrow = size(FeatsMatrix, 1) ;
% 
% divs = 4 ;
% nrow10 = floor(nrow / divs) ;
% rem = mod(nrow, nrow10) ;
% nrows = nrow10 * ones(1, floor(nrow / nrow10)) ;
% 
% if rem ~= 0
%     nrows = [nrows, rem] ;
% end
% 
% for c = 1 : divs
%     ix = (c - 1) * nrows(c) + 1 : c * nrows(c) ;
%     FeatsMatrix(ix, :)  = FeatsMatrix(ix, :) ./ (repmat(vc, nrows(c), 1)+eps);
% end

for i = 1 : size(FeatsMatrix, 1)
    FeatsMatrix(i, :) = FeatsMatrix(i, :) ./ vc ;
end


