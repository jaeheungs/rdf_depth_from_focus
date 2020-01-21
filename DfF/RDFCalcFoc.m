function [ focrdf ] = RDFCalcFoc( imgarr, maskarr, in, gap, out, numimg )
% focrdf = RDFCalcFoc( imgarr, maskarr, in, gap, out, numimg )

rdf = -(ceil(fspecial('disk', in + gap + out - 1)) - ceil(padarray(padarray(fspecial('disk', in + gap - 1), out, 0)', out, 0)));
rdf(rdf > 0) = 0;
rdf(floor(in / 2) + gap + out + 1, floor(in / 2) + gap + out + 1) = -sum(rdf(:));

fprintf('RDF Focus Measure: \t\t\t\t');
tic
focrdf = zeros([size(maskarr{1}), numimg]);
for i = 1:numimg
    focrdf(:,:,i) = sqrt(sum((imfilter(imgarr{i}, rdf, 'replicate', 'conv')).^2, 3));
    mask = imfilter(maskarr{i}, fspecial('average', in + 2 * (gap + out)), 'replicate', 'conv') > 0.999;
    focrdf(:,:,i) = focrdf(:,:,i) .* mask - 5 .* ~mask;
end
toc

end

