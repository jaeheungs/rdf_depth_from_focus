function [q, a, b] = guided_rdf(I, p, r, eps)
%   GUIDEDFILTER_COLOR   O(1) time implementation of guided filter using a color image as the guidance.
%
%   - guidance image: I (should be a color (RGB) image)
%   - filtering input image: p (should be a gray-scale/single channel image)
%   - local window radius: r
%   - regularization parameter: eps

[hei, wid] = size(p);
N = boxfilter_rdf(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I_r = boxfilter_rdf(I(:, :, 1), r) ./ N;
mean_I_g = boxfilter_rdf(I(:, :, 2), r) ./ N;
mean_I_b = boxfilter_rdf(I(:, :, 3), r) ./ N;

mean_p = boxfilter_rdf(p, r) ./ N;

mean_Ip_r = boxfilter_rdf(I(:, :, 1).*p, r) ./ N;
mean_Ip_g = boxfilter_rdf(I(:, :, 2).*p, r) ./ N;
mean_Ip_b = boxfilter_rdf(I(:, :, 3).*p, r) ./ N;

% covariance of (I, p) in each local patch.
cov_Ip_r = mean_Ip_r - mean_I_r .* mean_p;
cov_Ip_g = mean_Ip_g - mean_I_g .* mean_p;
cov_Ip_b = mean_Ip_b - mean_I_b .* mean_p;

% variance of I in each local patch: the matrix Sigma in Eqn (14).
% Note the variance in each local patch is a 3x3 symmetric matrix:
%           rr, rg, rb
%   Sigma = rg, gg, gb
%           rb, gb, bb
var_I_rr = boxfilter_rdf(I(:, :, 1).*I(:, :, 1), r) ./ N - mean_I_r .*  mean_I_r; 
var_I_rg = boxfilter_rdf(I(:, :, 1).*I(:, :, 2), r) ./ N - mean_I_r .*  mean_I_g; 
var_I_rb = boxfilter_rdf(I(:, :, 1).*I(:, :, 3), r) ./ N - mean_I_r .*  mean_I_b; 
var_I_gg = boxfilter_rdf(I(:, :, 2).*I(:, :, 2), r) ./ N - mean_I_g .*  mean_I_g; 
var_I_gb = boxfilter_rdf(I(:, :, 2).*I(:, :, 3), r) ./ N - mean_I_g .*  mean_I_b; 
var_I_bb = boxfilter_rdf(I(:, :, 3).*I(:, :, 3), r) ./ N - mean_I_b .*  mean_I_b;

% Sigma + eps * eye(3)
Sigma = [var_I_rr(:) + eps,var_I_rg(:),var_I_rb(:),var_I_rg(:),var_I_gg(:)+ eps,var_I_gb(:),var_I_rb(:),var_I_gb(:),var_I_bb(:)+ eps];
cov_Ip = [cov_Ip_r(:), cov_Ip_g(:), cov_Ip_b(:)];
cSigma  = num2cell(Sigma,2);
cCov_Ip = num2cell(cov_Ip,2);
cAk = cellfun(@calc_ak,cSigma,cCov_Ip,'UniformOutput',false);
ak = cell2mat(cAk);
a = reshape(ak,hei,wid,[]);

b = mean_p - a(:, :, 1) .* mean_I_r - a(:, :, 2) .* mean_I_g - a(:, :, 3) .* mean_I_b; % Eqn. (15) in the paper;

q = (boxfilter_rdf(a(:, :, 1), r).* I(:, :, 1)...
	+boxfilter_rdf(a(:, :, 2), r).* I(:, :, 2)...
    +boxfilter_rdf(a(:, :, 3), r).* I(:, :, 3)...
    +boxfilter_rdf(b, r)) ./ N;  % Eqn. (16) in the paper;
end

function y = calc_ak(sigma,cov_Ip)
sigma_ = reshape(sigma,3,3);
y = cov_Ip / sigma_;
end