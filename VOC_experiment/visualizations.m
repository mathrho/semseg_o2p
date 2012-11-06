files = dirrec('/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/results/VOC2012/Segmentation/all_gt_segm_minus_val11_all_feats_pca_noncent_5000_Plus_fisher_gmm_128_3.000000_val11_cls/') ;
files2 = dirrec('/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/results/VOC2012/Segmentation/all_gt_segm_minus_val11_all_feats_pca_noncent_5000_3.000000_val11_cls/') ;
imfiles = dirrec('/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/JPEGImages/') ;

cmap = colormap(lines(20)) ;
close

figure
for i = 1 : numel(files)
    [filpat, filnam, filext] = fileparts(files{i}) ;
    
    realim = imread(['/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/JPEGImages/' filnam '.jpg']) ;
    m1 = double(imread(files{i})) ;
    m2 = double(imread(files2{i})) ;
    
    b2 = bwboundaries(m2) ;
    
    clf
    
    subplot(2, 2, 1) ;
    imshow(realim) ;
    
    subplot(2, 2, 2) ;
    imshow(realim, []) ;
    hold on
    for c = 1 : 20
        tempm = m1 == c ;
        bnd = bwboundaries(tempm) ;
        if isempty(bnd); continue; end ;
        plot(bnd{1}(:, 2), bnd{1}(:, 1), 'color', cmap(c, :), 'LineWidth', 3) ;
        text(mean(bnd{1}(:, 2)), mean(bnd{1}(:, 1)), VOCopts.classes{c}, 'Color', cmap(c, :), 'FontSize', 14, 'FontWeight', 'bold') ;
    end
    
    subplot(2, 2, 3) ;
    imshow(realim, []) ;
    hold on
    for c = 1 : 20
        tempm = m2 == c ;
        bnd = bwboundaries(tempm) ;
        if isempty(bnd); continue; end ;
        plot(bnd{1}(:, 2), bnd{1}(:, 1), 'color', cmap(c, :), 'LineWidth', 3) ;
        text(mean(bnd{1}(:, 2)), mean(bnd{1}(:, 1)), VOCopts.classes{c}, 'Color', cmap(c, :), 'FontSize', 14, 'FontWeight', 'bold') ;
    end
    
    pause
end
