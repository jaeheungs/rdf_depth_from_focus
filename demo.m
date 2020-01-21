pathval     = '.\dataset\Buddha\';
regexp      = '%02d.png';

[rdf_labels, im_all_in_focus] = RDF_DFF(pathval, regexp, 1, 30);
% [rdf_labels, im_all_in_focus] = RDF_DFF(pathval, regexp, i_start, numimg, 
% show_fig, resize, use_parallel, use_rdf_agg, use_fast_jwmf, saveimg)
% 
% Inputs:
%     pathval:            (str)   path to input image set
%     regexp:             (str)   format of image naming
%     i_start:            (int)   path to input image set
%     numimg:             (int)   number of images
%     show_fig:           (bool)  switch to render intermediate figures
%     resize:             (float) factor to resize image for aligning images
%     use_parallel:       (bool)  switch to use parallel processing (need toolbox)
%     use_rdf_agg:        (bool)  switch to use RDF-based aggregation
%     use_fast_jwmf:      (bool)  switch to use fast weighted median filtering for end
%     saveimg:            (bool)  switch to save intermediate images during alignment
% 
% Outputs:
%     rdf_labels:         (matrix of double) 
%     im_all_in_focus:    (image in double)
%     