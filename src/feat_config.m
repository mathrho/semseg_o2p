function [feats, power_scaling, input_scaling_type, feat_weights, dim_div] = feat_config(feat_collection)
  feats = {
     'SIFT_GRAY_mask', ...
     'SIFT_GRAY_f_g',...
     'LBP_f', ...
     'SIFT_GRAY_mask_pca_5000_noncent', ...
     'SIFT_GRAY_f_g_pca_5000_noncent', ...
     'LBP_f_pca_2500_noncent', ...
     'Fisher_gmm_128', ...
     'eFISHER_GMM128_f_g', ...
    };
   
   idx_weights = strfind(feat_collection, '_Weights_');
   if(~isempty(idx_weights))
       str_weights = feat_collection(idx_weights(1)+9 : end);
       feat_collection(idx_weights(1) : end) = '';
   else
       str_weights = [];
   end
   
   if(strcmp(feat_collection, 'all_feats'))
       feats = feats([1 2 3]);
       power_scaling = true;
       input_scaling_type = 'norm_2';
       feat_weights = [1 1 1];
       dim_div = {[], [10296 10296], []}; % Second feature is composed of two descriptors with similar size (this is used in pca)      
   elseif(strcmp(feat_collection, 'all_feats_orig'))
       feats = feats([1 2 3]);
       power_scaling = true;
       input_scaling_type = 'norm_2';
       feat_weights = [1 1 1.5]; % save trouble   
       dim_div = {[], [10296 10296], []}; % Second feature is composed of two descriptors with similar size (this is used in pca)
    elseif(strcmp(feat_collection, 'all_feats_pca_noncent_5000'))    
       feats = feats([4 5 6]);
       power_scaling = false;
       input_scaling_type = [];
       feat_weights = [];
       dim_div = {[], [], []};
   elseif(strcmp(feat_collection, 'fisher_gmm_128'))
       feats = feats([7]);
       power_scaling = false;
       input_scaling_type = 'norm_2';
       feat_weights = [];
       dim_div = {[]};
   elseif(strcmp(feat_collection, 'eFisher_gmm_128_f_g'))
       feats = feats([8]);
       power_scaling = false;
       input_scaling_type = [];
       feat_weights = [];
       dim_div = {[]};
   elseif(strcmp(feat_collection, 'all_feats_pca_noncent_5000_Plus_fisher_gmm_128'))
       feats = feats([4 5 6 7]);
       power_scaling = false;
       input_scaling_type = 'norm_2';
       feat_weights = [];
       dim_div = {[], [], [], []};
   else
       error('no such type');
   end
   
   if(~isempty(str_weights))
       feat_weights = str2double(regexp(str_weights, '_', 'split'));
   end
end
