%% Train GMM model for 128 Gaussians
%% From /home/gavves/u015425_orig/projects/matlab/mine/fisherNet/sandbox.m

model.ss = 1 ;
model.nPCADims = 64 ;
model.numWords = 128 ;
model.kmeansType = 'vlkmeans' ;
model.gmmfilename = 'vocgmm128_voc2011.bin' ;

%%%%%%%% how many images and how many descriptors to use for generating the codebook?
imdir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/JPEGImages' ;
files = textread('/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/ImageSets/Main/train.txt', '%s') ;
files = vl_subset(files, 100) ;

nClusterData = 100000 ;
nFeatsPerIm = ceil(nClusterData / numel(files)) + 1 ;
samplesift = zeros(128, nFeatsPerIm * numel(files)) ;

cnt = 1 ;
for i = 1 : numel(files)
    eta(i, numel(files)) ;
    imname = fullfile([imdir '/' files{i} '.jpg']) ;
    im = imreadgray(imname) ;
    [frames, sift] = vl_phow(single(im), 'Step', model.ss) ;
    samplesift(:, cnt : cnt + nFeatsPerIm - 1) = single(vl_colsubset(sift, nFeatsPerIm)) ;
    cnt = cnt + nFeatsPerIm ;
end

save -v7.3 samplesift_voc2011.mat samplesift

load samplesift_voc2011

