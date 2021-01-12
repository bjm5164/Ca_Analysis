%% Load Image Data
% This code uses bf_formats to input .tif or .czi calcium imaging files.
% It relies on a number of other sctips, which should be in the same file.
% The workflow is as follows:  
%   1:  Load a single experiment file.  This can be standard calcium
%   imaging data, or with stimuli.  Importantly, this code was written to analyze
%   calcium imaging data from a Zeiss LSM, and some stimulus related
%   metadata is not read correctly from bioformats.  For this reason, you
%   will need to fix the load_image_data.m and get_photostim_info.m files if you want to use file
%   formats that have metadata structures that difer from a .czi.  
%   2:  Rotate and crop image data.  This will cutdown on runtime if you
%   only want to analyze part of your image file.  The crop is only xy.
%   3: Rigid image registration.  This is fairly low level motion
%   correction.
%   4:  Make ROIs 
%   5:  Extract traces from ROIs
%   6:  Analyze Stimulus Data
%   7:  Basic trace analysis
%   8:  Save output files

close all; clear all
if input('Stimulus Data? 1:Yes 0:No  :') == 1
    [image_data,meta_data,f_name,stim_meta] = load_image_data(1);
else
    [image_data,meta_data,f_name] = load_image_data(0);
end
experiment_name = strsplit(f_name,'.');
experiment_name = experiment_name{1,1};
if input('Save Figs? Yes:1  :') == 1
    fprintf('Choose Output Directory for Figures');
    psfile = strcat(uigetdir,'/',experiment_name,'.ps')
    if exist(psfile,'file')==2;delete(psfile);end
end
fprintf('Select Output Directory for Data');
mat_file_outpur_dir = uigetdir
clear f_name
%% Roatate and Crop
[rotated] = rotate_and_crop(image_data); clear image_data
close all
%% Register with Rigid
[registered] = register_image(rotated); clear rotated



%% Lineage Bleach Correct 
% not sure if this works yet.

%[detrended,time] = linear_bleach_correct(reg_crop,meta_data); %clear reg_crop


%% Make ROIs
if exist('psfile','var');
[ROIs Image_ROIs] = make_ROIs_v2(registered,psfile)
else
[ROIs Image_ROIs] = make_ROIs_v2(registered)  
end
%% Get Traces
time = [0:1:size(registered,3)-1]*double(meta_data.getPixelsTimeIncrement(0).value)
for i_chan = 1:size(Image_ROIs{1,1},4)
    for i = 1:length(Image_ROIs)
        for u = 1:size(Image_ROIs{1,1},3)
            frame = Image_ROIs{i}(:,:,u,i_chan);
            traces(u,i,i_chan) = mean(frame(:));
             axis([0 60 -0.5 3])
        %ylim([input('ymin?'),input('ymax?')])
    end
end
end


% if size(Image_ROIs{1,1},4) == 2
%     plot(time,traces(:,:,1),'r'); hold on
%     plot(time,traces(:,:,2),'g');
%     title('Raw Traces')
% else
%     plot(time,traces(:,:,1),'r'); hold on
%     title('Raw Traces')
% end

%% Calculate Stim-Locked averages
calc_stim = input('Calculate Stimulus Average? 1:yes 0:no') == 1
if calc_stim == 1
    number_of_stimuli = 3;
    stim_meta.stim_length = input('Stim Length?')
    [Trace_Data] = plot_stim_averages(traces,time,stim_meta,number_of_stimuli);
else
end
if exist('psfile','var'); set(gcf, 'PaperPositionMode', 'auto'); print('-dpsc',psfile,'-append'); end
%% Analyze Traces
% Columns of trace data are each ROI, Rows are time points
if exist('psfile','var');
    if meta_data.getChannelCount(0) == 2
    
        [df_1] = quick_gcamp(traces(:,:,1),time,1,psfile);
        [df_2] = quick_gcamp(traces(:,:,2),time,2,psfile);
    
        figure; hold on
        plot(time,df_1,'r'); 
        plot(time,df_2,'g');
        legend(['Channel 1';'Channel 2'])
       
    else
        [df_1] = quick_gcamp(traces(:,:,1),time,1,psfile);
    end
else
    if meta_data.getChannelCount(0) == 2
    
        [df_1] = quick_gcamp(traces(:,:,1),time,1);
        [df_2] = quick_gcamp(traces(:,:,2),time,2);
    
        figure; hold on
        plot(time,df_1,'r'); 
        plot(time,df_2,'g');
        legend(['Channel 1';'Channel 2'])
    else
        [df_1] = quick_gcamp(traces(:,:,1),time,1);
    end    
end
%%  Save Data
if exist('Trace_Data','var') == 1
save(strcat(mat_file_outpur_dir,'/',experiment_name,'_Trace_Data.mat'),'Trace_Data')
else
end


if exist('df_2','var') == 1 & calc_stim == 1
save(strcat(mat_file_outpur_dir,'/',experiment_name,'_Variables.mat'),'registered','ROIs','stim_meta','traces','df_1','df_2')
elseif exist('df_2','var') == 0 & calc_stim == 1
save(strcat(mat_file_outpur_dir,'/',experiment_name,'_Variables.mat'),'registered','ROIs','stim_meta','traces','df_1')
elseif exist('df_2','var') == 1 & calc_stim == 0
save(strcat(mat_file_outpur_dir,'/',experiment_name,'_Variables.mat'),'registered','ROIs','traces','df_1','df_2')
else
save(strcat(mat_file_outpur_dir,'/',experiment_name,'_Variables.mat'),'registered','ROIs','traces','df_1')
end

% CSV_file = input('Save CSV? Yes:1 No:0')
% if CSV_file == 1
%     
    