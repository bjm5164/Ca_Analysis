function [df] = df_transform(time,neurons)
%% Filtering
neuronsF = sgolayfilt(neurons,3,5);  %% s. golay filter on intensity values

%% Calculate DF/F with moving F0
% To avoid substantial bleaching issues, we use a DF/F calculation that
% employs a sliding F0.  The sliding frame length is 20% of the movie, and
% we recalculate F0 using this sliding frame.  F0 is the mean of the lowest
% 10% of values within a frame. 
interval = round(.2*length(time));
clear f0 and sorted and df
for u = 1:size(neuronsF,2)
    for i = 1:length(time)-interval
    sorted(:,u) = sort(neuronsF(i:i+interval,u));
    f0(i,u) = mean(sorted(round(.1*interval),u));
    df(i:i+interval,u) = (neuronsF(i:i+interval,u)-f0(i,u))/f0(i,u);
    end
end
% figure
% for i = 1:size(neuronsF,2)
%     subplot(round(size(neurons,2)/2),2,i)
%     plot(time,df(:,i));
% end
% 
% figure
% plot(time,neuronsF)
% figure
% plot(time,df(:,1:3))
end