function [image_series_mat_c,Meta_data,fname,stim_meta] = load_image_data(stim)
% Load a czi or tif file.  Theoretically this should work for more than
% just CZI and Tif files because it uses bioformats which can read lots of
% formats. I only tested this with CZI and Tif files.  The stimulus locked
% experiments only work with CZI files because the way to extract the
% bleach metadata is microscope specific.
    file_type = input('Tiff: 1 / CZI: 2') % pick a file type
    if file_type == 1
        ft = '*.tif'
    else
        ft = '*.czi'
    end
    [fname,pathname] = uigetfile(ft); % get file
    image_data = bfopen(strcat(pathname,fname)); %uses bfopen to load the image data into the bioformats cell array
    for i = 1:size(image_data{1,1},1)
    image_series_mat(:,:,i) = image_data{1,1}{i,1}; % extracts the image frames from the bf cell array
    end
    Meta_data = image_data{1,4} % get the OMEXML metadata
    
    omd = image_data{1, 2}; % get the raw metadata (microscope specific)
    if file_type == 2 & stim == 1
        if str2num(omd.get('Global Experiment|AcquisitionBlock|BleachingSetup|Repetition #2'))>0; %check to see if bleaching was used
           [stim_meta] = get_photostim_info(omd) % if so, get the photostim meta
           stim_meta.fs = double(Meta_data.getPixelsTimeIncrement(0).value)
           time = [0:1:size(image_series_mat,3)-1]*stim_meta.fs;
           stim_meta.first_stim = stim_meta.fs*stim_meta.Start_Index;
           stim_meta.stim_length = stim_meta.fs*stim_meta.Iterations;
           stim_meta.stim_index = [stim_meta.Start_Index:stim_meta.Repetitions:size(image_series_mat,3)];
        else
            stim_meta = []
        end
    else 
    end
    if  Meta_data.getChannelCount(0) == 2 % get channel number, if its 2, make two channels.
          image_series_mat_c(:,:,:,1) = image_series_mat(:,:,1:2:size(image_series_mat,3));
          image_series_mat_c(:,:,:,2) = image_series_mat(:,:,2:2:size(image_series_mat,3));
    else 
          image_series_mat_c(:,:,:,1) = image_series_mat(:,:,:);
    end
    
end
   