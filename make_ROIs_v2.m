function [ROIs Image_ROIs] = make_ROIs_v2(image,psfile)
% Make square ROIs around a selected center point.  This does not yet work
% with 2 color images.

if size(image,4) == 2
    mean_one = mean(image(:,:,:,1),3);
    mean_two = mean(image(:,:,:,2),3);
    imshowpair(mean_one,mean_two)
else 
    mean_new = max(image(:,:,:,1),[],3);
    imagesc(mean_new); colormap gray
end
        
if exist('psfile','var'); set(gcf, 'PaperPositionMode', 'auto'); print('-dpsc',psfile,'-append'); end

if size(image,4) == 2
    disp('Get Channel 1 ROIs')
    disp('Press Enter when done')
    [x_c1,y_c1] = getpts
    disp('Get Channel 2 ROIs')
    disp('Press Enter when done')
    [x_c2,y_c2] = getpts
else
    disp('Select ROI centers')
    disp('Press Enter when done')
    [xi,yi] = getpts
    hold on;
    for n_roi = 1:size(xi,1)
        ROIs(n_roi,:) = [xi(n_roi)-5,yi(n_roi)-30,10,60]
        rectangle('Position',ROIs(n_roi,:),'EdgeColor','r','LineWidth',2)
    end
        
end
    

for i_chan = 1:size(image,4);
    for i = 1:size(xi,1)
        for u = 1:size(image,3)
            Image_ROIs{i}(:,:,u,i_chan) = imcrop(image(:,:,u,i_chan),ROIs(i,:));
        end
    end
end


end 