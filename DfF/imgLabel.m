function [ sharpimg ] = imgLabel( label, imgarr, numimg )

sharpimg = imgarr{1};
[~, ~, c] = size(sharpimg);
label3D = repmat(label, 1, 1, c);
for i = 1 : numimg
    sharpimg(label3D == i) = imgarr{i}(label3D == i);
end

end

