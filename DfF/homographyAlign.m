function [ imgarr, maskarr, bwiarr ] = homographyAlign( imgs, resize, numimg, pathval, saveimg )

imgarr = cell(1,numimg);
imgarr{1} = im2double(imgs{1});
maskarr = cell(1,numimg);
maskarr{1} = ones(size(imgs{1}(:,:,1)));
bwiarr = zeros(size(imgs{1}, 1), size(imgs{1}, 2), numimg);
bwiarr(:,:,1) = rgb2gray(im2double(imgarr{1}));

ref = imresize(bwiarr(:,:,1), resize);
init = eye(3);

[u, v] = meshgrid(1:size(imgs{1}, 2), 1:size(imgs{1}, 1));
uv = [u(:), v(:), ones(numel(u), 1)]';

fprintf('Homography Image Align: \n');
asd = tic;
for i=2:numimg
    transform='homography';
    bwitrg = rgb2gray(im2double(imgs{i}));
    trg = imresize(bwitrg, resize);
    [~, warp, ~]=ecc(trg, ref, 3, 3, transform, init);
    init = warp;
    
    H = diag(1./[resize,resize,1]) * warp * diag([resize,resize,1]);
    uvnew = H * uv;
    uvnew = uvnew ./ repmat(uvnew(3,:), 3, 1);
    bwiarr(:,:,i) = reshape(interp2(bwitrg, uvnew(1,:), uvnew(2,:)),size(imgs{1}, 1), size(imgs{1}, 2));
    imgarr{i} = reshape(interp2(im2double(imgs{i}(:,:,1)), uvnew(1,:), uvnew(2,:)),size(imgs{1}, 1), size(imgs{1}, 2));
    imgarr{i}(:,:,2) = reshape(interp2(im2double(imgs{i}(:,:,2)), uvnew(1,:), uvnew(2,:)),size(imgs{1}, 1), size(imgs{1}, 2));
    imgarr{i}(:,:,3) = reshape(interp2(im2double(imgs{i}(:,:,3)), uvnew(1,:), uvnew(2,:)),size(imgs{1}, 1), size(imgs{1}, 2));
    imgarr{i}(isnan(imgarr{i})) = 0;
    maskarr{i} = reshape(interp2(maskarr{1}, uvnew(1,:), uvnew(2,:)),size(maskarr{1}, 1), size(maskarr{1}, 2));
    maskarr{i}(isnan(maskarr{i})) = 0;
end
bwiarr(isnan(bwiarr)) = 0;
fprintf('Total Time: \t\t\t\t\t');
toc(asd);

if saveimg == 1
    mkdir([pathval 'homography\']);
    addpath([pathval 'homography']);

    for i = 1:numimg
        imwrite(imgarr{i}, [pathval sprintf('homography\\%02d.bmp',i)]);
        imwrite(uint8(maskarr{i}.*255), [pathval sprintf('homography\\mask_%02d.bmp',i)]);
    end
end


end

