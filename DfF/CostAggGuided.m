%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C Rhemann et al.,
% Fast cost-volume filtering for visual correspondence and beyond
% CVPR 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% note : This code is slightly modified by Hae-Gon Jeon and Jaeheung Surh

function dispVol1=CostAggGuided(E1,Ic,param)

r = param.r;
eps = param.eps;           
numLabel = size(E1,3);
% im_cen = Ic;

E1_cell = squeeze(num2cell(E1,[1 2]));
dispVol1_cell = cell(1,1,numLabel);

for d=1:numLabel % use regular for loop when not using the parallel computing toolbox
    p1 = E1_cell{d};
    q1 = fastguidedfilter_color(im2double(Ic), p1, r, eps, r/4);
    dispVol1_cell{d} = q1;
    fprintf('CostAgg.. cost slice %d.\n',d);
end
% parpool close;
dispVol1=cell2mat(dispVol1_cell);