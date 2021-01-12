---
title: "README"

---

This repository contains calcium imaging analysis scripts written MATLAB used for: "Regulation of subcellular dendritic synapse specificity by axon guidance cues" by Sales et al 2019.  The scripts use the open microscopy bioformats package to read either .czi or .tif files, although they can be easily adapted for any file type.  

To use the package, run Calcium_Imaging_Script and follow the prompt instructions.

There are two outputs of the Calcium_Imaging_Script.  

	1.  Variable output:   includes the registered image data, ROIs, stimulus metadata, raw traces, and DF/F traces.  This file will exist regardless of whether stimulus data was analyzed. 

	2.  Trace_Data output: includes a structure containing the relevant variables used for analyzing stimulus data.

In order to generate the average stimulus traces across animals,  run Average_Traces.m.  This file will take all Trace_Data files you wish to average, and output an average simulus response graph as well as two .mat files: 

	1.  Average_Trace_Data:  Essentially all of the data used to calculate the average trace including included experiment names, pre/post-stimulus df values, and stimulus metadata.

	2.  Post_stimulus_DF:  This contains a single vector which includes the post-stimulus DF values from each experiement.  
    
In order to generate the bargraph of DF/F changes across two conditions, run Average_Stim_Bar_Graph.m.  This file will just take the post-stim_df values from two relevant conditions and make a bargraph and do basic stats.



DEPENDENCIES:

	1. Bioformats: https://www.openmicroscopy.org/bio-formats/downloads/
	2. ShadedErrorBar: https://github.com/raacampbell/shadedErrorBar


For any questions, contact me at
bjm5164@gmail.com
-Brandon Mark
