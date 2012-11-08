function [fpreds] = predict_later_fusion(preds, type)

if(~exist('type','var') || isempty(type))
    type = 'avg';
end

if(strcmp(type, 'avg'))
    fpreds = squeeze(mean(preds, 1));
elseif(strcmp(type, 'geo_mean'))
    fpreds = squeeze(geomean(preds, 1));
elseif(strcmp(type, 'wmean'))
    w = repmat([1, 0.36]', [1, size(preds, 2), size(preds, 3)]);
    fpreds = squeeze(wmean(preds, w, 1));
elseif(strcmp(type, 'w_geo_mean'))
    w = repmat([1, 0.43]', [1, size(preds, 2), size(preds, 3)]);
    fpreds = squeeze(wgeomean(preds, w, 1));
else
    error('not this fusion method!');
end

end