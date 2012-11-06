function mat = shuffle(mat)

xxx = randperm(numel(mat)) ;
mat = mat(xxx) ;
