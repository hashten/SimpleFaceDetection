function [ dets] = ScanImageOverScale( Cparams,im,min_s,max_s,step_s )
% This function will call the ScanImageFixedSize a number of times with
% different sizes of the patch window

im = imread(im);
if ndims(im)>2
    im = rgb2gray(im);
    display('Image transformed to gray...');   
end
    
scale = min_s:step_s:max_s;

images = cell(length(scale),1);
% dets = cell(length(scale),2);
dets = [];
for i = 1:length(scale)
    images{i} = imresize(im,scale(i));
    beforeadd=size(dets,1);
    dets = [dets; ScanImageFixedSize(Cparams,images{i})/scale(i)];
    afteradd =size(dets,1);
    display(['At Scale' num2str(scale(i)) 'there were: ' num2str(afteradd-beforeadd) 'faces.']);
end

% scale = round(19*1./scale); %This is inverted because the scale refers to the img
% dets = [];
% for sc = scale
%     dets = [dets; ScanImageFixedSize( Cparams, im, sc)];
% end



end

