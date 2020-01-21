function [rdf_labels, im_all_in_focus] = RDF_DFF(pathval, regexp, i_start, numimg, show_fig, resize, use_parallel, use_rdf_agg, use_fast_jwmf, saveimg)

%% add modules
addpath(genpath('DfF'));

%% some variables
if ~exist('show_fig','var')
    show_fig = true;
end
if ~exist('resize','var')
    resize = 0.5;
end
if ~exist('use_parallel','var')
    use_parallel = true;
end
if ~exist('use_rdf_agg','var')
    use_rdf_agg = false;
end
if ~exist('use_fast_jwmf','var')
    use_fast_jwmf = false;
end
if ~exist('saveimg','var')
    saveimg = 0;
end

%% load images
imgs = cell(1,numimg);
imgarr = cell(1,numimg);
maskarr = cell(1,numimg);
for i = 1:numimg
    imgs{i} = imresize(imread(fullfile(pathval, sprintf(regexp, i + i_start - 1))), 0.5);
    imgarr{i} = im2double(imgs{i});
    maskarr{i} = ones(size(imgs{i}(:, :, 1)));
end

%% homography align images
[imgarr, maskarr, ~] = homographyAlign(imgs, resize, numimg, pathval, saveimg);

%% calculate focus
focrdf = RDFCalcFoc( imgarr, maskarr, 1, 2, 2, numimg );
[~, rdflabel] = max(focrdf, [], 3);
aifrdf = imgLabel(rdflabel, imgarr, numimg);
if show_fig
    figure; imagesc(rdflabel); title('Label initial RDF');
end

%% aggregate cost
if use_parallel
    delete(gcp);
    pool = parpool;
    if use_rdf_agg
        addAttachedFiles(pool,'guided_rdf.m')
    else
        addAttachedFiles(pool,'fastguidedfilter_color.m')
    end
end
tic
param.eps = 0.001;
if use_rdf_agg
    param.r.r = 10;
    param.r.t = 5;
    param.r.d = 0.5;
    if use_parallel
        [rdfagg] = CostAggRDF_par(focrdf, im2double(aifrdf), param);
    else
        [rdfagg] = CostAggRDF(focrdf, im2double(aifrdf), param);
    end
else
    param.r = 10;
    if use_parallel
        [rdfagg] = CostAggGuided_par(focrdf, im2double(aifrdf), param);
    else
        [rdfagg] = CostAggGuided(focrdf, im2double(aifrdf), param);
    end
end
toc

[~, rdfagglabel] = max(rdfagg, [], 3);
aifrdfagg   = imgLabel(rdfagglabel, imgarr, numimg);
if show_fig
    figure; imagesc(rdfagglabel); title('Label aggregated');
end
    
%% filter result
r           = ceil(max(size(aifrdf, 1), size(aifrdf, 2)) / 40);
eps         = 0.01^2;
tic
if use_fast_jwmf
    rdf_labels      = jointWMF(rdfagglabel, im2double(aifrdfagg), 3, 0.2, 256, 30);
else
    rdf_labels      = weighted_median_filter(double(rdfagglabel),im2double(aifrdfagg), 1:numimg, r, eps);
end
toc
im_all_in_focus     = imgLabel(rdf_labels, imgarr, numimg);

if show_fig
    figure; imshow(im_all_in_focus);  title('RDF all in focus image');
    figure; imshow(rdf_labels / 30);  title('RDF result');
end


