function [df] = quick_gcamp(neurons,time,channel,psfile)
%neuronsF = sgolayfilt(neurons,1,3);
if channel == 1
    c = 'r'
    channel = 'Channel 1'
else c = 'g'
    channel = 'Channel 2'
end
%% Calculate DF/F
df=ones(size(neurons));
% for d = 1:size(neurons,2);
%    df(:,d) = ((neuronsF(:,d)-min(neuronsF(1:length(time),d))))/(min(neuronsF(1:length(time),d)));
% end

df = df_transform(time,neurons)


dt = input('Bleaching? 1:Yes 0:no')
if dt == 1
    detrended = detrend(df);
else
    detrended = df;
end
figure; subplot(2,1,1)
plot(time,neurons); set(findall(gcf,'-property','FontSize'),'FontSize',18); set(gcf,'Color','w'); 
xlabel('Time (s)')
ylabel('Intensity (AU)')
title([channel,' ', 'Raw Traces'])

subplot(2,1,2)
plot(time,detrended); set(findall(gcf,'-property','FontSize'),'FontSize',18); set(gcf,'Color','w'); 
xlabel('Time (s)')
ylabel('DF/F')
title([channel,' ', 'DF/F Traces'])

if exist('psfile','var'); set(gcf, 'PaperPositionMode', 'auto'); print('-dpsc',psfile,'-append'); end
%% Plot all
figure
for d = 1:size(neurons,2); % raw traces
hold on 
subplot(1,size(neurons,2),d)
plot(time,neurons(:,d),c);
xlabel('Time (s)')
ylabel('Intensity (AU)')
title([channel,' ', 'Raw Traces'])
set(findall(gcf,'-property','FontSize'),'FontSize',14); set(gcf,'Color','w');
end
if exist('psfile','var'); set(gcf, 'PaperPositionMode', 'auto'); print('-dpsc',psfile,'-append'); end
figure    
for d = 1:size(neurons,2); % df/f
hold on 
subplot(1,size(neurons,2),d)
plot(time,detrended(:,d),c);
xlabel('Time (s)')
ylabel('DF/F')
title([channel,' ', 'DF/F Traces'])
set(findall(gcf,'-property','FontSize'),'FontSize',14); set(gcf,'Color','w');
end
if exist('psfile','var'); set(gcf, 'PaperPositionMode', 'auto'); print('-dpsc',psfile,'-append'); end
% %% thresholding and find active neurons
% sizes = (size(detrended,1)-1);
% thresholded_neurons = zeros(size(detrended));
% for i = 1:size(detrended,1);
%     for u = 1:size(detrended,2);
%         if detrended(i,u)>.48;
%             thresholded_neurons(i,u) = detrended(i,u);
%         else thresholded_neurons(i,u) = 0;
%         end
%     end
% end
% figure
% imagesc(detrended',[0 1])
% 
% active_neuronidx = ones(1,size(detrended,2));
% for i = 1:size(detrended,2);
%     if sum(thresholded_neurons(:,i)) == 0;
%         active_neuronidx(i) = 0;
%     else active_neuronidx(i) = 1;
%     end
% end
% active_neurons = thresholded_neurons(:,active_neuronidx==1);
% 
% fs = 5
% [pxxM,fm] = periodogram(mean(active_neurons,2),[],[],fs);
% colormap = parula;
% co = colormap;
% coo = co(1:5:(size(co,1)/2),:)
% set(groot,'defaultAxesColorOrder',coo);
% figure
% [pxx,f] = periodogram(active_neurons,[],[],fs);
% plot(f,pxx,'LineWidth',1)
% hold on
% plot(fm,pxxM,'r','LineWidth',2)
% ax = gca;
% ax.XLim = [0 3];
% ax.YLim = [0 1];
% xlabel('Frequency (Hz)')
% ylabel('Magnitude')
% title('Power Spectrum Analysis')

%% 
% dataCorr = corrcoef(detrended); figure
% imagesc(dataCorr,[-1 1]); xlabel(''); ylabel(''); axis xy; colorbar; title('correlation matrix'); set(gcf,'Color','w')
end