sift = samplesift ;
sift = sift(:, sum(sift, 1) ~= 0) ;
sift = normalizeColsL2(double(sift)) ;
[X, map] = netpca(double(sift'), model.nPCADims) ;
sift = map' * sift ;
model.pcamap = map ;

vocab = vl_kmeans(sift, model.numWords, 'verbose', 'algorithm', 'elkan') ;
[drop, binsa] = min(vl_alldist(single(vocab), single(sift)), [], 1) ;
computeGmmForFisher(model.gmmfilename, sift, vocab, binsa)

save('-v7.3', '/home/gavves/u015425/projects/matlab/mine/fisherNet/voc2011_model-128GMM.mat', 'model') ;

%% Read from directories
im_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/JPEGImages/' ;
im_test_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/Test/VOCdevkit/VOC2011/JPEGImages/' ;
cpmc_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/cpmc_segms_150/' ;
masks_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/MySegmentsMat/CPMC_segms_150_sp_approx/' ;

%% Save to directory
fish_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/MyFisherMat/CPMC_segms_150_sp_approx/gmm128' ;

load('/home/gavves/u015425/projects/matlab/mine/fisherNet/voc2011_model-128GMM.mat') ;
model.ss = 1 ;

%% Run this code to extract features from CPMC regions
cpmc_files = dir([cpmc_dir '*.mat']);
masks_files = dir([masks_dir '*.mat']);

% cpmc_files = cpmc_files(6501 : end) ;
% masks_files = masks_files(6501 : end) ;

s = RandStream('mt19937ar','Seed','shuffle');
RandStream.setGlobalStream(s);
cpmc_files = shuffle(cpmc_files) ;

for i = 1 : numel(cpmc_files)
    eta(i, numel(cpmc_files)) ;
    
    if exist([fish_dir '/' cpmc_files(i).name], 'file')
        continue ;
    end
    
    filnam = cpmc_files(i).name(1:end-4) ;
    if exist([im_dir '/' filnam '.jpg'], 'file')
        imfilnam = [im_dir '/' filnam '.jpg'] ;
    elseif exist([im_test_dir '/' filnam '.jpg'], 'file')
        imfilnam = [im_test_dir '/' filnam '.jpg'] ;
    else
        disp('Problem here...') ;
    end
    
    im = imread(imfilnam) ;
        
    %% Load CPMC regions for the current image
    msk = load([masks_dir '/' cpmc_files(i).name]) ;
    
    %% Define superpixel structure
    clear spix
    spix.superpixelmethod = 'CPMC' ;
    spix.spmap = double(msk.sp) ;
    
    %% Extract Fisher Vector
    [dummy, dummy, dummy, fishCPMC, nfeatspersp] = fisher_net_superpixels( im, spix, model, 'nonorm' ) ;
    fishCPMC = single(fishCPMC) ;
    
    %% Combine Fisher Vectors from CPMC to get Fisher Vectors for the Figure Ground hypotheses
    fish = zeros(size(fishCPMC, 1), size(msk.sp_app, 2), 'single') ;
    for q = 1 : size(msk.sp_app, 2)
        nfeats = sum(nfeatspersp(msk.sp_app(:, q))) ;
        fish(:, q) = sum(fishCPMC(:, msk.sp_app(:, q)), 2) ./ nfeats ;
    end
    
    %% Save Fisher vectors from Figure Ground hypotheses
    save('-v7.3', [fish_dir '/' cpmc_files(i).name], 'fish') ;
    
end



%% Read from directories
im_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/JPEGImages/' ;
im_test_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/Test/VOCdevkit/VOC2011/JPEGImages/' ;
gtmasks_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/MySegmentsMat/ground_truth_sp_approx/' ;
% gtmasks_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/MySegmentsMat/ground_truth/' ;
exp_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/' ;

%% Save to directory
fishgt_dir = '/home/gavves/local/projects/matlab/notmine/o2p-release1/VOC_experiment/VOC/MyFisherMat/ground_truth_sp_approx/gmm128' ;

%% Define variables
load('/home/gavves/u015425/projects/matlab/mine/fisherNet/voc2011_model-128GMM.mat') ;
model.ss = 1 ;
gt_imgsets = {'all_gt_segm_mirror', 'all_gt_segm'};

%% Run this code to extract features from CPMC regions
s = RandStream('mt19937ar','Seed','shuffle');
RandStream.setGlobalStream(s);

for qq = 1 : numel(gt_imgsets)

img_names = textread([exp_dir 'ImageSets/Segmentation/' gt_imgsets{qq} '.txt'], '%s');
img_names = shuffle(img_names) ;

for i = 1 : numel(img_names)
    eta(i, numel(img_names)) ;
    
    img_name = img_names{i};
    filename_to_save = [fishgt_dir '/' img_name '.mat'];
    
    if exist(filename_to_save, 'file')
        continue ;
    end

    imfilnam = [im_dir '/' img_name '.jpg'];    
    im = imreadgray(imfilnam) ;
    
    [frames, sift] = vl_phow(single(im), 'Step', model.ss) ;
    nzix = sum(sift, 1) ~= 0;     % OPTIONAL
    sift = sift(:, nzix); % OPTIONAL, although if there are too many 0 vectors, performance decreases significantly
    sift = normalizeColsL2(double(sift)); % OPTIONAL
    sift = model.pcamap' * sift;
    frames = frames(:, nzix);
        
    %% Load CPMC regions for the current image
    msk = load([gtmasks_dir '/' img_name '.mat']) ;
    pbmsk = load([exp_dir 'PB/'  img_name '_PB.mat']) ;
    
    %% Extract Fisher Vectors per mask
    fish = zeros(2 * 128 * 64, size(msk.masks, 3), 'single') ;
    for dd = 1 : size(msk.masks, 3)
        
        segim = msk.masks(:, :, dd) ;
        ix = logical(segim(sub2ind(size(segim), frames(2, :), frames(1, :)))) ;
        segsift = sift(:, ix) ;
        fish(:, dd) = fisher(model.gmmfilename, segsift) ;
        
    end
    fish = single(fish) ;
    
    %% Save Fisher vectors from Figure Ground hypotheses
    save('-v7.3', [fishgt_dir '/' img_name '.mat'], 'fish') ;
    
end

end

%% Visualize masks
im = imread(imfilnam) ;

figure
subplot(2, 1, 1)
imshow(im, []) ;
subplot(2, 1, 2)
imshow(msk.sp, []) ;

figure
tt = 6 * 25 ;
for qq = tt + 1 : tt + 25
subplot(5, 5, qq - tt) ; 
I2 = im ;
msk2 = msk.masks(:, :, qq) ;
[fr, fc] = find(msk2) ;
ix = sub2ind(size(im), fr, fc, 2 * ones(numel(fr), 1)) ;
I2(ix) = I2(ix) + 50 ;
imshow(I2, []) ;
drawnow
end

%% Visualize GT masks
im = imread(imfilnam) ;

figure
subplot(2, 1, 1)
imshow(im, []) ;
subplot(2, 1, 2)
I2 = im ;
[fr, fc] = find(msk.masks(:, :, 1)) ;
ix = sub2ind(size(im), fr, fc, 2 * ones(numel(fr), 1)) ;
I2(ix) = I2(ix) + 50 ;
imshow(I2, []) ;

im = imread(imfilnam) ;

figure
subplot(2, 1, 1)
imshow(im, []) ;
subplot(2, 1, 2)
imshow(im, []) ;
hold on
plot(frames(1, ix), frames(2, ix), 'r.')