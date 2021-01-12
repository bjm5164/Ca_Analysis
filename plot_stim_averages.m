function [Trace_Data] = plot_stim_averages(traces,time,stim_meta,number_of_stimuli)
% Make average stimulus response traces.  This script is designed for imaging applications that are not simultaneous excitation/recording.  Pre-stimulus period is equivalent
% to the number of frames before the first stimulus.  Subsequent
% pre-stimulus periods are the same number of frames before each subsequent
% stimulus.  DF/F0 Calculations are done by using the mean pre-stimulus period
% for each stimulus.

fs = stim_meta.fs %% Frame Rate
clear pre_stim_recording and post_stim_recording
figure('rend','painters','pos',[10 10 450 900])
for u_traces = 1:size(traces,2)
    
for i = 1:number_of_stimuli
    pre_stim_recording(:,i) = traces(stim_meta.stim_index(i)-2:stim_meta.stim_index(i),u_traces); % Calculate pre-stimulus traces
    post_stim_recording(:,i) = traces(stim_meta.stim_index(i)+1:stim_meta.stim_index(i)+1+round(stim_meta.Repetitions*.3),u_traces); % Calculate post-stimulus traces
end
f_min = mean(pre_stim_recording); % F_min for DF/F calculations

pre_stim_df = (pre_stim_recording-f_min)./f_min; 
post_stim_df = (post_stim_recording-f_min)./f_min;

pre_stim_mean = mean(pre_stim_df,2);
post_stim_mean = mean(post_stim_df,2);

std_pre = std(pre_stim_df,[],2);
std_post = std(post_stim_df,[],2);

Trace_Data(u_traces).pre_stim_df = pre_stim_df;
Trace_Data(u_traces).post_stim_df = post_stim_df;
Trace_Data(u_traces).pre_stim_mean = pre_stim_mean;
Trace_Data(u_traces).post_stim_mean = post_stim_mean;
Trace_Data(u_traces).std_pre = std_pre;
Trace_Data(u_traces).std_post = std_post;
Trace_Data(u_traces).time = time;
Trace_Data(u_traces).stim_meta = stim_meta;
Trace_Data(u_traces).raw_traces = traces;

subplot(size(traces,2),1,u_traces);hold on
shadedErrorBar([0:fs:time(size(pre_stim_recording,1))],pre_stim_mean,std_pre,'lineProps',{'LineWidth',2,'Color','k'},'transparent',1)
hold on
rectangle('Position',[time(stim_meta.stim_index(1)), min(pre_stim_mean)-max(std_pre), stim_meta.stim_length, .05],'EdgeColor','r','FaceColor','r')
shadedErrorBar(time(stim_meta.stim_index(1))+stim_meta.stim_length:fs:time(stim_meta.stim_index(1)+round(stim_meta.Repetitions*.3))+stim_meta.stim_length,post_stim_mean,std_post,'lineProps',{'LineWidth',2,'Color','k'},'transparent',1)
plot([time(stim_meta.stim_index(1)),time(stim_meta.stim_index(1))+stim_meta.stim_length],[pre_stim_mean(length(pre_stim_mean)),post_stim_mean(1)],'LineStyle','-.')

%ylim([0 max(post_stim_mean(:)+2*std_post)])
xlabel('Time (s)')
ylabel('DF/F')
set(gcf,'Color','w')
set(findall(gcf,'-property','FontSize'),'FontSize',18);
title(strcat('ROI: ',sprintf('%1g',u_traces)))
ylim([min(pre_stim_mean)-max(std_pre),max(post_stim_mean)+max(std_post)])

end
end
%%

