Depth from Focus using Ring Difference Filter (RDF)
===================================================

| [Paper (CVPR - spotlight)][ref_cvpr] | [Paper (TIP)][ref_tip] | [Project Page + Video][ref_project_page] |

Official implementation of "Noise Robust Depth from Focus using a Ring Difference Filter" (CVPR 2017) and "Ring Difference Filter for Fast and Noise Robust Depth From Focus
" (TIP 2019).

Note: This code was used for the quantitative analysis in the paper (bokeh detection, unreliable depth rejection, and tree propagation are not included)

- Usage:
	+ run `demo.m` for an example run on the `Buddha` set
	+ set `use_rdf_agg` to `false` for CVPR version or to `true` 
	```matlab
	[rdf_labels, im_all_in_focus] = RDF_DFF(pathval, regexp, i_start, numimg, 
	show_fig, resize, use_parallel, use_rdf_agg, use_fast_jwmf, saveimg)

	% Inputs:
	%     pathval:            (str)   path to input image set
	%     regexp:             (str)   format of image naming
	%     i_start:            (int)   path to input image set
	%     numimg:             (int)   number of images
	%     show_fig:           (bool)  [default: true]  switch to render intermediate figures
	%     resize:             (float) [default: 0.5]   factor to resize image for aligning images
	%     use_parallel:       (bool)  [default: true]  switch to use parallel processing (need toolbox)
	%     use_rdf_agg:        (bool)  [default: false] switch to use RDF-based aggregation
	%     use_fast_jwmf:      (bool)  [default: false] switch to use fast weighted median filtering for end
	%     saveimg:            (bool)  [default: false] switch to save intermediate images during alignment
	% 
	% Outputs:
	%     rdf_labels:         (matrix of double) 
	%     im_all_in_focus:    (image in double)
	    
	```


[ref_cvpr]: https://jaeheungs.github.io/assets/pdf/CVPR2017_RDF.pdf "RDF CVPR Paper"
[ref_tip]: https://ieeexplore.ieee.org/document/8818667 "RDF TIP Paper"
[ref_project_page]: https://jaeheungs.github.io/pubs/2017-07-01-ring-difference-filter.html