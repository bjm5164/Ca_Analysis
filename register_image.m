function [reg] = register_image(image_series)
% Register images with rigid movement correction.  This is pretty low level
% image registration, but it works for stable ex-vivo preps. 
[optimizer,metric] = imregconfig('monomodal');
optimizer = registration.optimizer.OnePlusOneEvolutionary
optimizer.InitialRadius = .0001;
optimizer.Epsilon = 1.5e-8;
optimizer.GrowthFactor = 3;
optimizer.MaximumIterations = 100;

registered = ones(size(image_series));
for i_chan = 1:size(image_series,4)
    
    fixed = image_series(:,:,1,i_chan);
    registered(:,:,1,i_chan) = fixed;
    i = 2;
    while i<=size(image_series,3)-1
         registered(:,:,i,i_chan) = imregister(image_series(:,:,i,i_chan),image_series(:,:,i-1,i_chan),'similarity',optimizer,metric);
         i = i+1;
         disp(['Channel',' ',num2str(i_chan),': ',num2str((i/size(image_series,3))*100),'% Complete']); 
    end
end
reg = registered(:,:,1:size(image_series,3)-1,:);
end
