function [reg_crop, rect] = rotate_and_crop(image_series)
 % This function will rotate an image and crop it down to the region of
 % interest
    imagesc(max(image_series(:,:,:,1),[],3)); % make a max projection to see if you want to rotate
    deg = input('How many degrees to rotate?')
    display('Select region to use for analysis.') 
    rotated = imrotate(image_series,deg); 
    mip = max(rotated(:,:,:,1),[],3); 
    mip_fig = imagesc(mip) % draw an ROI rectangle to crop
    rect = getrect;
    for i_chan = 1:size(image_series,4);
        for i = 1:size(rotated,3)
            reg_crop(:,:,i,i_chan) = imcrop(rotated(:,:,i,i_chan),rect);
        end
    end
end