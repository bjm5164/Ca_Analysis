%% Average Across Experiments
clear all; close all
number_of_experiments = input('How Many Animals?')

for i = 1:number_of_experiments
    [filename, pathname] = uigetfile('*Trace_Data.mat')
    load(strcat(pathname,'/',filename));
    experiment_name = strsplit(filename,'.');
    experiment_name = experiment_name{1,1};
    Experiments(i).Experiment_Name = experiment_name; clear filename and experiment_name and pathname
    Experiments(i).Trace_Data = Trace_Data; clear Trace_Data 
end

%% 
% Columns of trace data are each ROI, Rows are time points
clear ps_df and mean_per_ROI_ps_df and post_df and ps_df_m and std_pre and std_post and mean_per_ROI_post_df
for i = 1:number_of_experiments
    ps_df{i} = Experiments(i).Trace_Data.pre_stim_df;
    post_df{i} = Experiments(i).Trace_Data.post_stim_df;
    ps_df_m{i} = Experiments(i).Trace_Data.pre_stim_mean;
    post_df_m{i} = Experiments(i).Trace_Data.post_stim_mean;
    std_pre{i} = Experiments(i).Trace_Data.std_pre;
    std_post{i} = Experiments(i).Trace_Data.std_post;
    mean_per_ROI_ps_df(:,i) = mean(ps_df{1,i},2);
    mean_per_ROI_post_df(:,i) = mean(post_df{1,i},2);
end

time = Experiments(1).Trace_Data.time;
stim_meta = Experiments(1).Trace_Data.stim_meta;
fs = stim_meta.fs
mean_all_animal_psdf = mean(mean_per_ROI_ps_df,2);
mean_all_animal_postdf = mean(mean_per_ROI_post_df,2);
pre_std_all_animal = std(mean_per_ROI_ps_df,[],2);
post_std_all_animal = std(mean_per_ROI_post_df,[],2);

figure;hold on
shadedErrorBar([0:fs:time(size(mean_all_animal_psdf,1))],mean_all_animal_psdf,pre_std_all_animal,'lineProps',{'LineWidth',2,'Color','k'},'transparent',1)
hold on
rectangle('Position',[time(stim_meta.stim_index(1)), min(mean_all_animal_psdf)-max(pre_std_all_animal), stim_meta.stim_length, .05],'EdgeColor','r','FaceColor','r')
shadedErrorBar(time(stim_meta.stim_index(1))+stim_meta.stim_length:fs:time(stim_meta.stim_index(1)+round(stim_meta.Repetitions*.3))+stim_meta.stim_length,mean_all_animal_postdf,post_std_all_animal,'lineProps',{'LineWidth',2,'Color','k'},'transparent',1)
plot([time(stim_meta.stim_index(1)),time(stim_meta.stim_index(1))+stim_meta.stim_length],[mean_all_animal_psdf(length(mean_all_animal_psdf)),mean_all_animal_postdf(1)],'LineStyle','-.')
%ylim([0 max(post_stim_mean(:)+2*std_post)])
xlim([0 8])
xlabel('Time (s)')
ylabel('DF/F')
set(gcf,'Color','w')
set(findall(gcf,'-property','FontSize'),'FontSize',18);
ylim([input('ymin?'),input('ymax?')])


Post_stimulus_delta_f = mean(mean_per_ROI_post_df(1:4, :)); %take avg of first four frames post-stimulus from all columns. orgininally mean_per_ROI_post_df(1,:);

e1 = strsplit(Experiments(1).Experiment_Name,'_');
included_experiments = e1{1,1}; clear e1
for i = 2:number_of_experiments
    e1 = strsplit(Experiments(i).Experiment_Name,'_')
    included_experiments = strcat(included_experiments,'_',e1{1,1}); clear e1
end

if input('Save Figure? yes:1 no:0') == 1
    saveas(gcf,strcat(uigetdir,'/','Average_Traces_from ',included_experiments,'.svg'))
else 
end
disp('Where to save variables?')
clear path_name; [path_name] = uigetdir;
save(strcat(path_name,'/','Average_Traces_Data_from',included_experiments)); 
save(strcat(path_name,'/','Post_Stimulus_Df_from',included_experiments),'Post_stimulus_delta_f');