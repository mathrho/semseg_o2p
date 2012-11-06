%% Visualize Masks

%% Visualize CPMC
[filpat, filnam, filext] = fileparts(files(i).name) ;
I = imread(['/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/JPEGImages/' filnam '.jpg']) ;
Id = imresize(I, size(var.ucm2)) ;

figure
tt = 25 ;
for qq = tt + 1 : tt + 25
subplot(5, 5, qq - tt) ; 
I2 = I ;
msk = masks(:, :, qq) ;
[fr, fc] = find(msk) ;
ix = sub2ind(size(I), fr, fc, 2 * ones(numel(fr), 1)) ;
I2(ix) = I2(ix) + 50 ;
imshow(I2, []) ;
drawnow
end

[filpat, filnam, filext] = fileparts(files(i).name) ;
I = imread(['/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/JPEGImages/' filnam '.jpg']) ;
Id = imresize(I, size(var.ucm2)) ;

%%
% figure
% imshow(I)

I = imread(imfilnam) ;
Id = imresize(I, size(cpmc.ucm2)) ;

figure
imshow(Id, []) ;
hold on
[fr, fc] = find(cpmc.ucm2 > 0) ;
plot(fc, fr, 'r.') ;

figure
imshow(labels2, []) ;

figure
imshow(new_mask, []) ;

figure
for qq = 1 : 100
subplot(10, 10, qq) ; 
I2 = I ;
msk = masks(:, :, qq) ;
[fr, fc] = find(msk) ;
ix = sub2ind(size(I), fr, fc, 2 * ones(numel(fr), 1)) ;
I2(ix) = I2(ix) + 50 ;
imshow(I2, []) ;
drawnow
end

figure
for qq = 101 : 150
subplot(7, 8, qq - 100) ; 
I2 = I ;
msk = masks(:, :, qq) ;
[fr, fc] = find(msk) ;
ix = sub2ind(size(I), fr, fc, 2 * ones(numel(fr), 1)) ;
I2(ix) = I2(ix) + 50 ;
imshow(I2, []) ;
drawnow
end


figure
imshow(msk, []) ;


figure
imshow(I, []) ;
hold on
[fr, fc] = find(sp > 0) ;
plot(fc, fr, 'r.') ;

figure
imshow(sp, []) 

figure
imshow(ld.masks, []) 

I3 = I ;
[fr, fc] = find(sp_app) ;
I3(fr, fc, 2) = I3(fr, fc, 2) + 50 ;

figure
imshow(I3)

figure
imshow(I2)
