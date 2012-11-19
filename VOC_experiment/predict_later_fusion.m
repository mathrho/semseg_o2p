function [fpreds] = predict_later_fusion(preds, type)

if(~exist('type','var') || isempty(type))
    type = 'avg';
end

if(strcmp(type, 'avg'))
    fpreds = squeeze(mean(preds, 1));
elseif(strcmp(type, 'geo_mean'))
    fpreds = squeeze(geomean(preds, 1));
elseif(strcmp(type, 'wmean'))
    %w = repmat([1, 0.4]', [1, size(preds, 2), size(preds, 3)]);
    class_weights = zeros(size(preds, 2), 2);
    class_weights(:, 1) = 1;
    class_weights(:, 2) = [0.001, 0.9, 0.4, 0.7, 0.1, 0.7, 0.001, 0.4, 0.8, 0.6, 0.5, 0.3, 0.3, 0.2, 0.5, 0.7, 0.5, 0.4, 0.2, 0.4]';
    w = repmat(class_weights', [1, 1, size(preds, 3)]);
    fpreds = squeeze(wmean(preds, w, 1));
elseif(strcmp(type, 'w_geo_mean'))
    w = repmat([1, 0.43]', [1, size(preds, 2), size(preds, 3)]);
    fpreds = squeeze(wgeomean(preds, w, 1));
else
    error('not this fusion method!');
end

end